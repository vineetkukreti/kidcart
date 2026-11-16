namespace KidCart.Domain.Entities;

public class CartItem : BaseEntity
{
    public Guid CartId { get; private set; }
    public Cart Cart { get; private set; } = null!;
    public Guid ProductId { get; private set; }
    public Product Product { get; private set; } = null!;
    public Guid? VariantId { get; private set; }
    public ProductVariant? Variant { get; private set; }
    public int Quantity { get; private set; }
    public decimal UnitPrice { get; private set; }

    private CartItem() { } // EF Core

    internal static CartItem Create(Guid cartId, Guid productId, Guid? variantId, int quantity, decimal unitPrice)
    {
        if (quantity <= 0) throw new ArgumentException("Quantity must be positive.", nameof(quantity));
        if (unitPrice < 0) throw new ArgumentException("Unit price cannot be negative.", nameof(unitPrice));

        return new CartItem
        {
            CartId = cartId,
            ProductId = productId,
            VariantId = variantId,
            Quantity = quantity,
            UnitPrice = Math.Round(unitPrice, 2)
        };
    }

    internal void UpdateQuantity(int quantity)
    {
        if (quantity <= 0) throw new ArgumentException("Quantity must be positive.", nameof(quantity));
        Quantity = quantity;
        UpdatedAt = DateTime.UtcNow;
    }
}
