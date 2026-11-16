using FluentValidation;
using KidCart.Application.Common;
using KidCart.Application.DTOs;
using KidCart.Domain.Entities;
using KidCart.Domain.Events;
using KidCart.Domain.Interfaces;
using KidCart.Domain.ValueObjects;

namespace KidCart.Application.Features.Orders.Commands;

public sealed record PlaceOrderCommand(
    Guid UserId,
    Address ShippingAddress,
    Address? BillingAddress,
    string? CouponCode
) : ICommand<OrderDto>;

public sealed class PlaceOrderValidator : AbstractValidator<PlaceOrderCommand>
{
    public PlaceOrderValidator()
    {
        RuleFor(x => x.UserId).NotEmpty();
        RuleFor(x => x.ShippingAddress).NotNull();
        RuleFor(x => x.ShippingAddress.Line1).NotEmpty().When(x => x.ShippingAddress is not null);
        RuleFor(x => x.ShippingAddress.City).NotEmpty().When(x => x.ShippingAddress is not null);
        RuleFor(x => x.ShippingAddress.State).NotEmpty().When(x => x.ShippingAddress is not null);
        RuleFor(x => x.ShippingAddress.PostalCode).NotEmpty().When(x => x.ShippingAddress is not null);
    }
}

public sealed class PlaceOrderHandler : ICommandHandler<PlaceOrderCommand, OrderDto>
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly ICacheService _cache;

    public PlaceOrderHandler(IUnitOfWork unitOfWork, ICacheService cache)
    {
        _unitOfWork = unitOfWork;
        _cache = cache;
    }

    public async Task<Result<OrderDto>> Handle(PlaceOrderCommand request, CancellationToken cancellationToken)
    {
        await _unitOfWork.BeginTransactionAsync(cancellationToken);

        try
        {
            var cart = await _unitOfWork.Carts.GetByUserIdAsync(request.UserId, cancellationToken);
            if (cart is null || !cart.Items.Any())
                return Result<OrderDto>.Failure("Cart is empty.");

            var orderItems = new List<OrderItem>();
            foreach (var cartItem in cart.Items)
            {
                var product = await _unitOfWork.Products.GetByIdAsync(cartItem.ProductId, cancellationToken);
                if (product is null || !product.IsActive)
                    return Result<OrderDto>.Failure($"Product '{cartItem.ProductId}' is unavailable.");

                orderItems.Add(OrderItem.Create(
                    cartItem.ProductId,
                    product.Name,
                    cartItem.Variant?.Name,
                    product.SKU,
                    cartItem.Quantity,
                    cartItem.UnitPrice));

                if (cartItem.VariantId.HasValue)
                {
                    var variant = product.Variants.FirstOrDefault(v => v.Id == cartItem.VariantId.Value);
                    variant?.AdjustStock(-cartItem.Quantity);

                    if (variant is { IsLowStock: true })
                        product.AddDomainEvent(new LowStockEvent(product.Id, variant.Id, product.Name, variant.StockQuantity));
                }
            }

            decimal discountAmount = 0;
            decimal shippingAmount = cart.GetTotal() >= 499 ? 0 : 49;
            decimal taxAmount = Math.Round(cart.GetTotal() * 0.18m, 2); // 18% GST

            var order = Order.Create(
                request.UserId,
                request.ShippingAddress,
                request.BillingAddress,
                orderItems,
                shippingAmount,
                taxAmount,
                request.CouponCode,
                discountAmount);

            order.AddDomainEvent(new OrderPlacedEvent(order.Id, order.OrderNumber, order.UserId, order.TotalAmount));

            await _unitOfWork.Orders.AddAsync(order, cancellationToken);
            cart.Clear();
            await _unitOfWork.SaveChangesAsync(cancellationToken);
            await _unitOfWork.CommitTransactionAsync(cancellationToken);

            return new OrderDto
            {
                Id = order.Id,
                OrderNumber = order.OrderNumber,
                UserId = order.UserId,
                Status = order.Status,
                ShippingAddress = order.ShippingAddress,
                SubTotal = order.SubTotal,
                DiscountAmount = order.DiscountAmount,
                ShippingAmount = order.ShippingAmount,
                TaxAmount = order.TaxAmount,
                TotalAmount = order.TotalAmount,
                CouponCode = order.CouponCode,
                CreatedAt = order.CreatedAt,
                Items = order.Items.Select(i => new OrderItemDto
                {
                    Id = i.Id, ProductId = i.ProductId, ProductName = i.ProductName,
                    VariantName = i.VariantName, Quantity = i.Quantity,
                    UnitPrice = i.UnitPrice, TotalPrice = i.TotalPrice
                }).ToList()
            };
        }
        catch
        {
            await _unitOfWork.RollbackTransactionAsync(cancellationToken);
            throw;
        }
    }
}
