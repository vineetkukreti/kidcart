using KidCart.Domain.Entities;

namespace KidCart.Domain.Interfaces;

public interface ICartRepository : IRepository<Cart>
{
    Task<Cart?> GetByUserIdAsync(Guid userId, CancellationToken cancellationToken = default);
    Task<Cart?> GetBySessionIdAsync(string sessionId, CancellationToken cancellationToken = default);
}
