FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["src/KidCart.API/KidCart.API.csproj", "KidCart.API/"]
COPY ["src/KidCart.Application/KidCart.Application.csproj", "KidCart.Application/"]
COPY ["src/KidCart.Domain/KidCart.Domain.csproj", "KidCart.Domain/"]
COPY ["src/KidCart.Infrastructure/KidCart.Infrastructure.csproj", "KidCart.Infrastructure/"]
COPY ["src/KidCart.Shared/KidCart.Shared.csproj", "KidCart.Shared/"]
RUN dotnet restore "KidCart.API/KidCart.API.csproj"
COPY src/ .
RUN dotnet build "KidCart.API/KidCart.API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "KidCart.API/KidCart.API.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "KidCart.API.dll"]
