using FluentValidation;
using KidCart.Application.Common;
using KidCart.Application.DTOs;

namespace KidCart.Application.Features.Auth.Commands;

public sealed record LoginCommand(string Email, string Password) : ICommand<AuthResponse>;

public sealed class LoginValidator : AbstractValidator<LoginCommand>
{
    public LoginValidator()
    {
        RuleFor(x => x.Email).NotEmpty().EmailAddress();
        RuleFor(x => x.Password).NotEmpty().MinimumLength(6);
    }
}

public sealed record RegisterCommand(
    string Email,
    string Password,
    string FirstName,
    string LastName,
    Domain.Enums.AgeGroup? AgeGroup,
    bool IsParent
) : ICommand<AuthResponse>;

public sealed class RegisterValidator : AbstractValidator<RegisterCommand>
{
    public RegisterValidator()
    {
        RuleFor(x => x.Email).NotEmpty().EmailAddress();
        RuleFor(x => x.Password).NotEmpty().MinimumLength(8)
            .Matches(@"[A-Z]").WithMessage("Password must contain at least one uppercase letter.")
            .Matches(@"[a-z]").WithMessage("Password must contain at least one lowercase letter.")
            .Matches(@"[0-9]").WithMessage("Password must contain at least one digit.");
        RuleFor(x => x.FirstName).NotEmpty().MaximumLength(100);
        RuleFor(x => x.LastName).NotEmpty().MaximumLength(100);
    }
}

public sealed record RefreshTokenCommand(string RefreshToken) : ICommand<AuthResponse>;
