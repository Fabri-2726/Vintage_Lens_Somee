using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ECommerceFotografia.Models;
using System.Security.Claims;
using System.Linq;

namespace ECommerceFotografia.Controllers
{
    public class ProductosController : Controller
    {
        private readonly InventarioContext _context;

        public ProductosController(InventarioContext context)
        {
            _context = context;
        }

        // GET: /Productos/Catalogo
        public async Task<IActionResult> Catalogo(int? categoriaId, string busqueda)
        {
            var query = _context.Productos.Include(p => p.Categoria).AsQueryable();

            if (categoriaId.HasValue)
            {
                query = query.Where(p => p.CategoriaId == categoriaId.Value);
            }

            if (!string.IsNullOrEmpty(busqueda))
            {
                query = query.Where(p => p.Nombre.Contains(busqueda) || p.Categoria.Nombre.Contains(busqueda));
            }

            ViewBag.Categorias = await _context.Categorias.ToListAsync();

            if (User.Identity.IsAuthenticated)
            {
                var email = User.FindFirstValue(ClaimTypes.Email);
                var user = await _context.Usuarios.FirstOrDefaultAsync(u => u.Email == email);
                if (user != null)
                {
                    if (string.IsNullOrEmpty(user.FotoPerfilUrl)) 
                    { 
                        user.FotoPerfilUrl = "/images/default-avatar.png"; 
                        await _context.SaveChangesAsync(); 
                    }
                    ViewBag.MisFavoritos = await _context.Favoritos
                        .Where(f => f.UsuarioId == user.Id)
                        .Select(f => f.ProductoId)
                        .ToListAsync();

                    // CONTAGIO DEL CARRITO EN LA BARRA:
                    ViewBag.CarritoCount = await _context.CarritoItems
                        .Where(c => c.UsuarioId == user.Id)
                        .SumAsync(c => c.Cantidad);
                }
            }
            else 
            { 
                ViewBag.MisFavoritos = new List<int>(); 
                ViewBag.CarritoCount = 0;
            }

            var productos = await query.ToListAsync();
            return View(productos);
        }

        // GET: /Productos/Detalles/5
        public async Task<IActionResult> Detalles(int id)
        {
            var producto = await _context.Productos
                .Include(p => p.Categoria)
                .Include(p => p.Resenas)
                .ThenInclude(r => r.Usuario)
                .FirstOrDefaultAsync(m => m.Id == id);

            if (producto == null) return NotFound();
            return View(producto);
        }
        
        // Simulación de lógica de negocio para carrito y recompensas
        public async Task<IActionResult> CalcularBeneficios(int usuarioId)
        {
            var carrito = await _context.CarritoItems
                .Include(c => c.Producto)
                .Where(c => c.UsuarioId == usuarioId).ToListAsync();

            decimal subtotal = carrito.Sum(c => c.Cantidad * (c.Producto != null ? c.Producto.Precio : 0));
            var recompensa = await _context.Recompensas
                .Where(r => r.MontoMinimo <= subtotal)
                .OrderByDescending(r => r.MontoMinimo)
                .FirstOrDefaultAsync();

            decimal totalFinal = subtotal;
            if (recompensa != null && recompensa.DescuentoPorcentaje.HasValue)
            {
                totalFinal -= subtotal * (recompensa.DescuentoPorcentaje.Value / 100);
            }

            return Json(new { Subtotal = subtotal, TotalApagar = totalFinal, Regalo = recompensa?.ProductoRegalo });
        }

        [HttpGet]
        public async Task<IActionResult> BuscarAjax(string q)
        {
            if (string.IsNullOrEmpty(q) || q.Length < 2) return Json(new List<object>());
            var resultados = await _context.Productos
                .Where(p => p.Nombre.Contains(q) || p.Categoria.Nombre.Contains(q))
                .Select(p => new { id = p.Id, nombre = p.Nombre, imagen = p.ImagenUrl, precio = p.Precio })
                .Take(6).ToListAsync();
            return Json(resultados);
        }
    }
}