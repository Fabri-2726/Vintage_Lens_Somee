SET IDENTITY_INSERT [dbo].[Recompensas] ON 

INSERT [dbo].[Recompensas] ([Id], [MontoMinimo], [DescuentoPorcentaje], [ProductoRegalo]) VALUES (1, CAST(50000.00 AS Decimal(18, 2)), CAST(5.00 AS Decimal(5, 2)), N'Filtro UV Premium')
INSERT [dbo].[Recompensas] ([Id], [MontoMinimo], [DescuentoPorcentaje], [ProductoRegalo]) VALUES (2, CAST(100000.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(5, 2)), N'Mochila de Transporte Profesional')
SET IDENTITY_INSERT [dbo].[Recompensas] OFF
