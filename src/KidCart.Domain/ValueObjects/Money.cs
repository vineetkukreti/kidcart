namespace KidCart.Domain.ValueObjects;

public sealed record Money
{
    public decimal Amount { get; init; }
    public string Currency { get; init; } = "INR";

    public Money(decimal amount, string currency = "INR")
    {
        if (amount < 0) throw new ArgumentException("Amount cannot be negative.", nameof(amount));
        Amount = Math.Round(amount, 2);
        Currency = currency;
    }

    public static Money Zero => new(0m);

    public Money Add(Money other)
    {
        if (Currency != other.Currency) throw new InvalidOperationException("Cannot add amounts in different currencies.");
        return new Money(Amount + other.Amount, Currency);
    }

    public Money Subtract(Money other)
    {
        if (Currency != other.Currency) throw new InvalidOperationException("Cannot subtract amounts in different currencies.");
        return new Money(Amount - other.Amount, Currency);
    }

    public Money Multiply(int quantity) => new(Amount * quantity, Currency);

    public override string ToString() => $"{Currency} {Amount:F2}";
}
