use Dinamo;
go

create or alter trigger correo_bienvenida
on [dbo].[usuarios] for  update 
as 
begin 
	
	/* Variables locales */
	declare @correoViejo nvarchar(500);
	declare @correoNuevo nvarchar(500);
	declare @htmlCorreo nvarchar(MAX);
	declare @nombreUsuario nvarchar(250);

	/* SI se actualiza el correo del usuario */
	if update([usuario_correo])

		begin 
			
			/* Verificar que el campo nuevo no sea null */
			select @correoViejo = deleted.usuario_correo, @nombreUsuario = inserted.usuario_nombre_real,  @correoNuevo = inserted.usuario_correo 
			from deleted inner join inserted 
			on deleted.usuario_id = inserted.usuario_id;

			/* Si el correo nuevo NO ES NULO y el correo viejo ES NULO, se envia correo de bienvenida */
			if @correoNuevo is not null and @correoViejo is null
				
				/* Buscar estrcutra de correo */
				select @htmlCorreo = [plantilla_correo_contenido] from [dbo].[plantillas_correos] where [plantilla_correo_id] = 1;
				set @htmlCorreo = replace(@htmlCorreo, '[NOMBRE_REAL_USUARIO]', @nombreUsuario);

				exec [dbo].[usp_enviar_correos]
					@perfilCorreo = 'PerfilOutlook', 
					@cuerpoCorreo = @htmlCorreo, 
					@destinatarios = @correoNuevo, 
					@tituloCorrreo = 'Correo De Bienvenida',
					@rutaArchivos = null
			
		end
end