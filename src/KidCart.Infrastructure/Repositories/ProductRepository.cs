using KidCart.Domain.Entities;
using KidCart.Domain.Enums;
using KidCart.Domain.Interfaces;
using KidCart.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace KidCart.Infrastructure.Repositories;

public class ProductRepository : Repository<Product>, IProductRepository
{
    public ProductRepository(KidCartDbContext context) : base(context) { }

    public async Task<Product?> GetBySlugAsync(string slug, CancellationToken cancellationToken = default)
        => await _dbSet
            .Include(p => p.Category)
            .Include(p => p.Variants)
            .Include(p => p.Images)
            .FirstOrDefaultAsync(p => p.Slug == slug, cancellationToken);

    public async Task<IReadOnlyList<Product>> GetByCategoryAsync(Guid categoryId, CancellationToken cancellationToken = default)
        => await _dbSet
            .Include(p => p.Images)
            .Where(p => p.CategoryId == categoryId && p.IsActive)
            .OrderBy(p => p.Name)
            .ToListAsync(cancellationToken);

    public async Task<IReadOnlyList<Product>> GetByAgeGroupAsync(AgeGroup ageGroup, CancellationToken cancellationToken = default)
        => await _dbSet
            .Include(p => p.Images)
            .Where(p => p.TargetAgeGroup == ageGroup && p.IsActive)
            .OrderByDescending(p => p.CreatedAt)
            .ToListAsync(cancellationToken);

    public async Task<IReadOnlyList<Product>> GetFeaturedAsync(int count, CancellationToken cancellationToken = default)
        => await _dbSet
            .Include(p => p.Images)
            .Where(p => p.IsFeatured && p.IsActive)
            .OrderByDescending(p => p.AverageRating)
            .Take(count)
            .ToListAsync(cancellationToken);

    public async Task<IReadOnlyList<Product>> GetNewArrivalsAsync(int count, CancellationToken cancellationToken = default)
        => await _dbSet
            .Include(p => p.Images)
            .Where(p => p.IsActive)
            .OrderByDescending(p => p.CreatedAt)
            .Take(count)
            .ToListAsync(cancellationToken);

    public async Task<(IReadOnlyList<Product> Items, int TotalCount)> GetPagedAsync(
        int page, int pageSize,
        Guid? categoryId = null,
        AgeGroup? ageGroup = null,
        decimal? minPrice = null,
        decimal? maxPrice = null,
        string? brand = null,
        string? sortBy = null,
        bool sortDescending = false,
        CancellationToken cancellationToken = default)
    {
        var query = _dbSet
            .Include(p => p.Category)
            .Include(p => p.Images)
            .Where(p => p.IsActive);

        if (categoryId.HasValue) query = query.Where(p => p.CategoryId == categoryId.Value);
        if (ageGroup.HasValue) query = query.Where(p => p.TargetAgeGroup == ageGroup.Value);
        if (minPrice.HasValue) query = query.Where(p => p.BasePrice >= minPrice.Value);
        if (maxPrice.HasValue) query = query.Where(p => p.BasePrice <= maxPrice.Value);
        if (!string.IsNullOrEmpty(brand)) query = query.Where(p => p.Brand == brand);

        var totalCount = await query.CountAsync(cancellationToken);

        query = sortBy?.ToLowerInvariant() switch
        {
            "price" => sortDescending ? query.OrderByDescending(p => p.BasePrice) : query.OrderBy(p => p.BasePrice),
            "rating" => query.OrderByDescending(p => p.AverageRating),
            "newest" => query.OrderByDescending(p => p.CreatedAt),
            "name" => sortDescending ? query.OrderByDescending(p => p.Name) : query.OrderBy(p => p.Name),
            _ => query.OrderByDescending(p => p.CreatedAt)
        };

        var items = await query
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync(cancellationToken);

        return (items, totalCount);
    }
}
