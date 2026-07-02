/*========================================================================================================================
FECHA CREACION: 2026/01/22
AUTOR         : LUIS ANGEL SARMIENTO DIAZ
DETALLE       : Sp para enviar correos,
				@cuerpoCorreo
FECHA MODIFICACION: 2026/01/22
AUTOR MODIFICACION: LUIS ANGEL SARMIENTO DIAZ
MODIFICACION      : Se modifica el sp para que envie unicamente correos, el sp recibe el cuerpo en HTML,
                    los remitentes y el asunto del mismo. La idea es llamar el sp desde prisma.
========================================================================================================================*/

/* Usar la base de datos */
use [Dinamo];
go

/* Crear o modificar sp */
create or alter procedure usp_enviar_correos
	@perfilCorreo   nvarchar(200), 
	@cuerpoCorreo   nvarchar(MAX), 
    @destinatarios  nvarchar(1000), 
	@tituloCorrreo  nvarchar(500),
    @rutaArchivos   nvarchar(MAX)
as
	begin
        begin try
            /* Enviar correo de bienvenida */

            if @rutaArchivos is not null
            
                exec msdb.dbo.sp_send_dbmail
                    @profile_name = @perfilCorreo,
	                @recipients = @destinatarios,
	                @subject = @tituloCorrreo,
                    @file_attachments = @rutaArchivos,
	                @body = @cuerpoCorreo,
	                @body_format = 'HTML'
            else
                exec msdb.dbo.sp_send_dbmail
                    @profile_name = @perfilCorreo,
	                @recipients = @destinatarios,
	                @subject = @tituloCorrreo,
                    @body = @cuerpoCorreo,
	                @body_format = 'HTML'
                
                  
            /* Resultados */
	        select 'Correo Enviado Exitosamente';
        end try
        begin catch
            declare @numeroError int = ERROR_NUMBER();
		    declare @mensajeError nvarchar(4000) = ERROR_MESSAGE();
            
            throw 50001, 'Error Al Enviar El Correo', 1;
        end catch
            
	end
go


