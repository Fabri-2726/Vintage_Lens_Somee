-- ============================================================
-- Vintage Lens - Script para SOMEE.COM (SQL Server)
-- Sin CREATE DATABASE / USE master (Somee ya te da la base vacia).
-- Ejecutar UNA sola vez sobre la base de datos vacia.
-- ============================================================
/****** Objeto: Table [dbo].[CarritoItems] Fecha de script: 30/10/2026 10:28:06 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CarritoItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UsuarioId] [int] NOT NULL,
	[ProductoId] [int] NOT NULL,
	[Cantidad] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Categorias] Fecha de script: 30/10/2026 10:28:06 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categorias](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[DetallePedidos] Fecha de script: 30/10/2026 10:28:06 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetallePedidos](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PedidoId] [int] NOT NULL,
	[ProductoId] [int] NOT NULL,
	[Cantidad] [int] NOT NULL,
	[PrecioUnitario] [decimal](18, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Direcciones] Fecha de script: 30/10/2026 10:28:06 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Direcciones](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UsuarioId] [int] NOT NULL,
	[Alias] [nvarchar](50) NULL,
	[DireccionCompleta] [nvarchar](500) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Favoritos] Fecha de script: 30/10/2026 10:28:06 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Favoritos](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UsuarioId] [int] NOT NULL,
	[ProductoId] [int] NOT NULL,
	[FechaAgregado] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Pedidos] Fecha de script: 30/10/2026 10:28:06 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pedidos](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UsuarioId] [int] NOT NULL,
	[Folio] [nvarchar](50) NOT NULL,
	[Total] [decimal](18, 2) NOT NULL,
	[MetodoPago] [nvarchar](50) NOT NULL,
	[EstadoPago] [nvarchar](50) NOT NULL,
	[Fecha] [datetime] NULL,
	[DireccionEnvio] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Productos] Fecha de script: 30/10/2026 10:28:06 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Productos](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](255) NOT NULL,
	[Descripcion] [nvarchar](max) NULL,
	[Precio] [decimal](18, 2) NOT NULL,
	[Stock] [int] NOT NULL,
	[ImagenUrl] [nvarchar](max) NULL,
	[CategoriaId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Recompensas] Fecha de script: 30/10/2026 10:28:06 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Recompensas](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MontoMinimo] [decimal](18, 2) NOT NULL,
	[DescuentoPorcentaje] [decimal](5, 2) NULL,
	[ProductoRegalo] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Resenas] Fecha de script: 30/10/2026 10:28:06 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Resenas](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductoId] [int] NOT NULL,
	[UsuarioId] [int] NOT NULL,
	[Calificacion] [int] NOT NULL,
	[Comentario] [nvarchar](max) NULL,
	[Verificada] [bit] NULL,
	[Fecha] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Usuarios] Fecha de script: 30/10/2026 10:28:06 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuarios](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Email] [nvarchar](255) NOT NULL,
	[PasswordHash] [nvarchar](max) NOT NULL,
	[Rol] [nvarchar](50) NULL,
	[FechaRegistro] [datetime] NULL,
	[Nombre] [nvarchar](100) NULL,
	[TelegramChatId] [nvarchar](50) NULL,
	[FotoPerfilUrl] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Categorias] ON 

INSERT [dbo].[Categorias] ([Id], [Nombre]) VALUES (1, N'Cámaras (Cuerpos)')
INSERT [dbo].[Categorias] ([Id], [Nombre]) VALUES (2, N'Lentes Zoom Estándar')
INSERT [dbo].[Categorias] ([Id], [Nombre]) VALUES (3, N'Lentes Fijos / Prime')
INSERT [dbo].[Categorias] ([Id], [Nombre]) VALUES (4, N'Teleobjetivos')
INSERT [dbo].[Categorias] ([Id], [Nombre]) VALUES (5, N'Lentes Gran Angular')
INSERT [dbo].[Categorias] ([Id], [Nombre]) VALUES (6, N'Iluminación')
INSERT [dbo].[Categorias] ([Id], [Nombre]) VALUES (7, N'Soportes (Trípodes)')
INSERT [dbo].[Categorias] ([Id], [Nombre]) VALUES (8, N'Almacenamiento (Memorias)')
INSERT [dbo].[Categorias] ([Id], [Nombre]) VALUES (9, N'Mochilas y Transporte')
INSERT [dbo].[Categorias] ([Id], [Nombre]) VALUES (10, N'Filtros Ópticos')
SET IDENTITY_INSERT [dbo].[Categorias] OFF
GO
SET IDENTITY_INSERT [dbo].[DetallePedidos] ON 

INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (1, 1, 42, 2, CAST(5500.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (2, 1, 1, 1, CAST(25000.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (3, 1, 45, 3, CAST(6500.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (4, 2, 2, 1, CAST(15000.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (14, 15676, 2, 1, CAST(15000.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (15, 15676, 32, 2, CAST(18000.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (16, 15677, 1, 1, CAST(25000.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (17, 15678, 2, 1, CAST(15000.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (18, 15679, 4, 1, CAST(18000.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (19, 15679, 2, 1, CAST(15000.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (20, 15680, 2, 3, CAST(15000.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (21, 15680, 21, 1, CAST(14000.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (22, 15680, 53, 1, CAST(4000.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (23, 15681, 2, 1, CAST(15000.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (24, 15682, 56, 2, CAST(2500.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (25, 15682, 3, 2, CAST(42000.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (26, 15682, 4, 1, CAST(18000.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (27, 15682, 20, 1, CAST(5000.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (28, 15683, 2, 1, CAST(15000.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (29, 15684, 1, 1, CAST(25000.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (30, 15685, 29, 1, CAST(10000.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (31, 15685, 1, 1, CAST(25000.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (32, 15685, 2, 2, CAST(15000.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (33, 15685, 3, 1, CAST(42000.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (34, 15686, 17, 1, CAST(17000.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (35, 15687, 2, 1, CAST(15000.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (36, 15688, 2, 1, CAST(15000.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (37, 15689, 2, 1, CAST(15000.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (38, 15689, 3, 1, CAST(42000.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (39, 15689, 13, 1, CAST(120000.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (40, 15689, 5, 1, CAST(40000.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (41, 15690, 14, 1, CAST(85000.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (42, 15691, 34, 1, CAST(40000.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (43, 15692, 20, 1, CAST(5000.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (44, 15693, 1, 1, CAST(25000.00 AS Decimal(18, 2)))
INSERT [dbo].[DetallePedidos] ([Id], [PedidoId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (45, 15694, 2, 1, CAST(15000.00 AS Decimal(18, 2)))
SET IDENTITY_INSERT [dbo].[DetallePedidos] OFF
GO
SET IDENTITY_INSERT [dbo].[Direcciones] ON 

INSERT [dbo].[Direcciones] ([Id], [UsuarioId], [Alias], [DireccionCompleta]) VALUES (1, 4, N'Casa', N'#2 SN, Col. El Mirador, C.P. 29520, Pichucalco, Chiapas')
SET IDENTITY_INSERT [dbo].[Direcciones] OFF
GO
SET IDENTITY_INSERT [dbo].[Favoritos] ON 

INSERT [dbo].[Favoritos] ([Id], [UsuarioId], [ProductoId], [FechaAgregado]) VALUES (1, 4, 1, CAST(N'2026-10-27T11:35:13.047' AS DateTime))
INSERT [dbo].[Favoritos] ([Id], [UsuarioId], [ProductoId], [FechaAgregado]) VALUES (3, 4, 13, CAST(N'2026-10-27T12:32:18.720' AS DateTime))
INSERT [dbo].[Favoritos] ([Id], [UsuarioId], [ProductoId], [FechaAgregado]) VALUES (4, 5, 2, CAST(N'2026-10-27T18:23:23.300' AS DateTime))
INSERT [dbo].[Favoritos] ([Id], [UsuarioId], [ProductoId], [FechaAgregado]) VALUES (5, 5, 2, CAST(N'2026-10-27T18:23:23.310' AS DateTime))
INSERT [dbo].[Favoritos] ([Id], [UsuarioId], [ProductoId], [FechaAgregado]) VALUES (6, 5, 29, CAST(N'2026-10-27T18:23:48.560' AS DateTime))
INSERT [dbo].[Favoritos] ([Id], [UsuarioId], [ProductoId], [FechaAgregado]) VALUES (7, 5, 5, CAST(N'2026-10-27T18:24:04.303' AS DateTime))
INSERT [dbo].[Favoritos] ([Id], [UsuarioId], [ProductoId], [FechaAgregado]) VALUES (8, 4, 5, CAST(N'2026-10-27T19:41:45.813' AS DateTime))
INSERT [dbo].[Favoritos] ([Id], [UsuarioId], [ProductoId], [FechaAgregado]) VALUES (9, 4, 4, CAST(N'2026-10-27T19:41:47.537' AS DateTime))
INSERT [dbo].[Favoritos] ([Id], [UsuarioId], [ProductoId], [FechaAgregado]) VALUES (10, 4, 21, CAST(N'2026-10-27T19:41:57.000' AS DateTime))
INSERT [dbo].[Favoritos] ([Id], [UsuarioId], [ProductoId], [FechaAgregado]) VALUES (11, 4, 42, CAST(N'2026-10-27T19:42:06.670' AS DateTime))
INSERT [dbo].[Favoritos] ([Id], [UsuarioId], [ProductoId], [FechaAgregado]) VALUES (12, 4, 2, CAST(N'2026-10-28T00:30:27.953' AS DateTime))
INSERT [dbo].[Favoritos] ([Id], [UsuarioId], [ProductoId], [FechaAgregado]) VALUES (13, 4, 3, CAST(N'2026-10-28T00:30:29.683' AS DateTime))
INSERT [dbo].[Favoritos] ([Id], [UsuarioId], [ProductoId], [FechaAgregado]) VALUES (14, 4, 52, CAST(N'2026-10-28T00:30:42.550' AS DateTime))
INSERT [dbo].[Favoritos] ([Id], [UsuarioId], [ProductoId], [FechaAgregado]) VALUES (15, 4, 17, CAST(N'2026-10-28T02:19:25.673' AS DateTime))
INSERT [dbo].[Favoritos] ([Id], [UsuarioId], [ProductoId], [FechaAgregado]) VALUES (18, 4, 50, CAST(N'2026-10-28T11:18:58.027' AS DateTime))
INSERT [dbo].[Favoritos] ([Id], [UsuarioId], [ProductoId], [FechaAgregado]) VALUES (19, 4, 45, CAST(N'2026-10-29T01:37:56.737' AS DateTime))
SET IDENTITY_INSERT [dbo].[Favoritos] OFF

GO
SET IDENTITY_INSERT [dbo].[Productos] ON 

INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (1, N'Sony a6700', N'El buque insignia APS-C. Incluye procesador de IA avanzada y video 4K 120p.', CAST(25000.00 AS Decimal(18, 2)), 6, N'/images/SONY_A6700.jpg', 1)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (2, N'Sony a6400', N'Excelente relación calidad-precio para iniciar. Enfoque rapidísimo y pantalla abatible.', CAST(15000.00 AS Decimal(18, 2)), 1, N'/images/SONY_A6400.jpg', 1)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (3, N'Sony ZV-E1', N'Máxima calidad para vloggers. Sensor de poca luz de la a7S III e IA automatizada.', CAST(42000.00 AS Decimal(18, 2)), 1, N'/images/SONY_ZV-E1.jpg', 1)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (4, N'Sony ZV-E10 II', N'La reina calidad-precio para creadores en YouTube y redes sociales.', CAST(18000.00 AS Decimal(18, 2)), 18, N'/images/SONY_ZV-E10_II.jpg', 1)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (5, N'Sony a7 IV', N'Con 33 MP, es el estándar de la industria para bodas, retratos y eventos.', CAST(40000.00 AS Decimal(18, 2)), 11, N'/images/SONY_A7_IV.jpg', 1)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (6, N'Sony a7 III', N'Sigue siendo una superventas por su gran relación calidad-precio en Full-Frame.', CAST(30000.00 AS Decimal(18, 2)), 18, N'/images/SONY_A7_III.jpg', 1)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (7, N'Sony a7R V', N'Sensor monstruoso de 61 MP, estabilización líder de 8 pasos y enfoque por IA.', CAST(78500.00 AS Decimal(18, 2)), 4, N'/images/SONY_A7R_V.jpg', 1)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (8, N'Sony a7R IV', N'Sensor de 61 MP con sistema de enfoque de generación anterior.', CAST(55000.00 AS Decimal(18, 2)), 6, N'/images/SONY_A7R_IV.jpg', 1)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (9, N'Sony a7S III', N'Sensor de 12 MP con píxeles gigantes, diseñada para grabar literalmente en la oscuridad.', CAST(70000.00 AS Decimal(18, 2)), 5, N'/images/SONY_A7S_III.jpg', 1)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (10, N'Sony a7C II', N'Todo el poder y enfoque de la a7 IV pero en un tamaño miniatura ideal para viajar.', CAST(42000.00 AS Decimal(18, 2)), 8, N'/images/SONY_A7C_II.jpg', 1)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (11, N'Sony a7CR', N'Incorpora el sensor de 61 MP en el cuerpo ultra compacto de la serie C.', CAST(60000.00 AS Decimal(18, 2)), 4, N'/images/SONY_A7CR.jpg', 1)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (12, N'Sony a9 III', N'Primera cámara Full-Frame del mundo con sensor Global Shutter y ráfagas de 120 fps.', CAST(125000.00 AS Decimal(18, 2)), 2, N'/images/SONY_A9_III.jpg', 1)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (13, N'Sony Alpha 1 / A1', N'La cámara sin concesiones. Combina 50 MP, grabación de video 8K y ráfagas de 30 fps.', CAST(120000.00 AS Decimal(18, 2)), 1, N'/images/SONY_A1.jpg', 1)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (14, N'Sony FX3', N'Aprobada por Netflix, chasis con monturas integradas y ventilación activa para cine.', CAST(85000.00 AS Decimal(18, 2)), 2, N'/images/SONY_FX3.jpg', 1)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (15, N'Sony FX30', N'Todo el diseño y operatividad de cine profesional a un costo accesible en APS-C.', CAST(38000.00 AS Decimal(18, 2)), 7, N'/images/SONY_FX30.jpg', 1)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (16, N'Tamron 28-75mm f/2.8 Di III VXD G2', N'Gran calidad óptica de terceros a una fracción del precio.', CAST(18000.00 AS Decimal(18, 2)), 15, N'/images/TAMRON_28-75MM_F2.8_DI_III_VXD_G2.jpg', 2)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (17, N'Sigma 28-70mm f/2.8', N'Excelente calidad óptica de terceros, compacto y luminoso.', CAST(17000.00 AS Decimal(18, 2)), 11, N'/images/SIGMA_28-70MM_F2.8.jpg', 2)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (18, N'Sony FE 24-105mm f/4 G OSS', N'Mayor alcance con estabilización, excelente para viajes y video.', CAST(22000.00 AS Decimal(18, 2)), 10, N'/images/SONY_FE_24-105MM_F4_G_OSS.jpg', 2)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (19, N'Sony FE 24-70mm f/2.8 GM II', N'La mejor calidad y nitidez posible sin compromisos.', CAST(41000.00 AS Decimal(18, 2)), 6, N'/images/SONY_FE_24-70MM_F2.8_GM_II.jpg', 2)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (20, N'Sony FE 50mm f/1.8', N'El clásico Nifty Fifty, económico y muy luminoso.', CAST(5000.00 AS Decimal(18, 2)), 23, N'/images/SONY_FE_50MM_F1.8.jpg', 3)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (21, N'Sony FE 35mm f/1.8', N'Nitidez superior y construcción robusta en focal estándar.', CAST(14000.00 AS Decimal(18, 2)), 14, N'/images/SONY_FE_35MM_F1.8.jpg', 3)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (22, N'Sigma 50mm f/1.4 Art', N'Nitidez óptica espectacular de la serie Art.', CAST(18000.00 AS Decimal(18, 2)), 8, N'/images/SIGMA_50MM_F1.4_ART.jpg', 3)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (23, N'Sony FE 50mm f/1.2 GM', N'El mejor bokeh y rendimiento profesional de Sony.', CAST(45000.00 AS Decimal(18, 2)), 4, N'/images/SONY_FE_50MM_F1.2_GM.jpg', 3)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (24, N'Sony FE 35mm f/1.4 GM', N'Calidad profesional G Master para fotografía callejera y bodas.', CAST(35000.00 AS Decimal(18, 2)), 5, N'/images/SONY_FE_35MM_F1.4_GM.jpg', 3)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (25, N'Viltrox 85mm f/1.8 AF', N'Excelente alternativa económica para retratos con gran desenfoque.', CAST(6500.00 AS Decimal(18, 2)), 12, N'/images/VILTROX_85MM_F1.8_AF.jpg', 3)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (26, N'Sony FE 85mm f/1.8', N'El estándar de oro para retratos sin gastar en la serie GM.', CAST(11000.00 AS Decimal(18, 2)), 10, N'/images/SONY_FE_85MM_F1.8.jpg', 3)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (27, N'Sigma 85mm f/1.4 DG DN Art', N'Resolución masiva y gran desenfoque para retrato.', CAST(20000.00 AS Decimal(18, 2)), 6, N'/images/SIGMA_85MM_F1.4_DG_DN_ART.jpg', 3)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (28, N'Sony FE 135mm f/1.8 GM', N'La máxima compresión y nitidez clínica para retratos de medio cuerpo.', CAST(42000.00 AS Decimal(18, 2)), 3, N'/images/SONY_FE_135MM_F1.8_GM .jpg', 3)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (29, N'Tamron 70-300mm f/4.5-6.3', N'Súper ligero y accesible para principiantes en fauna o deportes.', CAST(10000.00 AS Decimal(18, 2)), 14, N'/images/TAMRON_70-300MM_F4.5-6.3.jpg', 4)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (30, N'Tamron 70-180mm f/2.8 Di III VXD', N'Apertura rápida y tamaño compacto, excelente alternativa a los GM.', CAST(22000.00 AS Decimal(18, 2)), 8, N'/images/TAMRON_70-180MM_F2.8_DI_III_VXD.jpg', 4)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (31, N'Sony FE 70-200mm f/2.8 GM OSS II', N'Velocidad de enfoque inigualable y ligereza extrema.', CAST(51600.00 AS Decimal(18, 2)), 5, N'/images/SONY_FE_70-200MM_F2.8_GM_OSS_II.jpg', 4)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (32, N'Sigma 100-400mm f/5-6.3 DG DN OS', N'Un teleobjetivo ligero y asequible para deportes y fauna.', CAST(18000.00 AS Decimal(18, 2)), 6, N'/images/SIGMA_100-400MM_F5-6.3_DG_DN_OS.jpg', 4)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (33, N'Sony FE 70-200mm f/4 Macro G OSS II', N'Ligero y con capacidades macro 1:2 reales.', CAST(32000.00 AS Decimal(18, 2)), 6, N'/images/SONY_FE_70-200MM_F4_MACRO_G_OSS_II .jpg', 4)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (34, N'Sony FE 200-600mm f/5.6-6.3 G OSS', N'El rey indiscutible para fotografía de aves y vida silvestre.', CAST(40000.00 AS Decimal(18, 2)), 3, N'/images/SONY_FE_200-600MM_F5.6-6.3_G_OSS.jpg', 4)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (35, N'Tamron 17-28mm f/2.8 Di III RXD', N'Muy nítido y perfecto para vlogs o paisajes.', CAST(17000.00 AS Decimal(18, 2)), 10, N'/images/TAMRON_17-28MM_F2.8_DI_III_RXD.jpg', 5)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (36, N'Sony FE 16-35mm f/4 PZ G', N'Enfoque y zoom motorizado ideal para video.', CAST(24000.00 AS Decimal(18, 2)), 7, N'/images/SONY_FE_16-35MM_F4_PZ_G.jpg', 5)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (37, N'Sony FE 16-35mm f/2.8 GM II', N'La joya de la corona para paisajes, interiores y arquitectura.', CAST(48000.00 AS Decimal(18, 2)), 5, N'/images/SONY_FE_16-35MM_F2.8_GM_II.jpg', 5)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (38, N'Viltrox 16mm f/1.8', N'Una joya luminosa para astrofotografía a bajo costo.', CAST(10000.00 AS Decimal(18, 2)), 12, N'/images/VILTROX_16MM_F1.8.jpg', 5)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (39, N'Sigma 14-24mm f/2.8 DG DN Art', N'Calidad óptica soberbia para arquitectura y paisajes.', CAST(26000.00 AS Decimal(18, 2)), 6, N'/images/SIGMA_14-24MM_F2.8_DG_DN_ART.jpg', 5)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (40, N'Sony FE 14mm f/1.8 GM', N'Lente ultra angular fijo, absurdamente ligero y perfecto para la Vía Láctea.', CAST(32000.00 AS Decimal(18, 2)), 4, N'/images/SONY_FE_14MM_F1.8_GM.jpg', 5)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (41, N'Godox TT685II-S', N'Un flash de zapata versátil, TTL y económico.', CAST(2500.00 AS Decimal(18, 2)), 30, N'/images/GODOX_TT685II-S.jpg', 6)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (42, N'Godox V1-S', N'Cabezal redondo para una luz natural y batería de litio de larga duración.', CAST(5500.00 AS Decimal(18, 2)), 20, N'/images/GODOX_V1-S.jpg', 6)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (43, N'Sony HVL-F60RM2', N'Control de radio inalámbrico avanzado y reciclaje rápido.', CAST(11000.00 AS Decimal(18, 2)), 8, N'/images/SONY_HVL-F60RM2.jpg', 6)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (44, N'Profoto A10', N'Robustez y confiabilidad sueca en un flash de zapata.', CAST(22000.00 AS Decimal(18, 2)), 4, N'/images/PROFOTO_A10.jpg', 6)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (45, N'Godox AD200Pro', N'El tamaño de un flash de zapata grande pero con 3 veces más potencia.', CAST(6500.00 AS Decimal(18, 2)), 15, N'/images/GODOX_AD200PRO.jpg', 6)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (46, N'Godox AD600Pro', N'Flashes de estudio a batería para superar la luz del sol en exteriores.', CAST(15000.00 AS Decimal(18, 2)), 6, N'/images/GODOX_AD600PRO.jpg', 6)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (47, N'Profoto B10', N'Iluminación de estudio premium y ultracompacta a batería.', CAST(35000.00 AS Decimal(18, 2)), 3, N'/images/PROFOTO_B10.jpg', 6)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (48, N'K&F Concept Aluminio', N'Excelente relación calidad-precio para uso esporádico.', CAST(2500.00 AS Decimal(18, 2)), 20, N'/images/K&F_CONCEPT_ALUMINIO.jpg', 7)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (49, N'Manfrotto Befree Advanced', N'Un clásico robusto y portátil para viajes.', CAST(6000.00 AS Decimal(18, 2)), 15, N'/images/MANFROTTO_BEFREE_ADVANCED.jpg', 7)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (50, N'Peak Design Travel Tripod', N'Máxima portabilidad, fibra de carbono, diseño inteligente.', CAST(18000.00 AS Decimal(18, 2)), 8, N'/images/PEAK_DESIGN_TRAVEL_TRIPOD.jpg', 7)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (51, N'Gitzo Traveler', N'Fibra de carbono de la más alta calidad y estabilidad.', CAST(18000.00 AS Decimal(18, 2)), 5, N'/images/GITZO_TRAVELER.jpg', 7)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (52, N'Kingston Canvas Go! Plus SDXC', N'Ideal para fotos y video 4K básico.', CAST(800.00 AS Decimal(18, 2)), 50, N'/images/KINGSTON_CANVAS_GO_PLUS_SDXC.jpg', 8)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (53, N'SanDisk Extreme Pro SDXC', N'Para ráfagas rápidas y video de alto bitrate.', CAST(4000.00 AS Decimal(18, 2)), 29, N'/images/SANDISK_EXTREME_PRO_SDXC.jpg', 8)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (54, N'Sony TOUGH-M SDXC', N'Resistencia extrema y velocidad garantizada.', CAST(4000.00 AS Decimal(18, 2)), 25, N'/images/SONY_TOUGH-M_SDXC.jpg', 8)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (55, N'Sony CFexpress Type A TOUGH', N'Necesaria para desbloquear las velocidades máximas y el 8K.', CAST(10000.00 AS Decimal(18, 2)), 15, N'/images/SONY_CFEXPRESS_TYPE_A_TOUGH.jpg', 8)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (56, N'Mochila K&F Concept', N'Mochila cómoda con acceso lateral y buen acolchado.', CAST(2500.00 AS Decimal(18, 2)), 18, N'/images/MOCHILA_K&F_CONCEPT.jpg', 9)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (57, N'Mochila Tarion', N'Diseño versátil y asequible para equipo ligero.', CAST(2500.00 AS Decimal(18, 2)), 18, N'/images/MOCHILA_TARION.jpg', 9)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (58, N'Lowepro ProTactic BP 450 AW II', N'La mochila blindada por excelencia para fotoperiodistas.', CAST(5500.00 AS Decimal(18, 2)), 12, N'/images/LOWEPRO_PROTACTIC_BP_450_AW_II.jpg', 9)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (59, N'Peak Design Everyday Backpack', N'Diseño urbano elegante, divisores origami y materiales premium.', CAST(8000.00 AS Decimal(18, 2)), 10, N'/images/PEAK_DESIGN_EVERYDAY_BACKPACK.jpg', 9)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (60, N'PGYTECH OneMo 2', N'Gran capacidad modular para fotógrafos híbridos y drones.', CAST(8000.00 AS Decimal(18, 2)), 8, N'/images/PGYTECH_ONEMO_2.jpg', 9)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (61, N'K&F Concept Variable ND', N'Filtro de densidad neutra variable para entrada.', CAST(1200.00 AS Decimal(18, 2)), 30, N'/images/K&F_CONCEPT_VARIABLE_ND.jpg', 10)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (62, N'Filtro Polarizador Hoya', N'Elimina reflejos y aumenta el contraste en exteriores.', CAST(2500.00 AS Decimal(18, 2)), 25, N'/images/FILTRO_POLARIZADOR_HOYA.jpg', 10)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (63, N'Filtro Tiffen', N'Calidad de cristal clásica para efectos precisos.', CAST(2500.00 AS Decimal(18, 2)), 20, N'/images/FILTRO_TIFFEN.jpg', 10)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (64, N'PolarPro Peter McKinnon Edition', N'ND Variable de alta gama que no degrada la imagen ni altera colores.', CAST(6000.00 AS Decimal(18, 2)), 10, N'/images/POLARPRO_PETER_MCKINNON_EDITION.jpg', 10)
INSERT [dbo].[Productos] ([Id], [Nombre], [Descripcion], [Precio], [Stock], [ImagenUrl], [CategoriaId]) VALUES (65, N'Filtro B+W', N'Construcción alemana de latón con óptica impecable.', CAST(6000.00 AS Decimal(18, 2)), 8, N'/images/FILTRO_B+W.jpg', 10)
SET IDENTITY_INSERT [dbo].[Productos] OFF
GO
SET IDENTITY_INSERT [dbo].[Recompensas] ON 

INSERT [dbo].[Recompensas] ([Id], [MontoMinimo], [DescuentoPorcentaje], [ProductoRegalo]) VALUES (1, CAST(50000.00 AS Decimal(18, 2)), CAST(5.00 AS Decimal(5, 2)), N'Filtro UV Premium')
INSERT [dbo].[Recompensas] ([Id], [MontoMinimo], [DescuentoPorcentaje], [ProductoRegalo]) VALUES (2, CAST(100000.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(5, 2)), N'Mochila de Transporte Profesional')
SET IDENTITY_INSERT [dbo].[Recompensas] OFF
GO
SET IDENTITY_INSERT [dbo].[Usuarios] ON 

INSERT [dbo].[Usuarios] ([Id], [Email], [PasswordHash], [Rol], [FechaRegistro], [Nombre], [TelegramChatId], [FotoPerfilUrl]) VALUES (1, N'cliente@vintagelens.com', N'1234', N'Cliente', CAST(N'2026-10-22T19:07:30.663' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[Usuarios] ([Id], [Email], [PasswordHash], [Rol], [FechaRegistro], [Nombre], [TelegramChatId], [FotoPerfilUrl]) VALUES (4, N'unico2726@gmail.com', N'12345678f', N'Cliente', CAST(N'2026-10-26T16:52:55.903' AS DateTime), N'Fernando Rodriguez', N'2076807151', N'/images/perfiles/fd521499-c180-4dfc-bb4b-857491849f8b.jpg')
INSERT [dbo].[Usuarios] ([Id], [Email], [PasswordHash], [Rol], [FechaRegistro], [Nombre], [TelegramChatId], [FotoPerfilUrl]) VALUES (5, N'irvingperez94986@gmail.com', N'Nova2811', N'Cliente', CAST(N'2026-10-27T23:04:42.280' AS DateTime), N'Irving Ramiro', N'8786198321', N'/images/default-avatar.png')
SET IDENTITY_INSERT [dbo].[Usuarios] OFF
GO
SET ANSI_PADDING ON
GO
/****** Objeto: Index [UQ__Pedidos__BAB84EF7907D5F92] Fecha de script: 30/10/2026 10:28:07 p. m. ******/
ALTER TABLE [dbo].[Pedidos] ADD UNIQUE NONCLUSTERED 
(
	[Folio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Favoritos] ADD  DEFAULT (getdate()) FOR [FechaAgregado]
GO
ALTER TABLE [dbo].[Pedidos] ADD  DEFAULT (getutcdate()) FOR [Fecha]
GO
ALTER TABLE [dbo].[Productos] ADD  DEFAULT ((0)) FOR [Stock]
GO
ALTER TABLE [dbo].[Resenas] ADD  DEFAULT ((1)) FOR [Verificada]
GO
ALTER TABLE [dbo].[Resenas] ADD  DEFAULT (getutcdate()) FOR [Fecha]
GO
ALTER TABLE [dbo].[Usuarios] ADD  DEFAULT ('Cliente') FOR [Rol]
GO
ALTER TABLE [dbo].[Usuarios] ADD  DEFAULT (getutcdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[Usuarios] ADD  DEFAULT ('/images/default-avatar.png') FOR [FotoPerfilUrl]
GO
ALTER TABLE [dbo].[CarritoItems]  WITH CHECK ADD  CONSTRAINT [FK_CarritoItems_Productos] FOREIGN KEY([ProductoId])
REFERENCES [dbo].[Productos] ([Id])
GO
ALTER TABLE [dbo].[CarritoItems] CHECK CONSTRAINT [FK_CarritoItems_Productos]
GO
ALTER TABLE [dbo].[CarritoItems]  WITH CHECK ADD  CONSTRAINT [FK_CarritoItems_Usuarios] FOREIGN KEY([UsuarioId])
REFERENCES [dbo].[Usuarios] ([Id])
GO
ALTER TABLE [dbo].[CarritoItems] CHECK CONSTRAINT [FK_CarritoItems_Usuarios]
GO
ALTER TABLE [dbo].[DetallePedidos]  WITH CHECK ADD  CONSTRAINT [FK_DetallePedidos_Pedidos] FOREIGN KEY([PedidoId])
REFERENCES [dbo].[Pedidos] ([Id])
GO
ALTER TABLE [dbo].[DetallePedidos] CHECK CONSTRAINT [FK_DetallePedidos_Pedidos]
GO
ALTER TABLE [dbo].[DetallePedidos]  WITH CHECK ADD  CONSTRAINT [FK_DetallePedidos_Productos] FOREIGN KEY([ProductoId])
REFERENCES [dbo].[Productos] ([Id])
GO
ALTER TABLE [dbo].[DetallePedidos] CHECK CONSTRAINT [FK_DetallePedidos_Productos]
GO
ALTER TABLE [dbo].[Direcciones]  WITH CHECK ADD FOREIGN KEY([UsuarioId])
REFERENCES [dbo].[Usuarios] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Favoritos]  WITH CHECK ADD FOREIGN KEY([ProductoId])
REFERENCES [dbo].[Productos] ([Id])
GO
ALTER TABLE [dbo].[Favoritos]  WITH CHECK ADD FOREIGN KEY([UsuarioId])
REFERENCES [dbo].[Usuarios] ([Id])
GO
ALTER TABLE [dbo].[Pedidos]  WITH CHECK ADD  CONSTRAINT [FK_Pedidos_Usuarios] FOREIGN KEY([UsuarioId])
REFERENCES [dbo].[Usuarios] ([Id])
GO
ALTER TABLE [dbo].[Pedidos] CHECK CONSTRAINT [FK_Pedidos_Usuarios]
GO
ALTER TABLE [dbo].[Productos]  WITH CHECK ADD  CONSTRAINT [FK_Productos_Categorias] FOREIGN KEY([CategoriaId])
REFERENCES [dbo].[Categorias] ([Id])
GO
ALTER TABLE [dbo].[Productos] CHECK CONSTRAINT [FK_Productos_Categorias]
GO
ALTER TABLE [dbo].[Resenas]  WITH CHECK ADD  CONSTRAINT [FK_Resenas_Productos] FOREIGN KEY([ProductoId])
REFERENCES [dbo].[Productos] ([Id])
GO
ALTER TABLE [dbo].[Resenas] CHECK CONSTRAINT [FK_Resenas_Productos]
GO
ALTER TABLE [dbo].[Resenas]  WITH CHECK ADD  CONSTRAINT [FK_Resenas_Usuarios] FOREIGN KEY([UsuarioId])
REFERENCES [dbo].[Usuarios] ([Id])
GO
ALTER TABLE [dbo].[Resenas] CHECK CONSTRAINT [FK_Resenas_Usuarios]
GO
ALTER TABLE [dbo].[Resenas]  WITH CHECK ADD CHECK  (([Calificacion]>=(1) AND [Calificacion]<=(5)))
GO
