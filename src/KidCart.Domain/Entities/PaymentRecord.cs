using KidCart.Domain.Enums;

namespace KidCart.Domain.Entities;

public class PaymentRecord : BaseEntity
{
    public Guid OrderId { get; private set; }
    public Order Order { get; private set; } = null!;
    public string GatewayName { get; private set; } = null!;
    public string GatewayTransactionId { get; private set; } = null!;
    public decimal Amount { get; private set; }
    public string Currency { get; private set; } = "INR";
    public PaymentStatus Status { get; private set; } = PaymentStatus.Pending;
    public string? GatewayResponse { get; private set; }

    private PaymentRecord() { } // EF Core

    public static PaymentRecord Create(
        Guid orderId,
        string gatewayName,
        string gatewayTransactionId,
        decimal amount,
        string currency = "INR")
    {
        return new PaymentRecord
        {
            OrderId = orderId,
            GatewayName = gatewayName,
            GatewayTransactionId = gatewayTransactionId,
            Amount = Math.Round(amount, 2),
            Currency = currency
        };
    }

    public void MarkCaptured(string? response = null)
    {
        Status = PaymentStatus.Captured;
        GatewayResponse = response;
        UpdatedAt = DateTime.UtcNow;
    }

    public void MarkFailed(string? response = null)
    {
        Status = PaymentStatus.Failed;
        GatewayResponse = response;
        UpdatedAt = DateTime.UtcNow;
    }

    public void MarkRefunded(string? response = null)
    {
        Status = PaymentStatus.Refunded;
        GatewayResponse = response;
        UpdatedAt = DateTime.UtcNow;
    }
}
