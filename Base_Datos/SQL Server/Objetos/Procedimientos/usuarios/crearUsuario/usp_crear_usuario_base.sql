/*========================================================================================================================
FECHA CREACION: 2026/05/19
AUTOR         : LUIS ANGEL SARMIENTO DIAZ
DETALLE       : Procedimiento que crea usuario usuario base al crear un nuevo usuario de forma manual en el Dinamo.
========================================================================================================================*/

/* Usar la base de datos */
USE Dinamo;
GO

CREATE OR ALTER PROCEDURE usp_crear_usuario_base
	@nombreUsuario NVARCHAR(50),
	@correoElectronico NVARCHAR(500),
	@contrasena NVARCHAR(MAX),
	@codigoAutenticacion NVARCHAR(6),
	@pais NVARCHAR(100),
	@region NVARCHAR(100),
	@fecha datetime2,
	@dispositivo NVARCHAR(200)
AS
BEGIN

	/* Variables */
	DECLARE @correo NVARCHAR(MAX);
	DECLARE @idUsuario INT;

	BEGIN TRY

		BEGIN TRAN

			/* Insertar usuario si no existe */
			INSERT INTO [dbo].[usuarios](
				[usuario_nombre], 
				[usuario_email], 
				[usuario_contrasena], 
				[usuario_pais],
				[usuario_habilitado], 
				[usuario_estado],
				[usuario_token_creacion],
				[medio_creacion_id_fk]
			) VALUES
			(@nombreUsuario, @correoElectronico, @contrasena, @pais, 1, 0, @codigoAutenticacion, 1);

			/* Consultar correo */
			SELECT @correo = [plantilla_correo_contenido] FROM [dbo].[plantillas_correos] WHERE [plantilla_correo_nombre] = 'correo de autenticacion';
			SET @correo = REPLACE(@correo, '[TOKEN_6_DIGITOS]', @codigoAutenticacion);
			SET @correo = REPLACE(@correo, '[NOMBRE_REAL_USUARIO]', @nombreUsuario);

			/* Enviar correo electronico con el token */
			exec [dbo].[usp_enviar_correos] 
				@perfilCorreo='Correos Dinamo',
				@cuerpoCorreo=@correo, 
				@destinatarios=@correoElectronico, 
				@tituloCorrreo='Verificacion de Correo',
				@rutaArchivos=null

			/* Id del usuario */
			SELECT @idUsuario = [usuario_id] FROM [dbo].[usuarios] WHERE [usuario_nombre] = @nombreUsuario;

			/* Alamcenar el correo enviado */
			INSERT INTO [dbo].[correos_enviados](
				[correo_enviado_fecha],
				[correo_enviado_cuerpo],
				[tipo_correo_id_fk],
				[usuario_id_fk],
				[plantilla_correo_id_fk]
			) VALUES(
				@fecha,
				@correo,
				1, /* Id de creaci�n de cuenta */
				@idUsuario,
				4 /* Id de la plantilla de creaci�n de cuenta  */
			)

			/* Almacenar log */
		COMMIT TRAN;
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN; 

		DECLARE @numeroError INT = ERROR_NUMBER();
		DECLARE @mensajeError NVARCHAR(4000) = ERROR_MESSAGE();

		IF @numeroError IN (2601, 2627)
			THROW 50002, '[Error]: Usuario o correo ya existentes', 1;
		IF @numeroError = 50001
			THROW 50001, '[Error]: No se pudo enviar el correo', 1;
		ELSE
			THROW @numeroError, @mensajeError, 1;
	END CATCH
END
GO