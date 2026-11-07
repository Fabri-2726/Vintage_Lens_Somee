using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using ECommerceFotografia.Models;
using System.Threading.Tasks;
using System.Linq;
using System;
using iTextSharp.text;
using iTextSharp.text.pdf;
using System.IO;

namespace ECommerceFotografia.Controllers
{
    [Authorize]
    public class CarritoController : Controller
    {
        private readonly InventarioContext _context;
        private readonly IWebHostEnvironment _env;

        public CarritoController(InventarioContext context, IWebHostEnvironment env)
        {
            _context = context;
            _env = env;
        }

        // POST: /Carrito/Agregar
        [HttpPost]
        public async Task<IActionResult> Agregar(int productoId, int cantidad)
        {
            // Se obtiene el usuario real logueado a través de las cookies
            string email = User.FindFirstValue(ClaimTypes.Email);
            var usuario = await _context.Usuarios.FirstOrDefaultAsync(u => u.Email == email);

            if (usuario == null) return RedirectToAction("Login", "Auth");

            // Buscar si el producto ya está en el carrito para sumar la cantidad
            var itemExistente = await _context.CarritoItems
                .FirstOrDefaultAsync(c => c.ProductoId == productoId && c.UsuarioId == usuario.Id);

            if (itemExistente != null)
            {
                itemExistente.Cantidad += cantidad;
            }
            else
            {
                var nuevoItem = new CarritoItem
                {
                    ProductoId = productoId,
                    UsuarioId = usuario.Id,
                    Cantidad = cantidad
                };
                _context.CarritoItems.Add(nuevoItem);
            }

            await _context.SaveChangesAsync();
            
            return RedirectToAction("Index");
        }

        // GET: /Carrito/Index
        public async Task<IActionResult> Index()
        {
            string email = User.FindFirstValue(ClaimTypes.Email);
            var usuario = await _context.Usuarios.FirstOrDefaultAsync(u => u.Email == email);

            // Cargar los items del carrito incluyendo los datos del producto
            var items = await _context.CarritoItems
                .Include(c => c.Producto)
                .Where(c => c.UsuarioId == usuario.Id)
                .ToListAsync();

            // Cargar y enviar las direcciones del usuario a la vista
            ViewBag.Direcciones = await _context.Direcciones.Where(d => d.UsuarioId == usuario.Id).ToListAsync();

            return View(items);
        }

        // GET: /Carrito/Checkout
        public async Task<IActionResult> Checkout()
        {
            string email = User.FindFirstValue(ClaimTypes.Email);
            var usuario = await _context.Usuarios.FirstOrDefaultAsync(u => u.Email == email);

            var items = await _context.CarritoItems.Include(c => c.Producto).Where(c => c.UsuarioId == usuario.Id).ToListAsync();
            
            if (!items.Any()) return RedirectToAction("Index");
            
            ViewBag.Total = items.Sum(i => i.Cantidad * i.Producto.Precio);
            return View();
        }

