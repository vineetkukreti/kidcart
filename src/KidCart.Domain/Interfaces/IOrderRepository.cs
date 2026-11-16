using KidCart.Domain.Entities;
using KidCart.Domain.Enums;

namespace KidCart.Domain.Interfaces;

public interface IOrderRepository : IRepository<Order>
{
    Task<Order?> GetByOrderNumberAsync(string orderNumber, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<Order>> GetByUserIdAsync(Guid userId, CancellationToken cancellationToken = default);
    Task<(IReadOnlyList<Order> Items, int TotalCount)> GetPagedAsync(
        int page, int pageSize,
        OrderStatus? status = null,
        Guid? userId = null,
        DateTime? fromDate = null,
        DateTime? toDate = null,
        CancellationToken cancellationToken = default);
}
