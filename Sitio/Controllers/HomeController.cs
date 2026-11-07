using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using System.Linq;
using System.Threading.Tasks;
using ECommerceFotografia.Models; // Asegúrate de incluir el espacio de nombres de tus modelos

namespace ECommerceFotografia.Controllers
{
    public class HomeController : Controller
    {
        // 1. DECLARACIÓN DE _context
        private readonly InventarioContext _context;

        // 2. CONSTRUCTOR PARA INYECTAR EL CONTEXTO
        public HomeController(InventarioContext context)
        {
            _context = context;
        }

        // 3. TU MÉTODO INDEX ACTUALIZADO
        public async Task<IActionResult> Index()
        {
            // Carga los productos para la vista
            var productosDestacados = await _context.Productos
                .Include(p => p.Categoria)
                .Take(10)
                .ToListAsync();

            // Verificación de Favoritos y asignación de foto predeterminada si no tiene
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
                }
            }
            else 
            { 
                ViewBag.MisFavoritos = new List<int>(); 
            }

            return View(productosDestacados);
        }
    }
}