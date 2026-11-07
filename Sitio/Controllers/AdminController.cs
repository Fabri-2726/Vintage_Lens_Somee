using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ECommerceFotografia.Models;

namespace ECommerceFotografia.Controllers
{
    // Solo usuarios con Rol = 'Admin' en la tabla Usuarios pueden entrar aquí.
    [Authorize(Roles = "Admin")]
    [AutoValidateAntiforgeryToken]
    public class AdminController : Controller
    {
        private readonly InventarioContext _context;
        private readonly IWebHostEnvironment _env;

        private static readonly string[] ExtensionesPermitidas = { ".jpg", ".jpeg", ".png", ".webp", ".gif" };

        public AdminController(InventarioContext context, IWebHostEnvironment env)
        {
            _context = context;
            _env = env;
        }

        // ==================== RESUMEN ====================
        public async Task<IActionResult> Index()
        {
            ViewBag.TotalProductos = await _context.Productos.CountAsync();
            ViewBag.SinStock = await _context.Productos.CountAsync(p => p.Stock <= 0);
            ViewBag.TotalPedidos = await _context.Pedidos.CountAsync();
            ViewBag.TotalUsuarios = await _context.Usuarios.CountAsync();
            ViewBag.Ventas = (await _context.Pedidos.SumAsync(p => (decimal?)p.Total)) ?? 0m;
            return View();
        }

        // ==================== PRODUCTOS ====================
        public async Task<IActionResult> Productos(string? q)
        {
            var query = _context.Productos.Include(p => p.Categoria).AsQueryable();
            if (!string.IsNullOrWhiteSpace(q))
            {
                query = query.Where(p => p.Nombre.Contains(q) || p.Categoria.Nombre.Contains(q));
            }
            ViewBag.Q = q;
            var lista = await query.OrderBy(p => p.Id).ToListAsync();
            return View(lista);
        }

        // Cambio rápido de precio y stock desde la tabla
        [HttpPost]
        public async Task<IActionResult> ActualizarRapido(int id, decimal precio, int stock)
        {
            var producto = await _context.Productos.FindAsync(id);
            if (producto == null) return NotFound();

            if (precio < 0 || stock < 0)
            {
                TempData["Error"] = "El precio y el stock no pueden ser negativos.";
                return RedirectToAction(nameof(Productos));
            }

            producto.Precio = precio;
            producto.Stock = stock;
            await _context.SaveChangesAsync();

            TempData["Exito"] = $"\"{producto.Nombre}\" actualizado: ${precio:N2} MXN, stock {stock}.";
            return RedirectToAction(nameof(Productos));
        }

        [HttpGet]
        public async Task<IActionResult> Crear()
        {
            await CargarCategoriasAsync();
            ViewBag.EsNuevo = true;
            return View("ProductoForm", new Producto { Stock = 1 });
        }

        [HttpPost]
        public async Task<IActionResult> Crear(string nombre, string? descripcion, decimal precio, int stock, int categoriaId, string? imagenUrl, IFormFile? imagen)
        {
            string? error = await ValidarAsync(nombre, precio, stock, categoriaId, imagen);
            var producto = new Producto
            {
                Nombre = nombre ?? "",
                Descripcion = descripcion,
                Precio = precio,
                Stock = stock,
                CategoriaId = categoriaId,
                ImagenUrl = imagenUrl
            };

            if (error != null)
            {
                ViewBag.Error = error;
                ViewBag.EsNuevo = true;
                await CargarCategoriasAsync();
                return View("ProductoForm", producto);
            }

            producto.Nombre = nombre!.Trim();
            producto.ImagenUrl = await ResolverImagenAsync(imagen, imagenUrl, "/images/default-avatar.png");

            _context.Productos.Add(producto);
            await _context.SaveChangesAsync();

            TempData["Exito"] = $"Producto \"{producto.Nombre}\" agregado correctamente.";
            return RedirectToAction(nameof(Productos));
        }

        [HttpGet]
        public async Task<IActionResult> Editar(int id)
        {
            var producto = await _context.Productos.FindAsync(id);
            if (producto == null) return NotFound();

            await CargarCategoriasAsync();
            ViewBag.EsNuevo = false;
            return View("ProductoForm", producto);
        }

        [HttpPost]
        public async Task<IActionResult> Editar(int id, string nombre, string? descripcion, decimal precio, int stock, int categoriaId, string? imagenUrl, IFormFile? imagen)
        {
            var producto = await _context.Productos.FindAsync(id);
            if (producto == null) return NotFound();

            string? error = await ValidarAsync(nombre, precio, stock, categoriaId, imagen);
            if (error != null)
            {
                producto.Nombre = nombre ?? "";
                producto.Descripcion = descripcion;
                producto.Precio = precio;
                producto.Stock = stock;
                producto.CategoriaId = categoriaId;
                ViewBag.Error = error;
                ViewBag.EsNuevo = false;
                await CargarCategoriasAsync();
                // No se guarda nada: el objeto solo se usa para volver a mostrar el formulario.
                _context.Entry(producto).State = EntityState.Detached;
                return View("ProductoForm", producto);
            }

            producto.Nombre = nombre!.Trim();
            producto.Descripcion = descripcion;
            producto.Precio = precio;
            producto.Stock = stock;
            producto.CategoriaId = categoriaId;
            producto.ImagenUrl = await ResolverImagenAsync(imagen, imagenUrl, producto.ImagenUrl);

            await _context.SaveChangesAsync();

            TempData["Exito"] = $"Producto \"{producto.Nombre}\" actualizado correctamente.";
            return RedirectToAction(nameof(Productos));
        }

