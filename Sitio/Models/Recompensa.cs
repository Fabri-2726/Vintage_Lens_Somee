using System;
using System.Collections.Generic;

namespace ECommerceFotografia.Models;

public partial class Recompensa
{
    public int Id { get; set; }

    public decimal MontoMinimo { get; set; }

    public decimal? DescuentoPorcentaje { get; set; }

    public string? ProductoRegalo { get; set; }
}
