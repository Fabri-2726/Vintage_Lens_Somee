ALTER TABLE [dbo].[Pedidos] ADD UNIQUE NONCLUSTERED 
(
	[Folio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
ALTER TABLE [dbo].[Favoritos] ADD  DEFAULT (getdate()) FOR [FechaAgregado]
ALTER TABLE [dbo].[Pedidos] ADD  DEFAULT (getutcdate()) FOR [Fecha]
ALTER TABLE [dbo].[Productos] ADD  DEFAULT ((0)) FOR [Stock]
ALTER TABLE [dbo].[Resenas] ADD  DEFAULT ((1)) FOR [Verificada]
ALTER TABLE [dbo].[Resenas] ADD  DEFAULT (getutcdate()) FOR [Fecha]
ALTER TABLE [dbo].[Usuarios] ADD  DEFAULT ('Cliente') FOR [Rol]
ALTER TABLE [dbo].[Usuarios] ADD  DEFAULT (getutcdate()) FOR [FechaRegistro]
ALTER TABLE [dbo].[Usuarios] ADD  DEFAULT ('/images/default-avatar.png') FOR [FotoPerfilUrl]
ALTER TABLE [dbo].[CarritoItems]  WITH CHECK ADD  CONSTRAINT [FK_CarritoItems_Productos] FOREIGN KEY([ProductoId])
REFERENCES [dbo].[Productos] ([Id])
ALTER TABLE [dbo].[CarritoItems] CHECK CONSTRAINT [FK_CarritoItems_Productos]
ALTER TABLE [dbo].[CarritoItems]  WITH CHECK ADD  CONSTRAINT [FK_CarritoItems_Usuarios] FOREIGN KEY([UsuarioId])
REFERENCES [dbo].[Usuarios] ([Id])
ALTER TABLE [dbo].[CarritoItems] CHECK CONSTRAINT [FK_CarritoItems_Usuarios]
ALTER TABLE [dbo].[DetallePedidos]  WITH CHECK ADD  CONSTRAINT [FK_DetallePedidos_Pedidos] FOREIGN KEY([PedidoId])
REFERENCES [dbo].[Pedidos] ([Id])
ALTER TABLE [dbo].[DetallePedidos] CHECK CONSTRAINT [FK_DetallePedidos_Pedidos]
ALTER TABLE [dbo].[DetallePedidos]  WITH CHECK ADD  CONSTRAINT [FK_DetallePedidos_Productos] FOREIGN KEY([ProductoId])
REFERENCES [dbo].[Productos] ([Id])
ALTER TABLE [dbo].[DetallePedidos] CHECK CONSTRAINT [FK_DetallePedidos_Productos]
ALTER TABLE [dbo].[Direcciones]  WITH CHECK ADD FOREIGN KEY([UsuarioId])
REFERENCES [dbo].[Usuarios] ([Id])
ON DELETE CASCADE
ALTER TABLE [dbo].[Favoritos]  WITH CHECK ADD FOREIGN KEY([ProductoId])
REFERENCES [dbo].[Productos] ([Id])
ALTER TABLE [dbo].[Favoritos]  WITH CHECK ADD FOREIGN KEY([UsuarioId])
REFERENCES [dbo].[Usuarios] ([Id])
ALTER TABLE [dbo].[Pedidos]  WITH CHECK ADD  CONSTRAINT [FK_Pedidos_Usuarios] FOREIGN KEY([UsuarioId])
REFERENCES [dbo].[Usuarios] ([Id])
ALTER TABLE [dbo].[Pedidos] CHECK CONSTRAINT [FK_Pedidos_Usuarios]
ALTER TABLE [dbo].[Productos]  WITH CHECK ADD  CONSTRAINT [FK_Productos_Categorias] FOREIGN KEY([CategoriaId])
REFERENCES [dbo].[Categorias] ([Id])
ALTER TABLE [dbo].[Productos] CHECK CONSTRAINT [FK_Productos_Categorias]
ALTER TABLE [dbo].[Resenas]  WITH CHECK ADD  CONSTRAINT [FK_Resenas_Productos] FOREIGN KEY([ProductoId])
REFERENCES [dbo].[Productos] ([Id])
ALTER TABLE [dbo].[Resenas] CHECK CONSTRAINT [FK_Resenas_Productos]
ALTER TABLE [dbo].[Resenas]  WITH CHECK ADD  CONSTRAINT [FK_Resenas_Usuarios] FOREIGN KEY([UsuarioId])
REFERENCES [dbo].[Usuarios] ([Id])
ALTER TABLE [dbo].[Resenas] CHECK CONSTRAINT [FK_Resenas_Usuarios]
ALTER TABLE [dbo].[Resenas]  WITH CHECK ADD CHECK  (([Calificacion]>=(1) AND [Calificacion]<=(5)))
