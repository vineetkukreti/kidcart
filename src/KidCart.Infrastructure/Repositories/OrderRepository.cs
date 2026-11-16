using KidCart.Domain.Entities;
using KidCart.Domain.Enums;
using KidCart.Domain.Interfaces;
using KidCart.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace KidCart.Infrastructure.Repositories;

public class OrderRepository : Repository<Order>, IOrderRepository
{
    public OrderRepository(KidCartDbContext context) : base(context) { }

    public async Task<Order?> GetByOrderNumberAsync(string orderNumber, CancellationToken cancellationToken = default)
        => await _dbSet
            .Include(o => o.Items)
            .Include(o => o.Payments)
            .FirstOrDefaultAsync(o => o.OrderNumber == orderNumber, cancellationToken);

    public async Task<IReadOnlyList<Order>> GetByUserIdAsync(Guid userId, CancellationToken cancellationToken = default)
        => await _dbSet
            .Include(o => o.Items)
            .Where(o => o.UserId == userId)
            .OrderByDescending(o => o.CreatedAt)
            .ToListAsync(cancellationToken);

    public async Task<(IReadOnlyList<Order> Items, int TotalCount)> GetPagedAsync(
        int page, int pageSize,
        OrderStatus? status = null,
        Guid? userId = null,
        DateTime? fromDate = null,
        DateTime? toDate = null,
        CancellationToken cancellationToken = default)
    {
        var query = _dbSet.Include(o => o.Items).AsQueryable();

        if (status.HasValue) query = query.Where(o => o.Status == status.Value);
        if (userId.HasValue) query = query.Where(o => o.UserId == userId.Value);
        if (fromDate.HasValue) query = query.Where(o => o.CreatedAt >= fromDate.Value);
        if (toDate.HasValue) query = query.Where(o => o.CreatedAt <= toDate.Value);

        var totalCount = await query.CountAsync(cancellationToken);
        var items = await query
            .OrderByDescending(o => o.CreatedAt)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync(cancellationToken);

        return (items, totalCount);
    }
}
