# KidCart

E-commerce platform for school and lifestyle products aimed at customers aged 3 through college, built with .NET 8 and a static HTML/JS frontend.

## Overview

KidCart is structured as a Clean Architecture .NET 8 solution (Domain / Application / Infrastructure / API / Shared / Web) backed by SQL Server and Redis, with a lightweight static frontend served by nginx. Everything can be started with Docker Compose via `kidcart.sh`.

## Features (as implemented)

- REST API under `api/v1`:
  - `Products` – list, get by slug, create
  - `Cart` – add items
  - `Orders` – place order
  - `Auth` – register, login, refresh (JWT bearer)
- Domain model: products, variants, images, categories, cart, orders, coupons, reviews, wishlists, payment records, age groups; `Money` and `Address` value objects; `OrderPlacedEvent`
- EF Core `KidCartDbContext`, repository + unit-of-work pattern
- Redis cache service
- MediatR + FluentValidation pipeline, Serilog logging, Swagger
- Static frontend (`frontend/`): storefront, product listing, product detail and dashboard pages (v1 and v2 designs)
- SQL schema + seed script (`scripts/seed-database.sql`)
- GitHub Actions CI workflow (`.github/workflows/ci.yml`)

## Status

Work in progress. The Blazor `KidCart.Web` project and the `tests/` projects are scaffolded but currently empty.

## Tech Stack

.NET 8, ASP.NET Core Web API, EF Core (SQL Server), Redis, MediatR, FluentValidation, Serilog, Swashbuckle, JWT; HTML/CSS/JS + nginx; Docker Compose.

## Project Structure

```
src/
  KidCart.Domain/          entities, enums, value objects, interfaces, events
  KidCart.Application/     DTOs, common result/paging, validation behaviour
  KidCart.Infrastructure/  EF Core DbContext, repositories, Redis cache
  KidCart.API/             controllers, middleware, Program.cs, Dockerfile
  KidCart.Shared/          shared code
  KidCart.Web/             Blazor WASM (scaffold)
tests/                     test projects (scaffold)
frontend/                  static storefront + nginx Dockerfile
scripts/seed-database.sql  schema and seed data
designs/                   UI design exports
kidcart.sh                 helper script for Docker Compose
```

## Setup

Requirements: Docker with Compose (or .NET 8 SDK, SQL Server and Redis for running locally).

```bash
./kidcart.sh start     # build and start web, API, SQL Server, Redis
./kidcart.sh logs
./kidcart.sh stop
```

- Frontend: http://localhost:3001
- API: http://localhost:5000 (Swagger at `/swagger`)

Other commands: `restart`, `status`, `rebuild`, `db-reset`, `help`.

## Configuration

Set via `appsettings.json` or environment variables (`__` as separator):

- `ConnectionStrings__DefaultConnection` – SQL Server connection string
- `ConnectionStrings__Redis` – Redis host:port
- `Jwt__Key`, `Jwt__Issuer`, `Jwt__Audience`, `Jwt__ExpiryMinutes`
- `Cors__Origins`

The SQL Server password in `docker-compose.yml` / `appsettings.json` is a local development default only. Change it and set a real `Jwt__Key` for any non-local deployment.
