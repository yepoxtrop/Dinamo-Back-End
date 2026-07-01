/*========================================================================================================================
FECHA CREACION: 2026/03/19
AUTOR         : LUIS ANGEL SARMIENTO DIAZ
DETALLE       : Script de de disparadores 
FECHA MODIFICACION: 2026/03/19
AUTOR MODIFICACION: LUIS ANGEL SARMIENTO DIAZ
MODIFICACION      : Se modifican los comentarios de restricciones
========================================================================================================================*/

/* Usar base */
use Dinamo;
go

/*
DISPARADOR:		usp_insertar_peticiones
DESCRIPCION:	Se encarga de insertar la petición más reciente y capturar su id
RESULTADO:		Se retorna el id de la peticion
VARIABLES LOCALES:		
	-idPeticionNueva:id de la peticion
*/
create or alter trigger correo_reporte 
on [dbo].[reportes] for insert
as
	begin

		/* Variables locales */
		declare @rutaArchivo nvarchar(MAX);
		declare @htmlCorreo nvarchar(MAX);
		declare @idPeticion int;
		declare @nombreUsuario nvarchar(250);

		/* Buscar el ultimo reporte en xlsx y su id*/
		select top 1 @rutaArchivo = [reporte_ubicacion], @idPeticion = [peticion_validacion_id_fk] 
		from [dbo].[reportes] where [tipo_reporte_id_fk] = 1 order by [reporte_id] desc;
		--set @rutaArchivo = concat('\\172.16.10.32', @rutaArchivo);

		/* Capturar el id del usuario */
		select @nombreUsuario = [usuario_nombre] from [dbo].[usuarios] 
		inner join [dbo].[peticiones_validacion]
		on [dbo].[usuarios].[usuario_id] = [dbo].[peticiones_validacion].[usuario_id_fk]
		where [peticion_validacion_id] = @idPeticion; 

		/* Buscar estrcutra de correo */
		select @htmlCorreo = [plantilla_correo_contenido] from [dbo].[plantillas_correos] where [plantilla_correo_id] = 1;
		set @htmlCorreo = replace(@htmlCorreo, '[NOMBRE_REAL_USUARIO]', @nombreUsuario);

		/* Ejecutar usp de correos */
		exec [dbo].[usp_enviar_correos]
			@perfilCorreo = 'PerfilOutlook', 
			@cuerpoCorreo = @htmlCorreo, 
			@destinatarios = 'lsarmiento@aciel.co', 
			@tituloCorrreo = 'Reporte de peticion',
			@rutaArchivos = @rutaArchivo
	end
