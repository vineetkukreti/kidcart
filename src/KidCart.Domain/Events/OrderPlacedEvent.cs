using KidCart.Domain.Entities;

namespace KidCart.Domain.Events;

public sealed record OrderPlacedEvent(Guid OrderId, string OrderNumber, Guid UserId, decimal TotalAmount) : IDomainEvent
{
    public DateTime OccurredOn { get; } = DateTime.UtcNow;
}

public sealed record OrderConfirmedEvent(Guid OrderId, string OrderNumber) : IDomainEvent
{
    public DateTime OccurredOn { get; } = DateTime.UtcNow;
}

public sealed record OrderShippedEvent(Guid OrderId, string OrderNumber, string? TrackingNumber) : IDomainEvent
{
    public DateTime OccurredOn { get; } = DateTime.UtcNow;
}

public sealed record OrderDeliveredEvent(Guid OrderId, string OrderNumber) : IDomainEvent
{
    public DateTime OccurredOn { get; } = DateTime.UtcNow;
}

public sealed record OrderCancelledEvent(Guid OrderId, string OrderNumber, string Reason) : IDomainEvent
{
    public DateTime OccurredOn { get; } = DateTime.UtcNow;
}

public sealed record LowStockEvent(Guid ProductId, Guid VariantId, string ProductName, int CurrentStock) : IDomainEvent
{
    public DateTime OccurredOn { get; } = DateTime.UtcNow;
}

public sealed record PaymentCapturedEvent(Guid OrderId, Guid PaymentId, decimal Amount) : IDomainEvent
{
    public DateTime OccurredOn { get; } = DateTime.UtcNow;
}
