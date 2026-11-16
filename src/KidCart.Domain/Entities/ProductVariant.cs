namespace KidCart.Domain.Entities;

public class ProductVariant : BaseEntity
{
    public Guid ProductId { get; private set; }
    public Product Product { get; private set; } = null!;
    public string Name { get; private set; } = null!;
    public string? Size { get; private set; }
    public string? Color { get; private set; }
    public string? SKU { get; private set; }
    public decimal PriceAdjustment { get; private set; }
    public int StockQuantity { get; private set; }
    public int LowStockThreshold { get; private set; } = 5;
    public bool IsActive { get; private set; } = true;

    private ProductVariant() { } // EF Core

    public static ProductVariant Create(
        Guid productId,
        string name,
        string? size,
        string? color,
        string? sku,
        decimal priceAdjustment = 0,
        int stockQuantity = 0)
    {
        return new ProductVariant
        {
            ProductId = productId,
            Name = name,
            Size = size,
            Color = color,
            SKU = sku,
            PriceAdjustment = Math.Round(priceAdjustment, 2),
            StockQuantity = stockQuantity
        };
    }

    public bool IsLowStock => StockQuantity <= LowStockThreshold && StockQuantity > 0;
    public bool IsOutOfStock => StockQuantity <= 0;

    public void AdjustStock(int quantityChange)
    {
        var newQuantity = StockQuantity + quantityChange;
        if (newQuantity < 0) throw new InvalidOperationException("Insufficient stock.");
        StockQuantity = newQuantity;
        UpdatedAt = DateTime.UtcNow;
    }

    public void SetStock(int quantity)
    {
        if (quantity < 0) throw new ArgumentException("Stock quantity cannot be negative.", nameof(quantity));
        StockQuantity = quantity;
        UpdatedAt = DateTime.UtcNow;
    }
}
