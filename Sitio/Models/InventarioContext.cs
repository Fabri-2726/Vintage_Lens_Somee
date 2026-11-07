using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace ECommerceFotografia.Models;

public partial class InventarioContext : DbContext
{
    public InventarioContext(DbContextOptions<InventarioContext> options)
        : base(options)
    {
    }

    public virtual DbSet<CarritoItem> CarritoItems { get; set; }

    public virtual DbSet<Categoria> Categorias { get; set; }

    public virtual DbSet<DetallePedido> DetallePedidos { get; set; }

    public virtual DbSet<Direccion> Direcciones { get; set; }

    public virtual DbSet<Favorito> Favoritos { get; set; }

    public virtual DbSet<Pedido> Pedidos { get; set; }

    public virtual DbSet<Producto> Productos { get; set; }

    public virtual DbSet<Recompensa> Recompensas { get; set; }

    public virtual DbSet<Resena> Resenas { get; set; }

    public virtual DbSet<Usuario> Usuarios { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<CarritoItem>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__CarritoI__3214EC0776955937");

            entity.HasOne(d => d.Producto).WithMany(p => p.CarritoItems)
                .HasForeignKey(d => d.ProductoId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CarritoItems_Productos");

            entity.HasOne(d => d.Usuario).WithMany(p => p.CarritoItems)
                .HasForeignKey(d => d.UsuarioId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CarritoItems_Usuarios");
        });

        modelBuilder.Entity<Categoria>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Categori__3214EC07C068B043");

            entity.Property(e => e.Nombre).HasMaxLength(255);
        });

        modelBuilder.Entity<DetallePedido>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__DetalleP__3214EC072FADA37F");

            entity.Property(e => e.PrecioUnitario).HasColumnType("decimal(18, 2)");

            entity.HasOne(d => d.Pedido).WithMany(p => p.DetallePedidos)
                .HasForeignKey(d => d.PedidoId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DetallePedidos_Pedidos");

            entity.HasOne(d => d.Producto).WithMany(p => p.DetallePedidos)
                .HasForeignKey(d => d.ProductoId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DetallePedidos_Productos");
        });

        modelBuilder.Entity<Direccion>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Direccio__3214EC07A89E481F");

            entity.Property(e => e.Alias).HasMaxLength(50);
            entity.Property(e => e.DireccionCompleta).HasMaxLength(500);

            entity.HasOne(d => d.Usuario).WithMany(p => p.Direcciones)
                .HasForeignKey(d => d.UsuarioId)
                .HasConstraintName("FK__Direccion__Usuar__03F0984C");
        });

        modelBuilder.Entity<Favorito>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Favorito__3214EC07C65FB607");

            entity.Property(e => e.FechaAgregado)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");

            entity.HasOne(d => d.Producto).WithMany(p => p.Favoritos)
                .HasForeignKey(d => d.ProductoId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Favoritos__Produ__71D1E811");

            entity.HasOne(d => d.Usuario).WithMany(p => p.Favoritos)
                .HasForeignKey(d => d.UsuarioId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Favoritos__Usuar__70DDC3D8");
        });

        modelBuilder.Entity<Pedido>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Pedidos__3214EC071F8014C6");

            entity.HasIndex(e => e.Folio, "UQ__Pedidos__BAB84EF7907D5F92").IsUnique();

            entity.Property(e => e.DireccionEnvio).HasMaxLength(500);
            entity.Property(e => e.EstadoPago).HasMaxLength(50);
            entity.Property(e => e.Fecha)
                .HasDefaultValueSql("(getutcdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Folio).HasMaxLength(50);
            entity.Property(e => e.MetodoPago).HasMaxLength(50);
            entity.Property(e => e.Total).HasColumnType("decimal(18, 2)");

            entity.HasOne(d => d.Usuario).WithMany(p => p.Pedidos)
                .HasForeignKey(d => d.UsuarioId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Pedidos_Usuarios");
        });

        modelBuilder.Entity<Producto>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Producto__3214EC07B57A8A14");

            entity.Property(e => e.Nombre).HasMaxLength(255);
            entity.Property(e => e.Precio).HasColumnType("decimal(18, 2)");

            entity.HasOne(d => d.Categoria).WithMany(p => p.Productos)
                .HasForeignKey(d => d.CategoriaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Productos_Categorias");
        });

        modelBuilder.Entity<Recompensa>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Recompen__3214EC07481D1988");

            entity.Property(e => e.DescuentoPorcentaje).HasColumnType("decimal(5, 2)");
            entity.Property(e => e.MontoMinimo).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.ProductoRegalo).HasMaxLength(255);
        });

        modelBuilder.Entity<Resena>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Resenas__3214EC074FD8D599");

            entity.Property(e => e.Fecha)
                .HasDefaultValueSql("(getutcdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Verificada).HasDefaultValue(true);

            entity.HasOne(d => d.Producto).WithMany(p => p.Resenas)
                .HasForeignKey(d => d.ProductoId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Resenas_Productos");

            entity.HasOne(d => d.Usuario).WithMany(p => p.Resenas)
                .HasForeignKey(d => d.UsuarioId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Resenas_Usuarios");
        });

        modelBuilder.Entity<Usuario>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Usuarios__3214EC07E7D83C89");

            entity.Property(e => e.Email).HasMaxLength(255);
            entity.Property(e => e.FechaRegistro)
                .HasDefaultValueSql("(getutcdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.FotoPerfilUrl)
                .HasMaxLength(500)
                .HasDefaultValue("/images/default-avatar.png");
            entity.Property(e => e.Nombre).HasMaxLength(100);
            entity.Property(e => e.Rol)
                .HasMaxLength(50)
                .HasDefaultValue("Cliente");
            entity.Property(e => e.TelegramChatId).HasMaxLength(50);
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
