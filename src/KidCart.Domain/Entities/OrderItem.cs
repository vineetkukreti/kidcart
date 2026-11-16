namespace KidCart.Domain.Entities;

public class OrderItem : BaseEntity
{
    public Guid OrderId { get; private set; }
    public Order Order { get; private set; } = null!;
    public Guid ProductId { get; private set; }
    public string ProductName { get; private set; } = null!;
    public string? VariantName { get; private set; }
    public string? SKU { get; private set; }
    public int Quantity { get; private set; }
    public decimal UnitPrice { get; private set; }
    public decimal TotalPrice => Math.Round(UnitPrice * Quantity, 2);

    private OrderItem() { } // EF Core

    public static OrderItem Create(
        Guid productId,
        string productName,
        string? variantName,
        string? sku,
        int quantity,
        decimal unitPrice)
    {
        if (quantity <= 0) throw new ArgumentException("Quantity must be positive.", nameof(quantity));
        if (unitPrice < 0) throw new ArgumentException("Unit price cannot be negative.", nameof(unitPrice));

        return new OrderItem
        {
            ProductId = productId,
            ProductName = productName,
            VariantName = variantName,
            SKU = sku,
            Quantity = quantity,
            UnitPrice = Math.Round(unitPrice, 2)
        };
    }
}