        // POST: /Carrito/ProcesarPago
        [HttpPost]
        public async Task<IActionResult> ProcesarPago(string metodoPago, string nombreTitular, string direccionEnvioSeleccionada)
        {
            string email = User.FindFirstValue(ClaimTypes.Email);
            var usuario = await _context.Usuarios.FirstOrDefaultAsync(u => u.Email == email);

            var carrito = await _context.CarritoItems.Include(c => c.Producto).Where(c => c.UsuarioId == usuario.Id).ToListAsync();
            
            if (!carrito.Any()) return RedirectToAction("Index");

            string folio = "VL-" + DateTime.Now.ToString("yyyyMMdd") + "-" + Guid.NewGuid().ToString().Substring(0, 6).ToUpper();
            string cuentaSpei = "";
            string codigoBarrasOxxo = "";

            if (metodoPago == "Transferencia SPEI")
            {
                cuentaSpei = "Banco: STPMEX | Beneficiario: Vintage Lens S.A. de C.V. | CLABE: 646180111812345678";
            }
            else if (metodoPago == "Depósito en Efectivo")
            {
                codigoBarrasOxxo = "98765" + new Random().Next(100000000, 999999999).ToString();
            }

            // 0. GUARDAR DATOS EN SESIÓN PARA LA GENERACIÓN DEL RECIBO PDF
            HttpContext.Session.SetString("DireccionEnvio", direccionEnvioSeleccionada ?? "Dirección registrada");
            HttpContext.Session.SetString("MetodoPago", metodoPago ?? "Tarjeta de Crédito / Débito");
            if (carrito.Any())
            {
                HttpContext.Session.SetInt32("UltimoProductoCompradoId", carrito.First().ProductoId);
            }

            // Si no se seleccionó ninguna dirección del desplegable, toma la primera registrada del usuario
            if (string.IsNullOrWhiteSpace(direccionEnvioSeleccionada))
            {
                var dirGuardada = await _context.Direcciones.FirstOrDefaultAsync(d => d.UsuarioId == usuario.Id);
                if (dirGuardada != null)
                {
                    direccionEnvioSeleccionada = $"{dirGuardada.Alias} - {dirGuardada.DireccionCompleta}";
                }
            }

            // Guardar en la sesión como respaldo
            HttpContext.Session.SetString("DireccionEnvio", direccionEnvioSeleccionada ?? "");

            // 1. Crear y guardar el pedido incluyendo la Dirección
            var pedido = new Pedido { 
                UsuarioId = usuario.Id, 
                Folio = folio, 
                Total = carrito.Sum(c => c.Cantidad * c.Producto.Precio), 
                MetodoPago = metodoPago, 
                EstadoPago = "Aprobado",
                DireccionEnvio = direccionEnvioSeleccionada 
            };
            
            _context.Pedidos.Add(pedido);
            await _context.SaveChangesAsync(); 

            // 2. Procesar los detalles usando el ID real
            foreach (var item in carrito)
            {
                _context.DetallePedidos.Add(new DetallePedido { 
                    PedidoId = pedido.Id, 
                    ProductoId = item.ProductoId, 
                    Cantidad = item.Cantidad, 
                    PrecioUnitario = item.Producto.Precio 
                });
                
                // Reducción de inventario (Stock)
                var productoDb = await _context.Productos.FindAsync(item.ProductoId);
                if (productoDb != null && productoDb.Stock >= item.Cantidad)
                {
                    productoDb.Stock -= item.Cantidad;
                }
            }
            
            // 3. Vaciar el carrito y guardar los detalles finales
            _context.CarritoItems.RemoveRange(carrito);
            await _context.SaveChangesAsync();

            // Conservar todas las variables ViewBag para la vista Confirmación
            ViewBag.Folio = folio;
            ViewBag.MetodoPago = metodoPago;
            ViewBag.CuentaSpei = cuentaSpei;
            ViewBag.CodigoBarrasOxxo = codigoBarrasOxxo;
            ViewBag.NombreTitular = nombreTitular ?? "Cliente";

            // SOLUCIÓN AL ERROR: Se pasa 'pedido' como modelo para que @Model.Folio en Confirmacion.cshtml no sea NULL
            return View("Confirmacion", pedido);
        }

        [HttpGet]
        public async Task<IActionResult> DescargarReciboPdf(string folio)
        {
            if (!User.Identity.IsAuthenticated) return RedirectToAction("Login", "Auth");

            string email = User.FindFirstValue(ClaimTypes.Email);
            var usuario = await _context.Usuarios.FirstOrDefaultAsync(u => u.Email == email);
            if (usuario == null) return RedirectToAction("Index");

            // 1. Obtener la orden real almacenada en la base de datos por su Folio
            var pedido = await _context.Pedidos
                .Include(p => p.DetallePedidos)
                    .ThenInclude(d => d.Producto)
                .FirstOrDefaultAsync(p => p.Folio == folio && p.UsuarioId == usuario.Id);

            // Fallback: si no encuentra la orden específica por folio, toma la última realizada por el usuario
            if (pedido == null)
            {
                pedido = await _context.Pedidos
                    .Include(p => p.DetallePedidos)
                        .ThenInclude(d => d.Producto)
                    .Where(p => p.UsuarioId == usuario.Id)
                    .OrderByDescending(p => p.Id)
                    .FirstOrDefaultAsync();
            }

            if (pedido == null) return RedirectToAction("Index");

            DateTime fechaCompra = DateTime.Now;
            DateTime fechaEstimadaEntrega = fechaCompra.AddDays(7);
            string paqueteria = "DHL Express / FedEx Premium";
            
            // Obtiene la dirección real guardada en la orden
            string direccionEnvio = !string.IsNullOrEmpty(pedido.DireccionEnvio) ? pedido.DireccionEnvio : "Dirección registrada en perfil";
            string metodoPago = pedido.MetodoPago ?? "Tarjeta de Crédito / Débito";

            using (MemoryStream ms = new MemoryStream())
            {
                iTextSharp.text.Document doc = new iTextSharp.text.Document(iTextSharp.text.PageSize.A4, 36, 36, 36, 36);
                PdfWriter writer = PdfWriter.GetInstance(doc, ms);
                doc.Open();

                BaseColor darkColor = new BaseColor(34, 32, 31);     
                BaseColor goldColor = new BaseColor(197, 160, 89);   
                BaseColor borderGray = new BaseColor(220, 220, 220);
                BaseColor lightBoxBg = new BaseColor(248, 249, 250);

                Font titleFont = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 20, darkColor);
                Font subTitleFont = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 10, goldColor);
                Font boldFont = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 9, darkColor);
                Font regularFont = FontFactory.GetFont(FontFactory.HELVETICA, 9, darkColor);
                Font smallMuted = FontFactory.GetFont(FontFactory.HELVETICA, 8, BaseColor.Gray);

