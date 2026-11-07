# Vintage Lens → Somee.com (guía paso a paso)

Contenido:
- `Sitio/`      → tu proyecto ya modificado (listo para publicar)
- `BaseDeDatos/` → scripts SQL limpios para Somee

## PARTE 1 · Base de datos en Somee
1. Entra a somee.com → **MS SQL** → crea una base de datos (nómbrala `VintageLensDB`).
   Somee te muestra: **servidor** (xxx.mssql.somee.com), **base**, **usuario** y **contraseña** SQL.
2. Carga los datos. Elige UNA opción:
   - **Opción A (recomendada): SSMS.** Conéctate con el servidor/usuario/contraseña de Somee
     (en "Connect to Database" pon el nombre de tu base), abre `BaseDeDatos/VintageLens_Somee_COMPLETO.sql` y ejecuta (F5).
   - **Opción B: consola web de Somee.** Pega y ejecuta en orden los archivos de
     `BaseDeDatos/partes_para_consola_web/` (01, 02, 03 … 22).
3. Ejecuta `BaseDeDatos/CREAR_ADMIN.sql` (antes edita el correo/contraseña y pon tu **Telegram Chat ID**).
   Eso crea el super usuario (Rol = Admin).
   (Si ejecutaste algo a medias, `00_OPCIONAL_borrar_tablas.sql` borra las tablas para empezar de cero.)

## PARTE 2 · Conectar el sitio a la base
Abre `Sitio/appsettings.json` y reemplaza los 4 `PEGA_AQUI_...` de `DefaultConnection`
con los datos de tu base en Somee. Es lo único que debes editar.

## PARTE 3 · Publicar el sitio
1. Doble clic en `Sitio/PUBLICAR.bat` (o en Visual Studio: Publicar → Carpeta). Se crea la carpeta `publicar`.
2. En somee.com → **Web Sites** → crea tu sitio (plan gratuito) con **ASP.NET Core / .NET 10**.
3. Sube por FTP (FileZilla) TODO el contenido de `publicar` a la carpeta `www.TUSITIO.somee.com`.
   (Datos FTP: panel de Somee → tu sitio → FTP.)
4. Abre `http://TUSITIO.somee.com`.

## Si algo falla
- Pantalla genérica de error: en `appsettings.json` pon `"MostrarErrores": true`, vuelve a subir ese archivo y mira el error. Luego regrésalo a `false`.
- No llega el código de Telegram (el host podría bloquear salidas): pon `"Omitir2FA": true` temporalmente para poder entrar.
- Error 500.3x al iniciar: el runtime .NET 10 no está activo en tu sitio; selecciónalo en el panel de Somee o pídeme la versión .NET 9.

## Panel de administrador (nuevo)
Inicia sesión con el usuario Admin → menú de tu nombre → **Panel de Administración**:
resumen, productos (consultar/cambiar precio y stock, agregar, editar, eliminar) y todos los pedidos.

## Seguridad — importante
- Cambia la contraseña de Somee que compartiste en el chat.
- El token del bot de Telegram está escrito en `AuthController.cs`; regénéralo en @BotFather (/revoke) y pega el nuevo.
- Las contraseñas de usuarios se guardan en texto plano (diseño original); conviene cifrarlas más adelante.
