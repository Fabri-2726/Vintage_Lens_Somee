using System;
using System.Collections.Generic;

namespace ECommerceFotografia.Models
{
    public class Direccion
    {
        public int Id { get; set; }
        public int UsuarioId { get; set; }
        public string Alias { get; set; }
        public string DireccionCompleta { get; set; }

        public virtual Usuario Usuario { get; set; }
    }
}