                // 1. ENCABEZADO
                PdfPTable headerTable = new PdfPTable(2) { WidthPercentage = 100 };
                headerTable.SetWidths(new float[] { 60, 40 });

                PdfPCell logoCell = new PdfPCell(new Phrase("VINTAGE LENS", titleFont)) { Border = Rectangle.NO_BORDER };
                PdfPCell folioCell = new PdfPCell(new Phrase($"COMPROBANTE DE COMPRA\nFolio: {pedido.Folio}", subTitleFont)) { 
                    Border = Rectangle.NO_BORDER, 
                    HorizontalAlignment = Element.ALIGN_RIGHT 
                };

                headerTable.AddCell(logoCell);
                headerTable.AddCell(folioCell);
                doc.Add(headerTable);

                doc.Add(new Paragraph(new Chunk(new iTextSharp.text.pdf.draw.LineSeparator(1f, 100f, goldColor, Element.ALIGN_CENTER, -2))));
                doc.Add(new Paragraph(" "));

                // 2. DATOS DE CLIENTE Y DIRECCIÓN DE ENVÍO
                PdfPTable infoTable = new PdfPTable(2) { WidthPercentage = 100 };
                infoTable.SetWidths(new float[] { 50, 50 });

                PdfPCell clientCell = new PdfPCell() { Border = Rectangle.NO_BORDER, PaddingRight = 10 };
                clientCell.AddElement(new Paragraph("DATOS DEL CLIENTE", boldFont));
                clientCell.AddElement(new Paragraph($"Cliente: {usuario.Nombre}", regularFont));
                clientCell.AddElement(new Paragraph($"Correo: {usuario.Email}", regularFont));
                clientCell.AddElement(new Paragraph($"Método de Pago: {metodoPago}", regularFont));

                PdfPCell shippingCell = new PdfPCell() { Border = Rectangle.NO_BORDER, PaddingLeft = 10 };
                shippingCell.AddElement(new Paragraph("DETALLES DE ENVÍO", boldFont));
                shippingCell.AddElement(new Paragraph($"Dirección: {direccionEnvio}", regularFont));
                shippingCell.AddElement(new Paragraph($"Paquetería: {paqueteria}", regularFont));
                shippingCell.AddElement(new Paragraph($"Fecha Estimada de Entrega: {fechaEstimadaEntrega:dd/MM/yyyy}", boldFont));

                infoTable.AddCell(clientCell);
                infoTable.AddCell(shippingCell);
                doc.Add(infoTable);

                doc.Add(new Paragraph(" "));

                // 3. BLOQUE DINÁMICO POR MÉTODO DE PAGO
                PdfPTable paymentBox = new PdfPTable(1) { WidthPercentage = 100 };
                PdfPCell boxCell = new PdfPCell() { BackgroundColor = lightBoxBg, Padding = 10, BorderColor = borderGray };

