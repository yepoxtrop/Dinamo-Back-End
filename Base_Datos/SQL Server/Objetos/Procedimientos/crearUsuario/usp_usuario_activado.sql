/*========================================================================================================================
FECHA CREACION: 2026/05/19
AUTOR         : LUIS ANGEL SARMIENTO DIAZ
DETALLE       : Procedimiento que crea usuario usuario base al crear un nuevo usuario de forma manual en el Dinamo.
========================================================================================================================*/

/* Usar la base de datos */
use Dinamo_Firmas_Digitales;
go

create or alter procedure usp_activar_usuario
	@correoElectronico nvarchar(500),
	@tokenSesion nvarchar(MAX),
	@dispositivo nvarchar(MAX),
	@ipDispositivo nvarchar(45)
as
begin
	/* Variables */
	declare @correo nvarchar(MAX);
	declare @idUsuario int;
	declare @nombreUsuario nvarchar(50);
	declare @tokenAuth nvarchar(6);
	begin try

		begin tran

			/* Id del usuario */
			select @idUsuario = [usuario_id], 
				@nombreUsuario = [usuario_nombre],
				@tokenAuth = [usuario_token_creacion] 
			from [dbo].[usuarios] where [usuario_email] = @correoElectronico;

			if @idUsuario is null
				throw 50003, '[ERROR]: Usuario no encontrado, no envia nada', 1; 

			/* Actualizar datos */
			update [dbo].[usuarios]
			set [usuario_estado] = 1,
			[usuario_token_creacion] = null
			where [usuario_id] = @idUsuario and [usuario_email] = @correoElectronico;

			/* Consultar correo */
			select @correo = [plantilla_correo_contenido] from [dbo].[plantillas_correos] where [plantilla_correo_nombre] = 'correo de bienvenida';
			set @correo = REPLACE(@correo, '[NOMBRE_REAL_USUARIO]', @nombreUsuario);
			
			/* Insertar sesion */
			insert into [dbo].[sesiones](
				[sesion_fecha],
				[sesion_dispositivo],
				[sesion_ip],
				[sesion_autenticacion_token],
				[sesion_token],
				[usuario_id_fk]
			) values(
				GETDATE(),
				@dispositivo,
				@ipDispositivo,
				@tokenAuth,
				@tokenSesion,
				@idUsuario
			)

			/* Enviar correo electronico de bienvenida */
			exec [dbo].[usp_enviar_correos] 
				@perfilCorreo='CorreosDinamo',
				@cuerpoCorreo=@correo, 
				@destinatarios=@correoElectronico, 
				@tituloCorrreo='Bienvenido a Dianmo',
				@rutaArchivos=null

			/* Alamcenar el correo enviado */
			insert into [dbo].[correos_enviados](
				[correo_enviado_fecha],
				[correo_enviado_cuerpo],
				[tipo_correo_id_fk],
				[usuario_id_fk],
				[plantilla_correo_id_fk]
			) values(
				GETDATE(),
				@correo,
				1, /* Id de creación de cuenta */
				@idUsuario,
				4 /* Id de la plantilla de creación de cuenta  */
			)

			/* Almacenar log */
			--insert into [dbo].[logs](
			--	[log_titulo],

			--)

		commit tran;
	end try
	begin catch
		rollback tran; 

		declare @numeroError int = ERROR_NUMBER();
		declare @mensajeError nvarchar(4000) = ERROR_MESSAGE();

		if @numeroError in (2601, 2627)
			throw 50002, '[Error]: Problemas para insertar la sesion', 1;
		if @numeroError = 50001
			throw 50001, '[Error]: No se pudo enviar el correo', 1;
		if @numeroError in (100, 208)
			throw 50004, '[Error]: Sintaxis mal escrita', 1;
		if @numeroError in (248, 547)
			throw 50005, '[Error]: Violacion a las restricciones de datos', 1;
		else
			throw @numeroError, @mensajeError, 1;
	end catch
end

-- select *from usuarios;
-- select *from sesiones;
-- select *from correos_enviados;
-- delete from  correos_enviados where correo_enviado_id = 5 ;
-- delete from usuarios where usuario_id = 1;