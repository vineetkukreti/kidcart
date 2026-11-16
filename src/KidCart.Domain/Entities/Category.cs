using KidCart.Domain.Enums;

namespace KidCart.Domain.Entities;

public class Category : BaseEntity
{
    public string Name { get; private set; } = null!;
    public string Slug { get; private set; } = null!;
    public string? Description { get; private set; }
    public string? ImageUrl { get; private set; }
    public Guid? ParentCategoryId { get; private set; }
    public Category? ParentCategory { get; private set; }
    public int SortOrder { get; private set; }
    public bool IsActive { get; private set; } = true;

    private readonly List<Category> _subCategories = new();
    public IReadOnlyCollection<Category> SubCategories => _subCategories.AsReadOnly();

    private readonly List<Product> _products = new();
    public IReadOnlyCollection<Product> Products => _products.AsReadOnly();

    private Category() { } // EF Core

    public static Category Create(string name, string slug, string? description = null, Guid? parentCategoryId = null)
    {
        return new Category
        {
            Name = name,
            Slug = slug,
            Description = description,
            ParentCategoryId = parentCategoryId
        };
    }

    public void Update(string name, string slug, string? description, string? imageUrl, int sortOrder)
    {
        Name = name;
        Slug = slug;
        Description = description;
        ImageUrl = imageUrl;
        SortOrder = sortOrder;
        UpdatedAt = DateTime.UtcNow;
    }

    public void Deactivate()
    {
        IsActive = false;
        UpdatedAt = DateTime.UtcNow;
    }
}
