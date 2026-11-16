using KidCart.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace KidCart.Infrastructure.Data.Configurations;

public class ProductConfiguration : IEntityTypeConfiguration<Product>
{
    public void Configure(EntityTypeBuilder<Product> builder)
    {
        builder.HasKey(p => p.Id);
        builder.Property(p => p.Name).IsRequired().HasMaxLength(200);
        builder.Property(p => p.Slug).IsRequired().HasMaxLength(200);
        builder.HasIndex(p => p.Slug).IsUnique();
        builder.Property(p => p.Description).IsRequired().HasMaxLength(5000);
        builder.Property(p => p.ShortDescription).HasMaxLength(500);
        builder.Property(p => p.BasePrice).HasPrecision(18, 2);
        builder.Property(p => p.CompareAtPrice).HasPrecision(18, 2);
        builder.Property(p => p.AverageRating).HasPrecision(3, 1);
        builder.Property(p => p.Brand).HasMaxLength(100);
        builder.Property(p => p.SKU).HasMaxLength(50);

        builder.HasOne(p => p.Category)
            .WithMany(c => c.Products)
            .HasForeignKey(p => p.CategoryId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasMany(p => p.Variants)
            .WithOne(v => v.Product)
            .HasForeignKey(v => v.ProductId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasMany(p => p.Images)
            .WithOne(i => i.Product)
            .HasForeignKey(i => i.ProductId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasIndex(p => p.CategoryId);
        builder.HasIndex(p => p.TargetAgeGroup);
        builder.HasIndex(p => p.IsActive);
        builder.HasIndex(p => p.BasePrice);
    }
}

public class CategoryConfiguration : IEntityTypeConfiguration<Category>
{
    public void Configure(EntityTypeBuilder<Category> builder)
    {
        builder.HasKey(c => c.Id);
        builder.Property(c => c.Name).IsRequired().HasMaxLength(100);
        builder.Property(c => c.Slug).IsRequired().HasMaxLength(100);
        builder.HasIndex(c => c.Slug).IsUnique();
        builder.Property(c => c.Description).HasMaxLength(500);
        builder.Property(c => c.ImageUrl).HasMaxLength(500);

        builder.HasOne(c => c.ParentCategory)
            .WithMany(c => c.SubCategories)
            .HasForeignKey(c => c.ParentCategoryId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}

public class OrderConfiguration : IEntityTypeConfiguration<Order>
{
    public void Configure(EntityTypeBuilder<Order> builder)
    {
        builder.HasKey(o => o.Id);
        builder.Property(o => o.OrderNumber).IsRequired().HasMaxLength(30);
        builder.HasIndex(o => o.OrderNumber).IsUnique();
        builder.Property(o => o.SubTotal).HasPrecision(18, 2);
        builder.Property(o => o.DiscountAmount).HasPrecision(18, 2);
        builder.Property(o => o.ShippingAmount).HasPrecision(18, 2);
        builder.Property(o => o.TaxAmount).HasPrecision(18, 2);
        builder.Property(o => o.TotalAmount).HasPrecision(18, 2);
        builder.Property(o => o.CouponCode).HasMaxLength(50);
        builder.Property(o => o.Notes).HasMaxLength(1000);

        builder.OwnsOne(o => o.ShippingAddress, a =>
        {
            a.Property(x => x.Line1).HasMaxLength(200).IsRequired();
            a.Property(x => x.Line2).HasMaxLength(200);
            a.Property(x => x.City).HasMaxLength(100).IsRequired();
            a.Property(x => x.State).HasMaxLength(100).IsRequired();
            a.Property(x => x.PostalCode).HasMaxLength(20).IsRequired();
            a.Property(x => x.Country).HasMaxLength(100);
        });

        builder.OwnsOne(o => o.BillingAddress, a =>
        {
            a.Property(x => x.Line1).HasMaxLength(200);
            a.Property(x => x.Line2).HasMaxLength(200);
            a.Property(x => x.City).HasMaxLength(100);
            a.Property(x => x.State).HasMaxLength(100);
            a.Property(x => x.PostalCode).HasMaxLength(20);
            a.Property(x => x.Country).HasMaxLength(100);
        });

        builder.HasMany(o => o.Items)
            .WithOne(i => i.Order)
            .HasForeignKey(i => i.OrderId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasMany(o => o.Payments)
            .WithOne(p => p.Order)
            .HasForeignKey(p => p.OrderId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasIndex(o => o.UserId);
        builder.HasIndex(o => o.Status);
        builder.HasIndex(o => o.CreatedAt);
    }
}

public class CouponConfiguration : IEntityTypeConfiguration<Coupon>
{
    public void Configure(EntityTypeBuilder<Coupon> builder)
    {
        builder.HasKey(c => c.Id);
        builder.Property(c => c.Code).IsRequired().HasMaxLength(50);
        builder.HasIndex(c => c.Code).IsUnique();
        builder.Property(c => c.Description).IsRequired().HasMaxLength(500);
        builder.Property(c => c.Value).HasPrecision(18, 2);
        builder.Property(c => c.MinimumOrderAmount).HasPrecision(18, 2);
        builder.Property(c => c.MaximumDiscount).HasPrecision(18, 2);
    }
}
