-- ============================================================
-- Vintage Lens - Script para SOMEE.COM (SQL Server)
-- Sin CREATE DATABASE / USE master (Somee ya te da la base vacia).
-- OPCIONAL: BORRA todas las tablas (usar solo si necesitas reinstalar desde cero).
-- ============================================================
IF OBJECT_ID(N'dbo.DetallePedidos', N'U') IS NOT NULL DROP TABLE [dbo].[DetallePedidos];
IF OBJECT_ID(N'dbo.CarritoItems', N'U') IS NOT NULL DROP TABLE [dbo].[CarritoItems];
IF OBJECT_ID(N'dbo.Favoritos', N'U') IS NOT NULL DROP TABLE [dbo].[Favoritos];
IF OBJECT_ID(N'dbo.Resenas', N'U') IS NOT NULL DROP TABLE [dbo].[Resenas];
IF OBJECT_ID(N'dbo.Direcciones', N'U') IS NOT NULL DROP TABLE [dbo].[Direcciones];
IF OBJECT_ID(N'dbo.Pedidos', N'U') IS NOT NULL DROP TABLE [dbo].[Pedidos];
IF OBJECT_ID(N'dbo.Productos', N'U') IS NOT NULL DROP TABLE [dbo].[Productos];
IF OBJECT_ID(N'dbo.Recompensas', N'U') IS NOT NULL DROP TABLE [dbo].[Recompensas];
IF OBJECT_ID(N'dbo.Categorias', N'U') IS NOT NULL DROP TABLE [dbo].[Categorias];
IF OBJECT_ID(N'dbo.Usuarios', N'U') IS NOT NULL DROP TABLE [dbo].[Usuarios];
