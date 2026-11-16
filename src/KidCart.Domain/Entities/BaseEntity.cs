namespace KidCart.Domain.Entities;

/// <summary>
/// Base class for all domain entities. Provides identity and audit fields.
/// </summary>
public abstract class BaseEntity
{
    public Guid Id { get; protected set; } = Guid.NewGuid();
    public DateTime CreatedAt { get; protected set; } = DateTime.UtcNow;
    public DateTime? UpdatedAt { get; protected set; }

    private readonly List<IDomainEvent> _domainEvents = new();
    public IReadOnlyCollection<IDomainEvent> DomainEvents => _domainEvents.AsReadOnly();

    public void AddDomainEvent(IDomainEvent domainEvent) => _domainEvents.Add(domainEvent);
    public void ClearDomainEvents() => _domainEvents.Clear();
}

/// <summary>
/// Marker interface for domain events dispatched via MediatR.
/// </summary>
public interface IDomainEvent : MediatR.INotification
{
    DateTime OccurredOn { get; }
}
