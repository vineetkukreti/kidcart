namespace KidCart.Domain.Entities;

public class Review : BaseEntity
{
    public Guid ProductId { get; private set; }
    public Product Product { get; private set; } = null!;
    public Guid UserId { get; private set; }
    public string UserDisplayName { get; private set; } = null!;
    public int Rating { get; private set; }
    public string? Title { get; private set; }
    public string? Comment { get; private set; }
    public bool IsVerifiedPurchase { get; private set; }
    public bool IsApproved { get; private set; }

    private Review() { } // EF Core

    public static Review Create(Guid productId, Guid userId, string displayName, int rating, string? title, string? comment, bool isVerifiedPurchase)
    {
        if (rating is < 1 or > 5) throw new ArgumentException("Rating must be between 1 and 5.", nameof(rating));

        return new Review
        {
            ProductId = productId,
            UserId = userId,
            UserDisplayName = displayName,
            Rating = rating,
            Title = title,
            Comment = comment,
            IsVerifiedPurchase = isVerifiedPurchase,
            IsApproved = false
        };
    }

    public void Approve() { IsApproved = true; UpdatedAt = DateTime.UtcNow; }
    public void Reject() { IsApproved = false; UpdatedAt = DateTime.UtcNow; }
}
