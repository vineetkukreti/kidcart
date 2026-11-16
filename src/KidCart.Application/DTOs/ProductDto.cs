using KidCart.Domain.Enums;

namespace KidCart.Application.DTOs;

public record ProductDto
{
    public Guid Id { get; init; }
    public string Name { get; init; } = null!;
    public string Slug { get; init; } = null!;
    public string Description { get; init; } = null!;
    public string? ShortDescription { get; init; }
    public decimal BasePrice { get; init; }
    public decimal? CompareAtPrice { get; init; }
    public Guid CategoryId { get; init; }
    public string CategoryName { get; init; } = null!;
    public AgeGroup TargetAgeGroup { get; init; }
    public string? Brand { get; init; }
    public string? SKU { get; init; }
    public bool IsActive { get; init; }
    public bool IsFeatured { get; init; }
    public decimal AverageRating { get; init; }
    public int ReviewCount { get; init; }
    public List<ProductVariantDto> Variants { get; init; } = new();
    public List<ProductImageDto> Images { get; init; } = new();
    public string? PrimaryImageUrl { get; init; }
}

public record ProductVariantDto
{
    public Guid Id { get; init; }
    public string Name { get; init; } = null!;
    public string? Size { get; init; }
    public string? Color { get; init; }
    public string? SKU { get; init; }
    public decimal PriceAdjustment { get; init; }
    public int StockQuantity { get; init; }
    public bool IsLowStock { get; init; }
    public bool IsOutOfStock { get; init; }
}

public record ProductImageDto
{
    public Guid Id { get; init; }
    public string Url { get; init; } = null!;
    public string? AltText { get; init; }
    public int SortOrder { get; init; }
    public bool IsPrimary { get; init; }
}
