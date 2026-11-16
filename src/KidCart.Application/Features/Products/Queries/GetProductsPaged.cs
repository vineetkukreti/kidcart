using KidCart.Application.Common;
using KidCart.Application.DTOs;
using KidCart.Domain.Enums;
using KidCart.Domain.Interfaces;

namespace KidCart.Application.Features.Products.Queries;

public sealed record GetProductsPagedQuery(
    int Page = 1,
    int PageSize = 20,
    Guid? CategoryId = null,
    AgeGroup? AgeGroup = null,
    decimal? MinPrice = null,
    decimal? MaxPrice = null,
    string? Brand = null,
    string? SortBy = null,
    bool SortDescending = false
) : IQuery<PagedResult<ProductDto>>;

public sealed class GetProductsPagedHandler : IQueryHandler<GetProductsPagedQuery, PagedResult<ProductDto>>
{
    private readonly IUnitOfWork _unitOfWork;

    public GetProductsPagedHandler(IUnitOfWork unitOfWork) => _unitOfWork = unitOfWork;

    public async Task<Result<PagedResult<ProductDto>>> Handle(GetProductsPagedQuery request, CancellationToken cancellationToken)
    {
        var (products, totalCount) = await _unitOfWork.Products.GetPagedAsync(
            request.Page, request.PageSize,
            request.CategoryId, request.AgeGroup,
            request.MinPrice, request.MaxPrice,
            request.Brand, request.SortBy, request.SortDescending,
            cancellationToken);

        var items = products.Select(p => new ProductDto
        {
            Id = p.Id,
            Name = p.Name,
            Slug = p.Slug,
            Description = p.Description,
            BasePrice = p.BasePrice,
            CompareAtPrice = p.CompareAtPrice,
            CategoryId = p.CategoryId,
            CategoryName = p.Category?.Name ?? "",
            TargetAgeGroup = p.TargetAgeGroup,
            Brand = p.Brand,
            IsActive = p.IsActive,
            IsFeatured = p.IsFeatured,
            AverageRating = p.AverageRating,
            ReviewCount = p.ReviewCount,
            PrimaryImageUrl = p.Images.FirstOrDefault(i => i.IsPrimary)?.Url ?? p.Images.FirstOrDefault()?.Url
        }).ToList();

        return new PagedResult<ProductDto>
        {
            Items = items,
            TotalCount = totalCount,
            Page = request.Page,
            PageSize = request.PageSize
        };
    }
}
