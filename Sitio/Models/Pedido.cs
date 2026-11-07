using System;
using System.Collections.Generic;

namespace ECommerceFotografia.Models;

public partial class Pedido
{
    public int Id { get; set; }

    public int UsuarioId { get; set; }

    public string Folio { get; set; } = null!;

    public decimal Total { get; set; }

    public string MetodoPago { get; set; } = null!;

    public string EstadoPago { get; set; } = null!;

    public DateTime? Fecha { get; set; }

    public string? DireccionEnvio { get; set; }

    public virtual ICollection<DetallePedido> DetallePedidos { get; set; } = new List<DetallePedido>();

    public virtual Usuario Usuario { get; set; } = null!;
}
