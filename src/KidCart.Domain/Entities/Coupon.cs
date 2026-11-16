using KidCart.Domain.Enums;

namespace KidCart.Domain.Entities;

public class Coupon : BaseEntity
{
    public string Code { get; private set; } = null!;
    public string Description { get; private set; } = null!;
    public CouponType Type { get; private set; }
    public decimal Value { get; private set; }
    public decimal? MinimumOrderAmount { get; private set; }
    public decimal? MaximumDiscount { get; private set; }
    public int? UsageLimit { get; private set; }
    public int UsageCount { get; private set; }
    public int? PerUserLimit { get; private set; }
    public DateTime ValidFrom { get; private set; }
    public DateTime ValidTo { get; private set; }
    public bool IsActive { get; private set; } = true;
    public AgeGroup? RestrictedToAgeGroup { get; private set; }

    private Coupon() { } // EF Core

    public static Coupon Create(
        string code,
        string description,
        CouponType type,
        decimal value,
        DateTime validFrom,
        DateTime validTo,
        decimal? minimumOrderAmount = null,
        decimal? maximumDiscount = null,
        int? usageLimit = null,
        int? perUserLimit = null,
        AgeGroup? restrictedToAgeGroup = null)
    {
        return new Coupon
        {
            Code = code.ToUpperInvariant(),
            Description = description,
            Type = type,
            Value = value,
            ValidFrom = validFrom,
            ValidTo = validTo,
            MinimumOrderAmount = minimumOrderAmount,
            MaximumDiscount = maximumDiscount,
            UsageLimit = usageLimit,
            PerUserLimit = perUserLimit,
            RestrictedToAgeGroup = restrictedToAgeGroup
        };
    }

    public bool IsValid(decimal orderAmount, AgeGroup? customerAgeGroup)
    {
        if (!IsActive) return false;
        if (DateTime.UtcNow < ValidFrom || DateTime.UtcNow > ValidTo) return false;
        if (UsageLimit.HasValue && UsageCount >= UsageLimit.Value) return false;
        if (MinimumOrderAmount.HasValue && orderAmount < MinimumOrderAmount.Value) return false;
        if (RestrictedToAgeGroup.HasValue && customerAgeGroup != RestrictedToAgeGroup.Value) return false;
        return true;
    }

    public decimal CalculateDiscount(decimal orderAmount)
    {
        var discount = Type switch
        {
            CouponType.Percentage => orderAmount * (Value / 100m),
            CouponType.FixedAmount => Value,
            _ => 0m
        };

        if (MaximumDiscount.HasValue)
            discount = Math.Min(discount, MaximumDiscount.Value);

        return Math.Round(Math.Min(discount, orderAmount), 2);
    }

    public void IncrementUsage()
    {
        UsageCount++;
        UpdatedAt = DateTime.UtcNow;
    }
}
