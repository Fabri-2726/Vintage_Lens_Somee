using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using ECommerceFotografia.Models;
using System.Net.Http;
using System.IO;
using Microsoft.AspNetCore.Http;

namespace ECommerceFotografia.Controllers
{
    public class AuthController : Controller
    {
        private readonly InventarioContext _context;
        private readonly IWebHostEnvironment _env;
        private readonly IConfiguration _config;
        private readonly string TelegramToken = "8995400839:AAG-qpWAoaKM-eIVgW_NKJmGwVG_j0S-VcI";

        public AuthController(InventarioContext context, IWebHostEnvironment env, IConfiguration config) 
        { 
            _context = context; 
            _env = env;
            _config = config;
        }

        // Crea la cookie de sesión (incluye el ROL para reconocer al administrador)
        private async Task IniciarSesionAsync(Usuario user)
        {
            string primerNombre = (user.Nombre ?? user.Email).Split(' ')[0];
            var claims = new List<Claim> 
            { 
                new Claim(ClaimTypes.Name, primerNombre),
                new Claim(ClaimTypes.Email, user.Email),
                new Claim(ClaimTypes.Role, string.IsNullOrWhiteSpace(user.Rol) ? "Cliente" : user.Rol),
                new Claim("FotoPerfil", user.FotoPerfilUrl ?? "/images/default-avatar.png")
            };
            var identity = new ClaimsIdentity(claims, "Cookies");
            await HttpContext.SignInAsync("Cookies", new ClaimsPrincipal(identity));
        }

        private IActionResult RedirigirTrasLogin(Usuario user)
        {
            if (string.Equals(user.Rol, "Admin", StringComparison.OrdinalIgnoreCase))
            {
                return RedirectToAction("Index", "Admin");
            }
            return RedirectToAction("Catalogo", "Productos");
        }

        // ==================== LOGIN ====================
        public IActionResult Login() => View();

        [HttpPost]
        public async Task<IActionResult> Login(string email, string password)
        {
            var user = await _context.Usuarios.FirstOrDefaultAsync(u => u.Email == email && u.PasswordHash == password);
            if (user != null)
            {
                // Válvula de emergencia: si el hosting bloquea Telegram, se puede activar
                // "Seguridad:Omitir2FA" en appsettings.json. Por defecto está en false.
                if (_config.GetValue<bool>("Seguridad:Omitir2FA"))
                {
                    await IniciarSesionAsync(user);
                    return RedirigirTrasLogin(user);
                }

                string codigo2FA = new Random().Next(100000, 999999).ToString();
                
                HttpContext.Session.SetString("2FACode", codigo2FA);
                HttpContext.Session.SetString("PendingUserEmail", user.Email);
                HttpContext.Session.SetString("PendingUserName", user.Nombre ?? user.Email);

                if (!string.IsNullOrEmpty(user.TelegramChatId))
                {
                    await EnviarTelegramMsg(user.TelegramChatId, $"Tu código de inicio de sesión para Vintage Lens es: {codigo2FA}");
                }
                return RedirectToAction("Verificar2FA");
            }
            
            ViewBag.Error = "Credenciales inválidas";
            return View();
        }

        [HttpGet]
        public IActionResult Verificar2FA() => View();

        [HttpPost]
        public async Task<IActionResult> Verificar2FA(string codigo)
        {
            string codigoGuardado = HttpContext.Session.GetString("2FACode");
            if (codigo == codigoGuardado)
            {
                string email = HttpContext.Session.GetString("PendingUserEmail");
                var user = await _context.Usuarios.FirstOrDefaultAsync(u => u.Email == email);
                if (user == null) return RedirectToAction("Login");

                await IniciarSesionAsync(user);
                return RedirigirTrasLogin(user);
            }
            ViewBag.Error = "Código incorrecto. Inténtalo de nuevo.";
            return View();
        }

        // ==================== REGISTRO CON 2FA ====================
        [HttpPost]
        public async Task<IActionResult> Registro(string nombre, string email, string password, string telegramChatId)
        {
            if (await _context.Usuarios.AnyAsync(u => u.Email == email))
            {
                ViewBag.ErrorRegistro = "El correo ya está registrado.";
                return View("Login");
            }

            string codigo2FA = new Random().Next(100000, 999999).ToString();

            HttpContext.Session.SetString("RegNombre", nombre ?? "");
            HttpContext.Session.SetString("RegEmail", email);
            HttpContext.Session.SetString("RegPassword", password);
            HttpContext.Session.SetString("RegTelegramId", telegramChatId ?? "");
            HttpContext.Session.SetString("Reg2FACode", codigo2FA);

            await EnviarTelegramMsg(telegramChatId, $"Tu código para confirmar tu registro en Vintage Lens es: {codigo2FA}");

            return RedirectToAction("VerificarRegistro2FA");
        }

        [HttpGet]
        public IActionResult VerificarRegistro2FA() => View();

        [HttpPost]
        public async Task<IActionResult> VerificarRegistro2FA(string codigo)
        {
            string codigoGuardado = HttpContext.Session.GetString("Reg2FACode");
            if (codigo == codigoGuardado)
            {
                var nuevoUsuario = new Usuario
                {
                    Nombre = HttpContext.Session.GetString("RegNombre"),
                    Email = HttpContext.Session.GetString("RegEmail"),
                    PasswordHash = HttpContext.Session.GetString("RegPassword"),
                    TelegramChatId = HttpContext.Session.GetString("RegTelegramId"),
                    Rol = "Cliente",
                    FotoPerfilUrl = "/images/default-avatar.png"
                };

                _context.Usuarios.Add(nuevoUsuario);
                await _context.SaveChangesAsync();

                ViewBag.ExitoRegistro = "¡Cuenta verificada y creada exitosamente! Ya puedes iniciar sesión.";
                return View("Login");
            }

            ViewBag.Error = "Código incorrecto. Verifica en Telegram e inténtalo nuevamente.";
            return View();
        }

