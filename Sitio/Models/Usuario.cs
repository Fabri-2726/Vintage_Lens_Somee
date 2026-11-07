using System;
using System.Collections.Generic;

namespace ECommerceFotografia.Models;

public partial class Usuario
{
    public int Id { get; set; }

    public string Email { get; set; } = null!;

    public string PasswordHash { get; set; } = null!;

    public string? Rol { get; set; }

    public DateTime? FechaRegistro { get; set; }

    public string? Nombre { get; set; }

    public string? TelegramChatId { get; set; }

    public string? FotoPerfilUrl { get; set; }

    public virtual ICollection<CarritoItem> CarritoItems { get; set; } = new List<CarritoItem>();

    public virtual ICollection<Direccion> Direcciones { get; set; } = new List<Direccion>();

    public virtual ICollection<Favorito> Favoritos { get; set; } = new List<Favorito>();

    public virtual ICollection<Pedido> Pedidos { get; set; } = new List<Pedido>();

    public virtual ICollection<Resena> Resenas { get; set; } = new List<Resena>();
}
