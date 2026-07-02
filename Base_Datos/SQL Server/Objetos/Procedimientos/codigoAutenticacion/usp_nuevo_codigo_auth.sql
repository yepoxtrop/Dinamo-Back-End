/*========================================================================================================================
FECHA CREACION: 2026/05/19
AUTOR         : LUIS ANGEL SARMIENTO DIAZ
DETALLE       : Procedimiento que actualiza el token de verificacion de cuenta del usuario, aplica para login
				y register manual.
========================================================================================================================*/

/* Usar la base de datos */
use Dinamo;
go

create or alter procedure usp_nuevo_codigo_auth
	@correoElectronico nvarchar(500),
	@codigoAutenticacion nvarchar(6)
as
begin
	/* Variables */
	declare @correo nvarchar(MAX);
	declare @idUsuario int;
	begin try

		begin tran
			/* Buscar que el usuario exista en bd */
			select @idUsuario = [usuario_id] from [dbo].[usuarios] where [usuario_email] = @correoElectronico;

			if @idUsuario is null
				throw 50003, '[ERROR]: Usuario no encontrado, no envia nada', 1; 

			/* Actualizar el codigo */
			update [dbo].[usuarios]
			set [usuario_token_creacion] = @codigoAutenticacion
			where [usuario_id] = @idUsuario and [usuario_email] = @correoElectronico;

			/* Consultar correo */
			select @correo = [plantilla_correo_contenido] from [dbo].[plantillas_correos] where [plantilla_correo_nombre] = 'correo de nuevos tokens de verficacion';
			set @correo = REPLACE(@correo, '[TOKEN_6_DIGITOS]', @codigoAutenticacion);

			/* Enviar correo electronico con el token */
			exec [dbo].[usp_enviar_correos] 
				@perfilCorreo='CorreosDinamo',
				@cuerpoCorreo=@correo, 
				@destinatarios=@correoElectronico, 
				@tituloCorrreo='Verificacion de Correo',
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
				1, /* Id de creaci�n de cuenta */
				@idUsuario,
				5 /* Id de la plantilla de creaci�n de cuenta  */
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
		if @numeroError in (100, 208)
			throw 50004, '[Error]: Sintaxis mal escrita', 1;
		if @numeroError in (248, 547)
			throw 50005, '[Error]: Violacion a las restricciones de datos', 1;
		else
			throw @numeroError, @mensajeError, 1;
	end catch
end

-- select *from usuarios;
-- select *from plantillas_correos;
-- select *from correos_enviados;
-- delete from  correos_enviados where correo_enviado_id = 5 ;
-- delete from usuarios where usuario_id = 2;