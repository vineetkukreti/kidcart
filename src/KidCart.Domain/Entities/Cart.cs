namespace KidCart.Domain.Entities;

public class Cart : BaseEntity
{
    public Guid? UserId { get; private set; }
    public string? SessionId { get; private set; }

    private readonly List<CartItem> _items = new();
    public IReadOnlyCollection<CartItem> Items => _items.AsReadOnly();

    private Cart() { } // EF Core

    public static Cart CreateForUser(Guid userId) => new() { UserId = userId };
    public static Cart CreateForGuest(string sessionId) => new() { SessionId = sessionId };

    public void AddItem(Guid productId, Guid? variantId, int quantity, decimal unitPrice)
    {
        var existing = _items.FirstOrDefault(i => i.ProductId == productId && i.VariantId == variantId);
        if (existing is not null)
        {
            existing.UpdateQuantity(existing.Quantity + quantity);
        }
        else
        {
            _items.Add(CartItem.Create(Id, productId, variantId, quantity, unitPrice));
        }
        UpdatedAt = DateTime.UtcNow;
    }

    public void UpdateItemQuantity(Guid cartItemId, int quantity)
    {
        var item = _items.FirstOrDefault(i => i.Id == cartItemId)
            ?? throw new InvalidOperationException("Cart item not found.");

        if (quantity <= 0)
            _items.Remove(item);
        else
            item.UpdateQuantity(quantity);

        UpdatedAt = DateTime.UtcNow;
    }

    public void RemoveItem(Guid cartItemId)
    {
        var item = _items.FirstOrDefault(i => i.Id == cartItemId)
            ?? throw new InvalidOperationException("Cart item not found.");
        _items.Remove(item);
        UpdatedAt = DateTime.UtcNow;
    }

    public void Clear()
    {
        _items.Clear();
        UpdatedAt = DateTime.UtcNow;
    }

    public decimal GetTotal() => _items.Sum(i => i.UnitPrice * i.Quantity);
    public int GetItemCount() => _items.Sum(i => i.Quantity);

    public void MergeGuestCart(Cart guestCart)
    {
        foreach (var item in guestCart.Items)
        {
            AddItem(item.ProductId, item.VariantId, item.Quantity, item.UnitPrice);
        }
    }
}
