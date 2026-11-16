using KidCart.Domain.Entities;
using KidCart.Domain.Interfaces;
using KidCart.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace KidCart.Infrastructure.Repositories;

public class CategoryRepository : Repository<Category>, ICategoryRepository
{
    public CategoryRepository(KidCartDbContext context) : base(context) { }

    public async Task<Category?> GetBySlugAsync(string slug, CancellationToken cancellationToken = default)
        => await _dbSet.FirstOrDefaultAsync(c => c.Slug == slug, cancellationToken);

    public async Task<IReadOnlyList<Category>> GetRootCategoriesAsync(CancellationToken cancellationToken = default)
        => await _dbSet
            .Where(c => c.ParentCategoryId == null && c.IsActive)
            .OrderBy(c => c.SortOrder)
            .ToListAsync(cancellationToken);

    public async Task<IReadOnlyList<Category>> GetSubCategoriesAsync(Guid parentId, CancellationToken cancellationToken = default)
        => await _dbSet
            .Where(c => c.ParentCategoryId == parentId && c.IsActive)
            .OrderBy(c => c.SortOrder)
            .ToListAsync(cancellationToken);

    public async Task<IReadOnlyList<Category>> GetCategoryTreeAsync(CancellationToken cancellationToken = default)
        => await _dbSet
            .Include(c => c.SubCategories)
            .Where(c => c.ParentCategoryId == null && c.IsActive)
            .OrderBy(c => c.SortOrder)
            .ToListAsync(cancellationToken);
}
