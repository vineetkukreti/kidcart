using System.Text.Json;
using KidCart.Domain.Interfaces;
using Microsoft.Extensions.Caching.Distributed;

namespace KidCart.Infrastructure.Caching;

public class RedisCacheService : ICacheService
{
    private readonly IDistributedCache _cache;
    private static readonly JsonSerializerOptions JsonOptions = new() { PropertyNamingPolicy = JsonNamingPolicy.CamelCase };

    public RedisCacheService(IDistributedCache cache) => _cache = cache;

    public async Task<T?> GetAsync<T>(string key, CancellationToken cancellationToken = default)
    {
        var data = await _cache.GetStringAsync(key, cancellationToken);
        return data is null ? default : JsonSerializer.Deserialize<T>(data, JsonOptions);
    }

    public async Task SetAsync<T>(string key, T value, TimeSpan? expiration = null, CancellationToken cancellationToken = default)
    {
        var options = new DistributedCacheEntryOptions
        {
            AbsoluteExpirationRelativeToNow = expiration ?? TimeSpan.FromMinutes(30)
        };
        var json = JsonSerializer.Serialize(value, JsonOptions);
        await _cache.SetStringAsync(key, json, options, cancellationToken);
    }

    public async Task RemoveAsync(string key, CancellationToken cancellationToken = default)
        => await _cache.RemoveAsync(key, cancellationToken);

    public Task RemoveByPrefixAsync(string prefix, CancellationToken cancellationToken = default)
    {
        // Redis prefix deletion requires IConnectionMultiplexer for SCAN+DEL.
        // For now, individual key removal is used. Full implementation requires StackExchange.Redis directly.
        return Task.CompletedTask;
    }
}
