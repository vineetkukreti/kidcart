using KidCart.Application.DTOs;
using KidCart.Application.Features.Cart.Commands;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace KidCart.API.Controllers;

[ApiController]
[Route("api/v1/[controller]")]
public class CartController : ControllerBase
{
    private readonly IMediator _mediator;

    public CartController(IMediator mediator) => _mediator = mediator;

    [HttpPost("items")]
    public async Task<ActionResult<CartDto>> AddToCart([FromBody] AddToCartCommand command)
    {
        var result = await _mediator.Send(command);
        return result.IsSuccess ? Ok(result.Value) : BadRequest(result.Error);
    }
}
