using FluentValidation;
using KidCart.Application.Common;
using KidCart.Application.DTOs;
using KidCart.Domain.Entities;
using KidCart.Domain.Enums;
using KidCart.Domain.Interfaces;

namespace KidCart.Application.Features.Products.Commands;

public sealed record CreateProductCommand(
    string Name,
    string Slug,
    string Description,
    string? ShortDescription,
    decimal BasePrice,
    decimal? CompareAtPrice,
    Guid CategoryId,
    AgeGroup TargetAgeGroup,
    string? Brand,
    string? SKU
) : ICommand<ProductDto>;

public sealed class CreateProductValidator : AbstractValidator<CreateProductCommand>
{
    public CreateProductValidator()
    {
        RuleFor(x => x.Name).NotEmpty().MaximumLength(200);
        RuleFor(x => x.Slug).NotEmpty().MaximumLength(200).Matches(@"^[a-z0-9\-]+$");
        RuleFor(x => x.Description).NotEmpty().MaximumLength(5000);
        RuleFor(x => x.BasePrice).GreaterThanOrEqualTo(0);
        RuleFor(x => x.CompareAtPrice).GreaterThan(x => x.BasePrice)
            .When(x => x.CompareAtPrice.HasValue);
        RuleFor(x => x.CategoryId).NotEmpty();
        RuleFor(x => x.TargetAgeGroup).IsInEnum();
    }
}

public sealed class CreateProductHandler : ICommandHandler<CreateProductCommand, ProductDto>
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly ICacheService _cache;

    public CreateProductHandler(IUnitOfWork unitOfWork, ICacheService cache)
    {
        _unitOfWork = unitOfWork;
        _cache = cache;
    }

    public async Task<Result<ProductDto>> Handle(CreateProductCommand request, CancellationToken cancellationToken)
    {
        var existingProduct = await _unitOfWork.Products.GetBySlugAsync(request.Slug, cancellationToken);
        if (existingProduct is not null)
            return Result<ProductDto>.Failure("A product with this slug already exists.");

        var category = await _unitOfWork.Categories.GetByIdAsync(request.CategoryId, cancellationToken);
        if (category is null)
            return Result<ProductDto>.Failure("Category not found.");

        var product = Product.Create(
            request.Name, request.Slug, request.Description,
            request.BasePrice, request.CategoryId, request.TargetAgeGroup,
            request.Brand, request.SKU);

        if (request.CompareAtPrice.HasValue)
            product.UpdatePricing(request.BasePrice, request.CompareAtPrice);

        await _unitOfWork.Products.AddAsync(product, cancellationToken);
        await _unitOfWork.SaveChangesAsync(cancellationToken);
        await _cache.RemoveByPrefixAsync("product:", cancellationToken);

        return new ProductDto
        {
            Id = product.Id,
            Name = product.Name,
            Slug = product.Slug,
            Description = product.Description,
            BasePrice = product.BasePrice,
            CompareAtPrice = product.CompareAtPrice,
            CategoryId = product.CategoryId,
            CategoryName = category.Name,
            TargetAgeGroup = product.TargetAgeGroup,
            Brand = product.Brand,
            SKU = product.SKU,
            IsActive = product.IsActive
        };
    }
}
