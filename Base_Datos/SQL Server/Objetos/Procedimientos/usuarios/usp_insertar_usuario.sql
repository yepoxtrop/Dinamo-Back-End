/*========================================================================================================================
FECHA CREACION: 2026/03/19
AUTOR         : LUIS ANGEL SARMIENTO DIAZ
DETALLE       : El usp Se encarga de insertar el usuario en la base de datos, la sesion si el usuario ya existe, 
				unicamente inserta la sesion 
				generado para la sesion
FECHA MODIFICACION: 2026/07/02
========================================================================================================================*/

/* Usar la base de datos */
use Dinamo;
go

create or alter procedure usp_insertar_usuario
	@nombre_dominio_usuario nvarchar(200),
	@nombre_real_usuario	nvarchar(500),
	@fecha_sesion			datetime2, 
	@dispositivo_sesion		nvarchar(MAX)
as
begin 
	
	/* Variables locales */
	declare @id_usuario int;
	declare @id_rol int;

	/* Consultar usuario */
	select @id_usuario = [usuario_id] , @id_rol = [rol_id_fk] from [dbo].[usuarios] where [usuario_nombre] = @nombre_dominio_usuario;
	
	/* Insertar usuarios SI NO EXISTE */
	if @id_usuario is null 
		insert into [dbo].[usuarios]([usuario_nombre], [usuario_nombre_real])
		values(@nombre_dominio_usuario, @nombre_real_usuario);
		select @id_usuario = [usuario_id] , @id_rol = [rol_id_fk] from [dbo].[usuarios] where [usuario_nombre] = @nombre_dominio_usuario;
	
	/* Insertar sesion */
	insert into [dbo].[sesiones]([sesion_fecha], [sesion_dispositivo], [usuario_id_fk])
	values(@fecha_sesion, @dispositivo_sesion, @id_usuario);
	select @id_usuario as 'id_usuario', @id_rol as 'id_rol'; 
end