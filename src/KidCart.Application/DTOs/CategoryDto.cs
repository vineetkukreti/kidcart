namespace KidCart.Application.DTOs;

public record CategoryDto
{
    public Guid Id { get; init; }
    public string Name { get; init; } = null!;
    public string Slug { get; init; } = null!;
    public string? Description { get; init; }
    public string? ImageUrl { get; init; }
    public Guid? ParentCategoryId { get; init; }
    public int SortOrder { get; init; }
    public bool IsActive { get; init; }
    public int ProductCount { get; init; }
    public List<CategoryDto> SubCategories { get; init; } = new();
}
