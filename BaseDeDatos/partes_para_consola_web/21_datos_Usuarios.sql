SET IDENTITY_INSERT [dbo].[Usuarios] ON 

INSERT [dbo].[Usuarios] ([Id], [Email], [PasswordHash], [Rol], [FechaRegistro], [Nombre], [TelegramChatId], [FotoPerfilUrl]) VALUES (1, N'cliente@vintagelens.com', N'1234', N'Cliente', CAST(N'2026-10-22T19:07:30.663' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[Usuarios] ([Id], [Email], [PasswordHash], [Rol], [FechaRegistro], [Nombre], [TelegramChatId], [FotoPerfilUrl]) VALUES (4, N'unico2726@gmail.com', N'12345678f', N'Cliente', CAST(N'2026-10-26T16:52:55.903' AS DateTime), N'Fernando Rodriguez', N'2076807151', N'/images/perfiles/fd521499-c180-4dfc-bb4b-857491849f8b.jpg')
INSERT [dbo].[Usuarios] ([Id], [Email], [PasswordHash], [Rol], [FechaRegistro], [Nombre], [TelegramChatId], [FotoPerfilUrl]) VALUES (5, N'irvingperez94986@gmail.com', N'Nova2811', N'Cliente', CAST(N'2026-10-27T23:04:42.280' AS DateTime), N'Irving Ramiro', N'8786198321', N'/images/default-avatar.png')
SET IDENTITY_INSERT [dbo].[Usuarios] OFF
