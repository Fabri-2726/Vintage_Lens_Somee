using System;
using System.Collections.Generic;

namespace ECommerceFotografia.Models;

public partial class Favorito
{
    public int Id { get; set; }

    public int UsuarioId { get; set; }

    public int ProductoId { get; set; }

    public DateTime? FechaAgregado { get; set; }

    public virtual Producto Producto { get; set; } = null!;

    public virtual Usuario Usuario { get; set; } = null!;
}
