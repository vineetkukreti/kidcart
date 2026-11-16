namespace KidCart.Domain.Entities;

public class Wishlist : BaseEntity
{
    public Guid UserId { get; private set; }

    private readonly List<WishlistItem> _items = new();
    public IReadOnlyCollection<WishlistItem> Items => _items.AsReadOnly();

    private Wishlist() { } // EF Core

    public static Wishlist Create(Guid userId) => new() { UserId = userId };

    public void AddItem(Guid productId)
    {
        if (_items.Any(i => i.ProductId == productId)) return;
        _items.Add(WishlistItem.Create(Id, productId));
        UpdatedAt = DateTime.UtcNow;
    }

    public void RemoveItem(Guid productId)
    {
        var item = _items.FirstOrDefault(i => i.ProductId == productId);
        if (item is not null) _items.Remove(item);
        UpdatedAt = DateTime.UtcNow;
    }
}

public class WishlistItem : BaseEntity
{
    public Guid WishlistId { get; private set; }
    public Guid ProductId { get; private set; }
    public Product Product { get; private set; } = null!;

    private WishlistItem() { }

    internal static WishlistItem Create(Guid wishlistId, Guid productId) =>
        new() { WishlistId = wishlistId, ProductId = productId };
}