                if (metodoPago.Contains("SPEI") || metodoPago.Contains("Transferencia"))
                {
                    boxCell.AddElement(new Paragraph("INSTRUCCIONES DE TRANSFERENCIA BANCARIA (SPEI)", boldFont));
                    boxCell.AddElement(new Paragraph("Banco: STPMEX | Beneficiario: Vintage Lens S.A. de C.V.", regularFont));
                    boxCell.AddElement(new Paragraph("CLABE Interbancaria: 646180111812345678", boldFont));
                    boxCell.AddElement(new Paragraph("Concepto de Pago: " + pedido.Folio, regularFont));
                }
                else if (metodoPago.Contains("Efectivo") || metodoPago.Contains("OXXO") || metodoPago.Contains("Depósito"))
                {
                    boxCell.AddElement(new Paragraph("FICHA DE PAGO EN EFECTIVO (OXXO / CONVENIENCIA)", boldFont));
                    boxCell.AddElement(new Paragraph("Muestra este código de barras en caja para realizar tu depósito:", regularFont));
                    
                    // Generar Código de Barras 128 nativo en iTextSharp
                    try
                    {
                        Barcode128 code128 = new Barcode128();
                        code128.CodeType = Barcode128.STARTA;
                        code128.Code = "98765" + Math.Abs(pedido.Folio.GetHashCode()).ToString().PadLeft(9, '0');
                        iTextSharp.text.Image barcodeImg = code128.CreateImageWithBarcode(writer.DirectContent, null, null);
                        barcodeImg.ScalePercent(110f);
                        barcodeImg.Alignment = Element.ALIGN_CENTER;
                        boxCell.AddElement(barcodeImg);
                    }
                    catch
                    {
                        boxCell.AddElement(new Paragraph("Código de Barras: 9876543210123456", boldFont));
                    }
                }
                else
                {
                    boxCell.AddElement(new Paragraph("CONFIRMACIÓN DE PAGO CON TARJETA", boldFont));
                    boxCell.AddElement(new Paragraph(" Transacción procesada y aprobada exitosamente mediante Tarjeta de Crédito / Débito.", regularFont));
                    boxCell.AddElement(new Paragraph($"Código de Autorización Bancaria: AUTH-{pedido.Folio.Replace("VL-", "")}", smallMuted));
                }

                paymentBox.AddCell(boxCell);
                doc.Add(paymentBox);

                doc.Add(new Paragraph(" "));

                // 4. TABLA DE PRODUCTOS
                PdfPTable table = new PdfPTable(5) { WidthPercentage = 100 };
                table.SetWidths(new float[] { 15, 45, 12, 14, 14 });

