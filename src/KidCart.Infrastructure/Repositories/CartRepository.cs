using KidCart.Domain.Entities;
using KidCart.Domain.Interfaces;
using KidCart.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace KidCart.Infrastructure.Repositories;

public class CartRepository : Repository<Cart>, ICartRepository
{
    public CartRepository(KidCartDbContext context) : base(context) { }

    public async Task<Cart?> GetByUserIdAsync(Guid userId, CancellationToken cancellationToken = default)
        => await _dbSet
            .Include(c => c.Items).ThenInclude(i => i.Product).ThenInclude(p => p.Images)
            .Include(c => c.Items).ThenInclude(i => i.Variant)
            .FirstOrDefaultAsync(c => c.UserId == userId, cancellationToken);

    public async Task<Cart?> GetBySessionIdAsync(string sessionId, CancellationToken cancellationToken = default)
        => await _dbSet
            .Include(c => c.Items).ThenInclude(i => i.Product).ThenInclude(p => p.Images)
            .Include(c => c.Items).ThenInclude(i => i.Variant)
            .FirstOrDefaultAsync(c => c.SessionId == sessionId, cancellationToken);
}
