using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using ECommerceFotografia.Models;

namespace ECommerceFotografia.Controllers
{
    [Authorize]
    public class FavoritosController : Controller
    {
        private readonly InventarioContext _context;

        public FavoritosController(InventarioContext context) { _context = context; }

        public async Task<IActionResult> Index()
        {
            string email = User.FindFirstValue(ClaimTypes.Email);
            var usuario = await _context.Usuarios.FirstOrDefaultAsync(u => u.Email == email);
            
            var favoritos = await _context.Favoritos
                .Include(f => f.Producto)
                .ThenInclude(p => p.Categoria)
                .Where(f => f.UsuarioId == usuario.Id)
                .ToListAsync();

            return View(favoritos);
        }

        [HttpPost]
        public async Task<IActionResult> ToggleFavorito(int productoId)
        {
            string email = User.FindFirstValue(ClaimTypes.Email);
            var usuario = await _context.Usuarios.FirstOrDefaultAsync(u => u.Email == email);

            var favoritoExistente = await _context.Favoritos
                .FirstOrDefaultAsync(f => f.UsuarioId == usuario.Id && f.ProductoId == productoId);

            if (favoritoExistente != null)
            {
                _context.Favoritos.Remove(favoritoExistente);
                await _context.SaveChangesAsync();
                return Json(new { status = "removed" });
            }
            else
            {
                _context.Favoritos.Add(new Favorito { UsuarioId = usuario.Id, ProductoId = productoId });
                await _context.SaveChangesAsync();
                return Json(new { status = "added" });
            }
        }
    }
}