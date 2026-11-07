@echo off
REM Genera la carpeta "publicar" lista para subir a Somee por FTP.
REM Requiere tener instalado el SDK de .NET 10 (el mismo que usas en Visual Studio).
echo Publicando Vintage Lens...
dotnet publish ECommerceFotografia.csproj -c Release -o publicar
if errorlevel 1 (
  echo.
  echo ERROR al publicar. Revisa los mensajes de arriba.
  pause
  exit /b 1
)
echo.
echo LISTO. Sube TODO el contenido de la carpeta "publicar" a la carpeta www.TUSITIO.somee.com de tu FTP.
pause
