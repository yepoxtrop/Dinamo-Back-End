/*========================================================================================================================
FECHA CREACION: 2026/05/19
AUTOR         : LUIS ANGEL SARMIENTO DIAZ
DETALLE       : Procedimiento que crea usuario usuario base al crear un nuevo usuario de forma manual en el Dinamo.
========================================================================================================================*/

/* Usar la base de datos */
use Dinamo;
go

create or alter procedure usp_crear_usuario_base
	@nombreUsuario nvarchar(50),
	@correoElectronico nvarchar(500),
	@contrasena nvarchar(MAX),
	@codigoAutenticacion nvarchar(6),
	@pais nvarchar(100),
	@fecha datetime2
as
begin
	/* Variables */
	declare @correo nvarchar(MAX);
	declare @idUsuario int;
	begin try

		begin tran

			/* Insertar usuario si no existe */
			insert into [dbo].[usuarios](
				[usuario_nombre], 
				[usuario_email], 
				[usuario_contrasena], 
				[usuario_pais],
				[usuario_habilitado], 
				[usuario_estado],
				[usuario_token_creacion],
				[medio_creacion_id_fk]
			) values
			(@nombreUsuario, @correoElectronico, @contrasena, @pais, 1, 0, @codigoAutenticacion, 1);

			/* Consultar correo */
			select @correo = [plantilla_correo_contenido] from [dbo].[plantillas_correos] where [plantilla_correo_nombre] = 'correo de autenticacion';
			set @correo = REPLACE(@correo, '[TOKEN_6_DIGITOS]', @codigoAutenticacion);
			set @correo = REPLACE(@correo, '[NOMBRE_REAL_USUARIO]', @nombreUsuario);

			/* Enviar correo electronico con el token */
			exec [dbo].[usp_enviar_correos] 
				@perfilCorreo='CorreosDinamo',
				@cuerpoCorreo=@correo, 
				@destinatarios=@correoElectronico, 
				@tituloCorrreo='Verificacion de Correo',
				@rutaArchivos=null

			/* Id del usuario */
			select @idUsuario = [usuario_id] from [dbo].[usuarios] where [usuario_nombre] = @nombreUsuario;

			/* Alamcenar el correo enviado */
			insert into [dbo].[correos_enviados](
				[correo_enviado_fecha],
				[correo_enviado_cuerpo],
				[tipo_correo_id_fk],
				[usuario_id_fk],
				[plantilla_correo_id_fk]
			) values(
				@fecha,
				@correo,
				1, /* Id de creaci�n de cuenta */
				@idUsuario,
				4 /* Id de la plantilla de creaci�n de cuenta  */
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
			throw 50002, '[Error]: Usuario o correo ya existentes', 1;
		if @numeroError = 50001
			throw 50001, '[Error]: No se pudo enviar el correo', 1;
		else
			throw @numeroError, @mensajeError, 1;
	end catch
end

-- select *from usuarios;
-- select *from sesiones;
-- select *from correos_enviados;
-- delete from  correos_enviados where correo_enviado_id = 5 ;
-- delete from usuarios where usuario_id = 1;