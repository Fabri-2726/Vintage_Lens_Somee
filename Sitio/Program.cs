using System.Globalization;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.EntityFrameworkCore;
using ECommerceFotografia.Models;

// Misma cultura que usabas en local (formato de precios y fechas) sin depender del servidor de hosting.
var cultura = new CultureInfo("es-MX");
CultureInfo.DefaultThreadCurrentCulture = cultura;
CultureInfo.DefaultThreadCurrentUICulture = cultura;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();

// INYECTAR EL CONTEXTO DE BASE DE DATOS
builder.Services.AddDbContext<InventarioContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Guarda las llaves de cifrado en disco: así las sesiones/cookies de login NO se pierden
// cuando el hosting (Somee) reinicia la aplicación.
try
{
    var carpetaLlaves = Path.Combine(builder.Environment.ContentRootPath, "App_Data", "keys");
    Directory.CreateDirectory(carpetaLlaves);
    builder.Services.AddDataProtection()
        .PersistKeysToFileSystem(new DirectoryInfo(carpetaLlaves))
        .SetApplicationName("VintageLens");
}
catch
{
    // Si el hosting no permite escribir, la app sigue funcionando con llaves temporales.
}

// Añadir soporte para sesiones y autenticación (ANTES de builder.Build())
builder.Services.AddDistributedMemoryCache();
builder.Services.AddSession();
builder.Services.AddAuthentication("Cookies").AddCookie("Cookies", options => {
    options.LoginPath = "/Auth/Login";
    options.AccessDeniedPath = "/";
});

var app = builder.Build();

bool forzarHttps = app.Configuration.GetValue<bool>("Seguridad:ForzarHttps");
bool mostrarErrores = app.Configuration.GetValue<bool>("Seguridad:MostrarErrores");

// Configure the HTTP request pipeline.
if (mostrarErrores)
{
    // Solo para diagnosticar problemas en el hosting (ver appsettings.json).
    app.UseDeveloperExceptionPage();
}
else if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    if (forzarHttps)
    {
        app.UseHsts();
    }
}

if (forzarHttps)
{
    app.UseHttpsRedirection();
}

// Sirve también los archivos que se suben mientras el sitio está en línea
// (fotos de perfil e imágenes de productos nuevos).
app.UseStaticFiles();

// 1. PRIMERO EL ENRUTAMIENTO
app.UseRouting();

// 2. DESPUÉS LAS SESIONES Y SEGURIDAD
app.UseSession(); 
app.UseAuthentication();
app.UseAuthorization();

// 3. AL FINAL EL MAPEO DE RECURSOS Y CONTROLADORES
app.MapStaticAssets();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}")
    .WithStaticAssets();

app.Run();
