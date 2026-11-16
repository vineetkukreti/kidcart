using KidCart.Domain.Enums;
using KidCart.Domain.ValueObjects;

namespace KidCart.Application.DTOs;

public record OrderDto
{
    public Guid Id { get; init; }
    public string OrderNumber { get; init; } = null!;
    public Guid UserId { get; init; }
    public OrderStatus Status { get; init; }
    public Address ShippingAddress { get; init; } = null!;
    public decimal SubTotal { get; init; }
    public decimal DiscountAmount { get; init; }
    public decimal ShippingAmount { get; init; }
    public decimal TaxAmount { get; init; }
    public decimal TotalAmount { get; init; }
    public string? CouponCode { get; init; }
    public DateTime CreatedAt { get; init; }
    public List<OrderItemDto> Items { get; init; } = new();
}

public record OrderItemDto
{
    public Guid Id { get; init; }
    public Guid ProductId { get; init; }
    public string ProductName { get; init; } = null!;
    public string? VariantName { get; init; }
    public int Quantity { get; init; }
    public decimal UnitPrice { get; init; }
    public decimal TotalPrice { get; init; }
}

public record CartDto
{
    public Guid Id { get; init; }
    public List<CartItemDto> Items { get; init; } = new();
    public decimal Total { get; init; }
    public int ItemCount { get; init; }
}

public record CartItemDto
{
    public Guid Id { get; init; }
    public Guid ProductId { get; init; }
    public string ProductName { get; init; } = null!;
    public string? ProductImageUrl { get; init; }
    public Guid? VariantId { get; init; }
    public string? VariantName { get; init; }
    public int Quantity { get; init; }
    public decimal UnitPrice { get; init; }
    public decimal LineTotal { get; init; }
}