        [HttpPost]
        public async Task<IActionResult> Eliminar(int id)
        {
            var producto = await _context.Productos.FindAsync(id);
            if (producto == null) return NotFound();

            bool tienePedidos = await _context.DetallePedidos.AnyAsync(d => d.ProductoId == id);
            if (tienePedidos)
            {
                TempData["Error"] = $"\"{producto.Nombre}\" ya aparece en pedidos y no se puede eliminar. Ponle stock 0 para que deje de venderse.";
                return RedirectToAction(nameof(Productos));
            }

            _context.CarritoItems.RemoveRange(_context.CarritoItems.Where(c => c.ProductoId == id));
            _context.Favoritos.RemoveRange(_context.Favoritos.Where(f => f.ProductoId == id));
            _context.Resenas.RemoveRange(_context.Resenas.Where(r => r.ProductoId == id));
            _context.Productos.Remove(producto);
            await _context.SaveChangesAsync();

            TempData["Exito"] = $"Producto \"{producto.Nombre}\" eliminado.";
            return RedirectToAction(nameof(Productos));
        }

        // ==================== PEDIDOS ====================
        public async Task<IActionResult> Pedidos(string? q, int pagina = 1)
        {
            const int tamanoPagina = 25;

            var query = _context.Pedidos.Include(p => p.Usuario).AsQueryable();
            if (!string.IsNullOrWhiteSpace(q))
            {
                query = query.Where(p => p.Folio.Contains(q)
                                      || p.Usuario.Email.Contains(q)
                                      || (p.Usuario.Nombre != null && p.Usuario.Nombre.Contains(q)));
            }

            int total = await query.CountAsync();
            int totalPaginas = Math.Max(1, (int)Math.Ceiling(total / (double)tamanoPagina));
            if (pagina < 1) pagina = 1;
            if (pagina > totalPaginas) pagina = totalPaginas;

            var lista = await query
                .OrderByDescending(p => p.Fecha)
                .ThenByDescending(p => p.Id)
                .Skip((pagina - 1) * tamanoPagina)
                .Take(tamanoPagina)
                .ToListAsync();

            ViewBag.Q = q;
            ViewBag.Pagina = pagina;
            ViewBag.TotalPaginas = totalPaginas;
            ViewBag.TotalRegistros = total;
            return View(lista);
        }

        public async Task<IActionResult> PedidoDetalle(int id)
        {
            var pedido = await _context.Pedidos
                .Include(p => p.Usuario)
                .Include(p => p.DetallePedidos)
                    .ThenInclude(d => d.Producto)
                .FirstOrDefaultAsync(p => p.Id == id);

            if (pedido == null) return NotFound();
            return View(pedido);
        }

        // ==================== AYUDAS ====================
        private async Task CargarCategoriasAsync()
        {
            ViewBag.Categorias = await _context.Categorias.OrderBy(c => c.Nombre).ToListAsync();
        }

        private async Task<string?> ValidarAsync(string? nombre, decimal precio, int stock, int categoriaId, IFormFile? imagen)
        {
            if (string.IsNullOrWhiteSpace(nombre)) return "El nombre del producto es obligatorio.";
            if (nombre.Trim().Length > 255) return "El nombre no puede pasar de 255 caracteres.";
            if (precio < 0) return "El precio no puede ser negativo.";
            if (stock < 0) return "El stock no puede ser negativo.";
            if (!await _context.Categorias.AnyAsync(c => c.Id == categoriaId)) return "Selecciona una categoría válida.";

            if (imagen != null && imagen.Length > 0)
            {
                string ext = Path.GetExtension(imagen.FileName).ToLowerInvariant();
                if (!ExtensionesPermitidas.Contains(ext)) return "La imagen debe ser JPG, PNG, WEBP o GIF.";
                if (imagen.Length > 5 * 1024 * 1024) return "La imagen no puede pesar más de 5 MB.";
            }
            return null;
        }

        // Prioridad: imagen subida > URL escrita > valor actual
        private async Task<string?> ResolverImagenAsync(IFormFile? imagen, string? imagenUrl, string? valorActual)
        {
            if (imagen != null && imagen.Length > 0)
            {
                string carpeta = Path.Combine(_env.WebRootPath, "images", "productos");
                Directory.CreateDirectory(carpeta);
                string nombreArchivo = Guid.NewGuid().ToString("N") + Path.GetExtension(imagen.FileName).ToLowerInvariant();
                using (var stream = new FileStream(Path.Combine(carpeta, nombreArchivo), FileMode.Create))
                {
                    await imagen.CopyToAsync(stream);
                }
                return "/images/productos/" + nombreArchivo;
            }

            if (!string.IsNullOrWhiteSpace(imagenUrl)) return imagenUrl.Trim();
            return valorActual;
        }
    }
}
