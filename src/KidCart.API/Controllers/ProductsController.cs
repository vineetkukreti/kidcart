using KidCart.Application.Common;
using KidCart.Application.DTOs;
using KidCart.Application.Features.Products.Commands;
using KidCart.Application.Features.Products.Queries;
using KidCart.Domain.Enums;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace KidCart.API.Controllers;

[ApiController]
[Route("api/v1/[controller]")]
public class ProductsController : ControllerBase
{
    private readonly IMediator _mediator;

    public ProductsController(IMediator mediator) => _mediator = mediator;

    [HttpGet]
    public async Task<ActionResult<PagedResult<ProductDto>>> GetProducts(
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 20,
        [FromQuery] Guid? categoryId = null,
        [FromQuery] AgeGroup? ageGroup = null,
        [FromQuery] decimal? minPrice = null,
        [FromQuery] decimal? maxPrice = null,
        [FromQuery] string? brand = null,
        [FromQuery] string? sortBy = null,
        [FromQuery] bool sortDescending = false)
    {
        var result = await _mediator.Send(new GetProductsPagedQuery(
            page, pageSize, categoryId, ageGroup, minPrice, maxPrice, brand, sortBy, sortDescending));
        return result.IsSuccess ? Ok(result.Value) : BadRequest(result.Error);
    }

    [HttpGet("{slug}")]
    public async Task<ActionResult<ProductDto>> GetProduct(string slug)
    {
        var result = await _mediator.Send(new GetProductBySlugQuery(slug));
        return result.IsSuccess ? Ok(result.Value) : NotFound(result.Error);
    }

    [HttpPost]
    [Authorize(Roles = "Admin")]
    public async Task<ActionResult<ProductDto>> CreateProduct([FromBody] CreateProductCommand command)
    {
        var result = await _mediator.Send(command);
        return result.IsSuccess
            ? CreatedAtAction(nameof(GetProduct), new { slug = result.Value!.Slug }, result.Value)
            : BadRequest(result.Error);
    }
}
