using KidCart.Domain.Entities;
using KidCart.Domain.Interfaces;
using KidCart.Infrastructure.Data;
using Microsoft.EntityFrameworkCore.Storage;

namespace KidCart.Infrastructure.Repositories;

public class UnitOfWork : IUnitOfWork
{
    private readonly KidCartDbContext _context;
    private IDbContextTransaction? _transaction;

    private IProductRepository? _products;
    private ICategoryRepository? _categories;
    private IOrderRepository? _orders;
    private ICartRepository? _carts;

    public UnitOfWork(KidCartDbContext context) => _context = context;

    public IProductRepository Products => _products ??= new ProductRepository(_context);
    public ICategoryRepository Categories => _categories ??= new CategoryRepository(_context);
    public IOrderRepository Orders => _orders ??= new OrderRepository(_context);
    public ICartRepository Carts => _carts ??= new CartRepository(_context);

    public IRepository<T> Repository<T>() where T : BaseEntity => new Repository<T>(_context);

    public async Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
        => await _context.SaveChangesAsync(cancellationToken);

    public async Task BeginTransactionAsync(CancellationToken cancellationToken = default)
        => _transaction = await _context.Database.BeginTransactionAsync(cancellationToken);

    public async Task CommitTransactionAsync(CancellationToken cancellationToken = default)
    {
        if (_transaction is not null)
        {
            await _transaction.CommitAsync(cancellationToken);
            await _transaction.DisposeAsync();
            _transaction = null;
        }
    }

    public async Task RollbackTransactionAsync(CancellationToken cancellationToken = default)
    {
        if (_transaction is not null)
        {
            await _transaction.RollbackAsync(cancellationToken);
            await _transaction.DisposeAsync();
            _transaction = null;
        }
    }

    public void Dispose()
    {
        _transaction?.Dispose();
        _context.Dispose();
    }
}
