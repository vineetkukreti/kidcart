using KidCart.Domain.Enums;

namespace KidCart.Application.DTOs;

public record LoginRequest(string Email, string Password);
public record RegisterRequest(string Email, string Password, string FirstName, string LastName, AgeGroup? AgeGroup, bool IsParent);
public record AuthResponse(string AccessToken, string RefreshToken, DateTime ExpiresAt, UserProfileDto User);
public record RefreshTokenRequest(string RefreshToken);

public record UserProfileDto
{
    public Guid Id { get; init; }
    public string Email { get; init; } = null!;
    public string FirstName { get; init; } = null!;
    public string LastName { get; init; } = null!;
    public string FullName => $"{FirstName} {LastName}";
    public UserRole Role { get; init; }
    public AgeGroup? AgeGroup { get; init; }
    public DateTime CreatedAt { get; init; }
}