                string[] headers = { "Imagen", "Producto", "Cant.", "P. Unitario", "Subtotal" };
                foreach (var header in headers)
                {
                    PdfPCell hCell = new PdfPCell(new Phrase(header, FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 9, BaseColor.White)))
                    {
                        BackgroundColor = darkColor,
                        HorizontalAlignment = Element.ALIGN_CENTER,
                        Padding = 6,
                        BorderColor = darkColor
                    };
                    table.AddCell(hCell);
                }

                decimal totalCalculado = 0;
                foreach (var detalle in pedido.DetallePedidos)
                {
                    decimal subtotal = detalle.Cantidad * detalle.PrecioUnitario;
                    totalCalculado += subtotal;

                    PdfPCell imgCell = new PdfPCell();
                    imgCell.HorizontalAlignment = Element.ALIGN_CENTER;
                    imgCell.VerticalAlignment = Element.ALIGN_MIDDLE;
                    imgCell.Padding = 4;
                    imgCell.BorderColor = borderGray;

                    try
                    {
                        if (detalle.Producto != null && !string.IsNullOrEmpty(detalle.Producto.ImagenUrl))
                        {
                            string imgPath = Path.Combine(_env.WebRootPath, detalle.Producto.ImagenUrl.TrimStart('/'));
                            if (System.IO.File.Exists(imgPath))
                            {
                                iTextSharp.text.Image img = iTextSharp.text.Image.GetInstance(imgPath);
                                img.ScaleToFit(35f, 35f);
                                imgCell.AddElement(img);
                            }
                            else
                            {
                                imgCell.AddElement(new Phrase("-", regularFont));
                            }
                        }
                        else
                        {
                            imgCell.AddElement(new Phrase("-", regularFont));
                        }
                    }
                    catch
                    {
                        imgCell.AddElement(new Phrase("-", regularFont));
                    }

                    string nombreProducto = detalle.Producto?.Nombre ?? "Producto";
                    PdfPCell nameCell = new PdfPCell(new Phrase(nombreProducto, regularFont)) { VerticalAlignment = Element.ALIGN_MIDDLE, Padding = 6, BorderColor = borderGray };
                    PdfPCell qtyCell = new PdfPCell(new Phrase(detalle.Cantidad.ToString(), regularFont)) { HorizontalAlignment = Element.ALIGN_CENTER, VerticalAlignment = Element.ALIGN_MIDDLE, Padding = 6, BorderColor = borderGray };
                    PdfPCell priceCell = new PdfPCell(new Phrase($"${detalle.PrecioUnitario:N2}", regularFont)) { HorizontalAlignment = Element.ALIGN_RIGHT, VerticalAlignment = Element.ALIGN_MIDDLE, Padding = 6, BorderColor = borderGray };
                    PdfPCell subCell = new PdfPCell(new Phrase($"${subtotal:N2}", regularFont)) { HorizontalAlignment = Element.ALIGN_RIGHT, VerticalAlignment = Element.ALIGN_MIDDLE, Padding = 6, BorderColor = borderGray };

                    table.AddCell(imgCell);
                    table.AddCell(nameCell);
                    table.AddCell(qtyCell);
                    table.AddCell(priceCell);
                    table.AddCell(subCell);
                }

                doc.Add(table);

                // 5. TOTALES Y NOTA FINAL
                doc.Add(new Paragraph(" "));
                PdfPTable totalTable = new PdfPTable(2) { WidthPercentage = 40, HorizontalAlignment = Element.ALIGN_RIGHT };
                totalTable.SetWidths(new float[] { 50, 50 });

                decimal totalFinal = pedido.Total > 0 ? pedido.Total : totalCalculado;

                PdfPCell totalLbl = new PdfPCell(new Phrase("TOTAL PAGADO:", FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 11, darkColor))) { Border = Rectangle.NO_BORDER, HorizontalAlignment = Element.ALIGN_RIGHT };
                PdfPCell totalVal = new PdfPCell(new Phrase($"${totalFinal:N2} MXN", FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 12, goldColor))) { Border = Rectangle.NO_BORDER, HorizontalAlignment = Element.ALIGN_RIGHT };

                totalTable.AddCell(totalLbl);
                totalTable.AddCell(totalVal);
                doc.Add(totalTable);

                doc.Add(new Paragraph(" "));
                doc.Add(new Paragraph("Gracias por tu compra en Vintage Lens. Recibirás una notificación por correo cuando tu paquete sea recolectado por la paquetería.", smallMuted) { Alignment = Element.ALIGN_CENTER });

                doc.Close();
                return File(ms.ToArray(), "application/pdf", $"Recibo_{pedido.Folio}.pdf");
            }
        }

        [HttpPost]
        public async Task<IActionResult> AgregarAjax(int productoId)
        {
            if (!User.Identity.IsAuthenticated) return Json(new { success = false, redirect = "/Auth/Login" });
            string email = User.FindFirstValue(ClaimTypes.Email);
            var usuario = await _context.Usuarios.FirstOrDefaultAsync(u => u.Email == email);

            var item = await _context.CarritoItems.FirstOrDefaultAsync(c => c.ProductoId == productoId && c.UsuarioId == usuario.Id);
            if (item != null) item.Cantidad += 1;
            else _context.CarritoItems.Add(new CarritoItem { ProductoId = productoId, UsuarioId = usuario.Id, Cantidad = 1 });
            
            await _context.SaveChangesAsync();
            return Json(new { success = true });
        }

        [HttpPost]
        public async Task<IActionResult> ActualizarCantidad(int id, int cantidad)
        {
            var item = await _context.CarritoItems.FindAsync(id);
            if (item != null) {
                if (cantidad > 0) item.Cantidad = cantidad;
                else _context.CarritoItems.Remove(item);
                await _context.SaveChangesAsync();
            }
            return RedirectToAction("Index");
        }

        [HttpPost]                                                                  
        public async Task<IActionResult> NuevaDireccionAjax(string alias, string calle, string numero, string colonia, string cp, string ciudad, string estado)
        {
            string email = User.FindFirstValue(ClaimTypes.Email);
            var usuario = await _context.Usuarios.FirstOrDefaultAsync(u => u.Email == email);
            
            // Concatenación de los campos detallados
            string direccionCompleta = $"{calle} {numero}, Col. {colonia}, C.P. {cp}, {ciudad}, {estado}";
            
            _context.Direcciones.Add(new Direccion { UsuarioId = usuario.Id, Alias = alias, DireccionCompleta = direccionCompleta });
            await _context.SaveChangesAsync();
            
            return RedirectToAction("Index");
        }
    }
}