        // ==================== PERFIL DE USUARIO ====================
        [HttpGet]
        public async Task<IActionResult> Perfil()
        {
            string userEmail = User.FindFirstValue(ClaimTypes.Email);
            if (string.IsNullOrEmpty(userEmail)) return RedirectToAction("Login");

            var usuario = await _context.Usuarios.FirstOrDefaultAsync(u => u.Email == userEmail);
            if (usuario == null) return RedirectToAction("Login");

            var pedidos = await _context.Pedidos
                .Where(p => p.UsuarioId == usuario.Id)
                .OrderByDescending(p => p.Fecha)
                .ToListAsync();

            ViewBag.Pedidos = pedidos;
            return View(usuario);
        }

        [HttpPost]
        public async Task<IActionResult> EditarPerfil(string nombre, string email, string password, string telegramChatId, IFormFile fotoPerfil)
        {
            string currentEmail = User.FindFirstValue(ClaimTypes.Email);
            var usuario = await _context.Usuarios.FirstOrDefaultAsync(u => u.Email == currentEmail);
            
            // Subir imagen al servidor local
            if (fotoPerfil != null && fotoPerfil.Length > 0)
            {
                string folderPath = Path.Combine(_env.WebRootPath, "images", "perfiles");
                Directory.CreateDirectory(folderPath);
                string fileName = Guid.NewGuid().ToString() + Path.GetExtension(fotoPerfil.FileName);
                using (var stream = new FileStream(Path.Combine(folderPath, fileName), FileMode.Create))
                {
                    await fotoPerfil.CopyToAsync(stream);
                }
                usuario.FotoPerfilUrl = "/images/perfiles/" + fileName;
                await _context.SaveChangesAsync();
            }

            string codigo2FA = new Random().Next(100000, 999999).ToString();
            HttpContext.Session.SetString("EditNombre", nombre ?? "");
            HttpContext.Session.SetString("EditEmail", email);
            HttpContext.Session.SetString("EditPassword", password);
            HttpContext.Session.SetString("EditTelegramId", telegramChatId ?? "");
            HttpContext.Session.SetString("Edit2FACode", codigo2FA);

            await EnviarTelegramMsg(usuario.TelegramChatId, $"Código para autorizar la actualización de tu perfil: {codigo2FA}");
            return RedirectToAction("VerificarEdicion2FA");
        }

        [HttpPost]
        public async Task<IActionResult> AgregarDireccion(string alias, string direccionCompleta)
        {
            string email = User.FindFirstValue(ClaimTypes.Email);
            var usuario = await _context.Usuarios.FirstOrDefaultAsync(u => u.Email == email);
            
            _context.Direcciones.Add(new Direccion { UsuarioId = usuario.Id, Alias = alias, DireccionCompleta = direccionCompleta });
            await _context.SaveChangesAsync();
            
            TempData["ExitoPerfil"] = "Dirección de envío agregada correctamente.";
            return RedirectToAction("Perfil");
        }
        
        [HttpGet]
        public IActionResult VerificarEdicion2FA() => View();

        [HttpPost]
        public async Task<IActionResult> VerificarEdicion2FA(string codigo)
        {
            string codigoGuardado = HttpContext.Session.GetString("Edit2FACode");
            if (codigo == codigoGuardado)
            {
                string currentEmail = User.FindFirstValue(ClaimTypes.Email);
                var usuario = await _context.Usuarios.FirstOrDefaultAsync(u => u.Email == currentEmail);

                if (usuario != null)
                {
                    usuario.Nombre = HttpContext.Session.GetString("EditNombre");
                    usuario.Email = HttpContext.Session.GetString("EditEmail");
                    usuario.PasswordHash = HttpContext.Session.GetString("EditPassword");
                    usuario.TelegramChatId = HttpContext.Session.GetString("EditTelegramId");

                    await _context.SaveChangesAsync();

                    // Reemitir Cookie con el nuevo nombre, email, rol y FOTO actualizada
                    await IniciarSesionAsync(usuario);
                }

                TempData["ExitoPerfil"] = "Tus datos se han actualizado correctamente.";
                return RedirectToAction("Perfil");
            }

            ViewBag.Error = "Código incorrecto. No se aplicaron los cambios.";
            return View();
        }

        public async Task<IActionResult> Logout()
        {
            await HttpContext.SignOutAsync("Cookies");
            HttpContext.Session.Clear();
            return RedirectToAction("Login");
        }

        private async Task EnviarTelegramMsg(string chatId, string mensaje)
        {
            if (string.IsNullOrEmpty(chatId)) return;
            try
            {
                using (var client = new HttpClient { Timeout = TimeSpan.FromSeconds(10) })
                {
                    string url = $"https://api.telegram.org/bot{TelegramToken}/sendMessage?chat_id={chatId}&text={Uri.EscapeDataString(mensaje)}";
                    await client.GetAsync(url);
                }
            }
            catch (Exception)
            {
                // Si Telegram no responde, no se cae el sitio (simplemente no llega el código).
            }
        }
    }
}