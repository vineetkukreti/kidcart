using KidCart.Domain.Enums;
using KidCart.Domain.ValueObjects;

namespace KidCart.Domain.Entities;

public class Order : BaseEntity
{
    public string OrderNumber { get; private set; } = null!;
    public Guid UserId { get; private set; }
    public OrderStatus Status { get; private set; } = OrderStatus.Placed;
    public Address ShippingAddress { get; private set; } = null!;
    public Address? BillingAddress { get; private set; }
    public decimal SubTotal { get; private set; }
    public decimal DiscountAmount { get; private set; }
    public decimal ShippingAmount { get; private set; }
    public decimal TaxAmount { get; private set; }
    public decimal TotalAmount { get; private set; }
    public string? CouponCode { get; private set; }
    public string? Notes { get; private set; }

    private readonly List<OrderItem> _items = new();
    public IReadOnlyCollection<OrderItem> Items => _items.AsReadOnly();

    private readonly List<PaymentRecord> _payments = new();
    public IReadOnlyCollection<PaymentRecord> Payments => _payments.AsReadOnly();

    private Order() { } // EF Core

    public static Order Create(
        Guid userId,
        Address shippingAddress,
        Address? billingAddress,
        List<OrderItem> items,
        decimal shippingAmount,
        decimal taxAmount,
        string? couponCode = null,
        decimal discountAmount = 0)
    {
        var subTotal = items.Sum(i => i.UnitPrice * i.Quantity);

        var order = new Order
        {
            OrderNumber = GenerateOrderNumber(),
            UserId = userId,
            ShippingAddress = shippingAddress,
            BillingAddress = billingAddress,
            SubTotal = Math.Round(subTotal, 2),
            DiscountAmount = Math.Round(discountAmount, 2),
            ShippingAmount = Math.Round(shippingAmount, 2),
            TaxAmount = Math.Round(taxAmount, 2),
            TotalAmount = Math.Round(subTotal - discountAmount + shippingAmount + taxAmount, 2),
            CouponCode = couponCode
        };

        foreach (var item in items)
            order._items.Add(item);

        return order;
    }

    public void Confirm()
    {
        if (Status != OrderStatus.Placed)
            throw new InvalidOperationException($"Cannot confirm order in {Status} status.");
        Status = OrderStatus.Confirmed;
        UpdatedAt = DateTime.UtcNow;
    }

    public void MarkShipped(string? trackingNumber = null)
    {
        if (Status != OrderStatus.Confirmed && Status != OrderStatus.Processing)
            throw new InvalidOperationException($"Cannot ship order in {Status} status.");
        Status = OrderStatus.Shipped;
        Notes = trackingNumber is not null ? $"Tracking: {trackingNumber}" : Notes;
        UpdatedAt = DateTime.UtcNow;
    }

    public void MarkDelivered()
    {
        if (Status != OrderStatus.Shipped)
            throw new InvalidOperationException($"Cannot deliver order in {Status} status.");
        Status = OrderStatus.Delivered;
        UpdatedAt = DateTime.UtcNow;
    }

    public void Cancel(string reason)
    {
        if (Status is OrderStatus.Shipped or OrderStatus.Delivered)
            throw new InvalidOperationException($"Cannot cancel order in {Status} status.");
        Status = OrderStatus.Cancelled;
        Notes = reason;
        UpdatedAt = DateTime.UtcNow;
    }

    public void AddPayment(PaymentRecord payment)
    {
        _payments.Add(payment);
        UpdatedAt = DateTime.UtcNow;
    }

    private static string GenerateOrderNumber() =>
        $"KC-{DateTime.UtcNow:yyyyMMdd}-{Guid.NewGuid().ToString("N")[..8].ToUpper()}";
}
