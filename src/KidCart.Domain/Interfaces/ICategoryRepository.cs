using KidCart.Domain.Entities;

namespace KidCart.Domain.Interfaces;

public interface ICategoryRepository : IRepository<Category>
{
    Task<Category?> GetBySlugAsync(string slug, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<Category>> GetRootCategoriesAsync(CancellationToken cancellationToken = default);
    Task<IReadOnlyList<Category>> GetSubCategoriesAsync(Guid parentId, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<Category>> GetCategoryTreeAsync(CancellationToken cancellationToken = default);
}
