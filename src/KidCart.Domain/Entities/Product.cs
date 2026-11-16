using KidCart.Domain.Enums;
using KidCart.Domain.ValueObjects;

namespace KidCart.Domain.Entities;

public class Product : BaseEntity
{
    public string Name { get; private set; } = null!;
    public string Slug { get; private set; } = null!;
    public string Description { get; private set; } = null!;
    public string? ShortDescription { get; private set; }
    public decimal BasePrice { get; private set; }
    public decimal? CompareAtPrice { get; private set; }
    public Guid CategoryId { get; private set; }
    public Category Category { get; private set; } = null!;
    public AgeGroup TargetAgeGroup { get; private set; }
    public string? Brand { get; private set; }
    public string? SKU { get; private set; }
    public bool IsActive { get; private set; } = true;
    public bool IsFeatured { get; private set; }
    public decimal AverageRating { get; private set; }
    public int ReviewCount { get; private set; }

    private readonly List<ProductVariant> _variants = new();
    public IReadOnlyCollection<ProductVariant> Variants => _variants.AsReadOnly();

    private readonly List<ProductImage> _images = new();
    public IReadOnlyCollection<ProductImage> Images => _images.AsReadOnly();

    private Product() { } // EF Core

    public static Product Create(
        string name,
        string slug,
        string description,
        decimal basePrice,
        Guid categoryId,
        AgeGroup targetAgeGroup,
        string? brand = null,
        string? sku = null)
    {
        if (basePrice < 0) throw new ArgumentException("Price cannot be negative.", nameof(basePrice));

        return new Product
        {
            Name = name,
            Slug = slug,
            Description = description,
            BasePrice = Math.Round(basePrice, 2),
            CategoryId = categoryId,
            TargetAgeGroup = targetAgeGroup,
            Brand = brand,
            SKU = sku
        };
    }

    public void UpdateDetails(string name, string slug, string description, string? shortDescription, string? brand)
    {
        Name = name;
        Slug = slug;
        Description = description;
        ShortDescription = shortDescription;
        Brand = brand;
        UpdatedAt = DateTime.UtcNow;
    }

    public void UpdatePricing(decimal basePrice, decimal? compareAtPrice)
    {
        if (basePrice < 0) throw new ArgumentException("Price cannot be negative.", nameof(basePrice));
        if (compareAtPrice.HasValue && compareAtPrice.Value < basePrice)
            throw new ArgumentException("Compare-at price must be greater than base price.", nameof(compareAtPrice));

        BasePrice = Math.Round(basePrice, 2);
        CompareAtPrice = compareAtPrice.HasValue ? Math.Round(compareAtPrice.Value, 2) : null;
        UpdatedAt = DateTime.UtcNow;
    }

    public void AddVariant(ProductVariant variant)
    {
        _variants.Add(variant);
        UpdatedAt = DateTime.UtcNow;
    }

    public void AddImage(ProductImage image)
    {
        _images.Add(image);
        UpdatedAt = DateTime.UtcNow;
    }

    public void SetFeatured(bool featured)
    {
        IsFeatured = featured;
        UpdatedAt = DateTime.UtcNow;
    }

    public void Deactivate()
    {
        IsActive = false;
        UpdatedAt = DateTime.UtcNow;
    }

    public void Activate()
    {
        IsActive = true;
        UpdatedAt = DateTime.UtcNow;
    }

    public void UpdateRating(decimal averageRating, int reviewCount)
    {
        AverageRating = Math.Round(averageRating, 1);
        ReviewCount = reviewCount;
    }
}
