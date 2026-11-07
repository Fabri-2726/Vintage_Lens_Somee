-- ============================================================
-- Vintage Lens - Crear / promover al SUPER USUARIO (Admin)
-- Ejecutar DESPUES de cargar la base de datos.
-- Edita las 3 variables de abajo antes de ejecutar.
-- ============================================================
DECLARE @Email nvarchar(255) = N'admin@vintagelens.com';
DECLARE @Password nvarchar(100) = N'fabriadmin27*';
-- Tu Chat ID de Telegram (el codigo de 6 digitos de inicio de sesion llega por Telegram).
DECLARE @TelegramChatId nvarchar(50) = N'2076807151';

IF EXISTS (SELECT 1 FROM dbo.Usuarios WHERE Email = @Email)
    UPDATE dbo.Usuarios
       SET Rol = N'Admin',
           PasswordHash = @Password,
           TelegramChatId = CASE WHEN @TelegramChatId <> N'' THEN @TelegramChatId ELSE TelegramChatId END
     WHERE Email = @Email;
ELSE
    INSERT INTO dbo.Usuarios (Email, PasswordHash, Rol, FechaRegistro, Nombre, TelegramChatId, FotoPerfilUrl)
    VALUES (@Email, @Password, N'Admin', GETUTCDATE(), N'Administrador', NULLIF(@TelegramChatId, N''), N'/images/default-avatar.png');

SELECT Id, Email, Rol, TelegramChatId FROM dbo.Usuarios WHERE Rol = N'Admin';
