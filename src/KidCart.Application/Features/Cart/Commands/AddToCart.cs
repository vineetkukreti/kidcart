using FluentValidation;
using KidCart.Application.Common;
using KidCart.Application.DTOs;
using KidCart.Domain.Interfaces;

namespace KidCart.Application.Features.Cart.Commands;

public sealed record AddToCartCommand(
    Guid? UserId,
    string? SessionId,
    Guid ProductId,
    Guid? VariantId,
    int Quantity
) : ICommand<CartDto>;

public sealed class AddToCartValidator : AbstractValidator<AddToCartCommand>
{
    public AddToCartValidator()
    {
        RuleFor(x => x.ProductId).NotEmpty();
        RuleFor(x => x.Quantity).GreaterThan(0).LessThanOrEqualTo(99);
        RuleFor(x => x).Must(x => x.UserId.HasValue || !string.IsNullOrEmpty(x.SessionId))
            .WithMessage("Either UserId or SessionId must be provided.");
    }
}

public sealed class AddToCartHandler : ICommandHandler<AddToCartCommand, CartDto>
{
    private readonly IUnitOfWork _unitOfWork;

    public AddToCartHandler(IUnitOfWork unitOfWork) => _unitOfWork = unitOfWork;

    public async Task<Result<CartDto>> Handle(AddToCartCommand request, CancellationToken cancellationToken)
    {
        var product = await _unitOfWork.Products.GetByIdAsync(request.ProductId, cancellationToken);
        if (product is null || !product.IsActive)
            return Result<CartDto>.Failure("Product not found or inactive.");

        decimal unitPrice = product.BasePrice;
        if (request.VariantId.HasValue)
        {
            var variant = product.Variants.FirstOrDefault(v => v.Id == request.VariantId.Value);
            if (variant is null) return Result<CartDto>.Failure("Variant not found.");
            if (variant.IsOutOfStock) return Result<CartDto>.Failure("Variant is out of stock.");
            if (variant.StockQuantity < request.Quantity) return Result<CartDto>.Failure("Insufficient stock.");
            unitPrice += variant.PriceAdjustment;
        }

        Domain.Entities.Cart? cart;
        if (request.UserId.HasValue)
            cart = await _unitOfWork.Carts.GetByUserIdAsync(request.UserId.Value, cancellationToken);
        else
            cart = await _unitOfWork.Carts.GetBySessionIdAsync(request.SessionId!, cancellationToken);

        if (cart is null)
        {
            cart = request.UserId.HasValue
                ? Domain.Entities.Cart.CreateForUser(request.UserId.Value)
                : Domain.Entities.Cart.CreateForGuest(request.SessionId!);
            await _unitOfWork.Carts.AddAsync(cart, cancellationToken);
        }

        cart.AddItem(request.ProductId, request.VariantId, request.Quantity, unitPrice);
        await _unitOfWork.SaveChangesAsync(cancellationToken);

        return new CartDto
        {
            Id = cart.Id,
            Items = cart.Items.Select(i => new CartItemDto
            {
                Id = i.Id,
                ProductId = i.ProductId,
                ProductName = i.Product?.Name ?? "",
                VariantId = i.VariantId,
                Quantity = i.Quantity,
                UnitPrice = i.UnitPrice,
                LineTotal = i.UnitPrice * i.Quantity
            }).ToList(),
            Total = cart.GetTotal(),
            ItemCount = cart.GetItemCount()
        };
    }
}
