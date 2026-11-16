using KidCart.Domain.Entities;
using KidCart.Domain.Enums;

namespace KidCart.Domain.Interfaces;

public interface IProductRepository : IRepository<Product>
{
    Task<Product?> GetBySlugAsync(string slug, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<Product>> GetByCategoryAsync(Guid categoryId, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<Product>> GetByAgeGroupAsync(AgeGroup ageGroup, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<Product>> GetFeaturedAsync(int count, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<Product>> GetNewArrivalsAsync(int count, CancellationToken cancellationToken = default);
    Task<(IReadOnlyList<Product> Items, int TotalCount)> GetPagedAsync(
        int page, int pageSize,
        Guid? categoryId = null,
        AgeGroup? ageGroup = null,
        decimal? minPrice = null,
        decimal? maxPrice = null,
        string? brand = null,
        string? sortBy = null,
        bool sortDescending = false,
        CancellationToken cancellationToken = default);
}
