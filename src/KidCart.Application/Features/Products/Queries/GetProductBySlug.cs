using KidCart.Application.Common;
using KidCart.Application.DTOs;
using KidCart.Domain.Interfaces;

namespace KidCart.Application.Features.Products.Queries;

public sealed record GetProductBySlugQuery(string Slug) : IQuery<ProductDto>;

public sealed class GetProductBySlugHandler : IQueryHandler<GetProductBySlugQuery, ProductDto>
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly ICacheService _cache;

    public GetProductBySlugHandler(IUnitOfWork unitOfWork, ICacheService cache)
    {
        _unitOfWork = unitOfWork;
        _cache = cache;
    }

    public async Task<Result<ProductDto>> Handle(GetProductBySlugQuery request, CancellationToken cancellationToken)
    {
        var cacheKey = $"product:slug:{request.Slug}";
        var cached = await _cache.GetAsync<ProductDto>(cacheKey, cancellationToken);
        if (cached is not null) return cached;

        var product = await _unitOfWork.Products.GetBySlugAsync(request.Slug, cancellationToken);
        if (product is null) return Result<ProductDto>.Failure("Product not found.");

        var dto = new ProductDto
        {
            Id = product.Id,
            Name = product.Name,
            Slug = product.Slug,
            Description = product.Description,
            ShortDescription = product.ShortDescription,
            BasePrice = product.BasePrice,
            CompareAtPrice = product.CompareAtPrice,
            CategoryId = product.CategoryId,
            CategoryName = product.Category?.Name ?? "",
            TargetAgeGroup = product.TargetAgeGroup,
            Brand = product.Brand,
            SKU = product.SKU,
            IsActive = product.IsActive,
            IsFeatured = product.IsFeatured,
            AverageRating = product.AverageRating,
            ReviewCount = product.ReviewCount,
            Variants = product.Variants.Select(v => new ProductVariantDto
            {
                Id = v.Id, Name = v.Name, Size = v.Size, Color = v.Color,
                SKU = v.SKU, PriceAdjustment = v.PriceAdjustment,
                StockQuantity = v.StockQuantity, IsLowStock = v.IsLowStock, IsOutOfStock = v.IsOutOfStock
            }).ToList(),
            Images = product.Images.OrderBy(i => i.SortOrder).Select(i => new ProductImageDto
            {
                Id = i.Id, Url = i.Url, AltText = i.AltText, SortOrder = i.SortOrder, IsPrimary = i.IsPrimary
            }).ToList(),
            PrimaryImageUrl = product.Images.FirstOrDefault(i => i.IsPrimary)?.Url ?? product.Images.FirstOrDefault()?.Url
        };

        await _cache.SetAsync(cacheKey, dto, TimeSpan.FromMinutes(10), cancellationToken);
        return dto;
    }
}
