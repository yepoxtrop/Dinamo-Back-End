/*========================================================================================================================
FECHA CREACION: 2026/03/19
AUTOR         : LUIS ANGEL SARMIENTO DIAZ
DETALLE       : Script de procedimientos almacenados para gestionar las firmas digitales.
FECHA MODIFICACION: 2026/03/19
AUTOR MODIFICACION: LUIS ANGEL SARMIENTO DIAZ
MODIFICACION      : Se modifican los comentarios de restricciones
========================================================================================================================*/

/* Usar la base de datos */
use Dinamo;
go

/*
PROCEDIMIENTO:	usp_insertar_firma
DESCRIPCION:	Se encarga de insertar las firmas 
RESULTADO:		...		-idPeticionNueva:id de la peticion
*/
create or alter procedure usp_insertar_firma
	@nombre_usuario		nvarchar(100), 
	@contrasena_firma	nvarchar(1000),
	@llave_privada		nvarchar(MAX), 
	@ubicacion_pub		nvarchar(MAX),
	@ubicacion_crt		nvarchar(MAX),
	@ubicacion_p12		nvarchar(MAX),
	@fecha_creacion		datetime2,
	@fecha_vencimiento	datetime2,
	@tipo_firma			int
as
begin 

	/* Variables de locales */
	declare @id_usuario int;
	declare @id_firma	int;

	/* Buscar id del usuario */
	select @id_usuario = [usuario_id] from [dbo].[usuarios] where [usuario_nombre] = @nombre_usuario;

	/* Insertar Firma */
	insert into [dbo].[firmas](
		[firma_pub], 
		[firma_crt], 
		[firma_p12], 
		[firma_fecha_creacion], 
		[firma_fecha_vencimiento], 
		[firma_estado], 
		[usuario_id_fk], 
		[tipo_firma_id_fk]
	) values(
		@ubicacion_pub, @ubicacion_crt, @ubicacion_p12, @fecha_creacion, @fecha_vencimiento, 1, @id_usuario, @tipo_firma
	);

	/* Buscar id de la firma */
	select @id_firma = [firma_id] from [dbo].[firmas] where [usuario_id_fk] = @id_usuario;

	/* Insertar llave prrivada */
	insert into [dbo].[llaves_privadas]([llave_valor], [firma_id_fk]) values(@llave_privada, @id_firma);

	/* Insertar contraseña de firma */
	insert into [dbo].[contrasenas_firmas]([contrasena_firma_valor], [firma_id_fk]) values(@contrasena_firma, @id_firma); 
end 
go

/*
PROCEDIMIENTO:	usp_consultar_firma_usuario
DESCRIPCION:	Se encarga de consultar si el usuario tiene firmas existentes
RESULTADO:		...		-idPeticionNueva:id de la peticion
*/
create or alter procedure usp_consultar_firma_usuario
	@nombre_usuario	nvarchar(100)
as
begin 

	/* Variables de locales */
	declare @id_usuario int;
	declare @id_firma int;

	/* Buscar id del usuario */
	select @id_usuario = [usuario_id] from [dbo].[usuarios] where [usuario_nombre] = @nombre_usuario;

	/* Buscar firma */
	if exists (select 1 from dbo.firmas where usuario_id_fk = @id_usuario)
		select * from [dbo].[firmas] where [usuario_id_fk] = @id_usuario;
	
end
go

/*
PROCEDIMIENTO:	usp_consultar_estado
DESCRIPCION:	Se encarga de consultar el estado de las firmas en general, 
				actuliza sus estados si las fechas ya no son válidas y envía correos 
				a los usuarios propietarios de las firmas
RESULTADO:		...		-idPeticionNueva:id de la peticion
*/
create or alter procedure usp_estado_firma
as
begin 

	/* Variables de locales */
	declare @fechaLocal datetime2  = sysdatetime();

	/* Buscar id del usuario */
	update [dbo].[firmas] set [firma_estado] = 0 where [firma_fecha_vencimiento] < @fechaLocal;

	/* Tabla temporal */
	create table #firmasVencidas(
		firma_vencida_id int identity(1,1) not null,
		firma_vencida_pub nvarchar(MAX) not null,
		firma_vencida_crt nvarchar(MAX) not null,
		firma_vencida_p12 nvarchar(MAX) not null,
	 	firma_vencida_fecha_creacion datetime2 not null,
		firma_vencida_fecha_vencimiento datetime2 not null,
		firma_vencida_estado bit not null,
		usuario_id_fk int not null unique,
		tipo_firma_id_fk int not null
	);
	
	/* Insertar firmas vencidas no renovadas */
	insert into #firmasVencidas(
		firma_vencida_pub,
		firma_vencida_crt,
		firma_vencida_p12,
	 	firma_vencida_fecha_creacion,
		firma_vencida_fecha_vencimiento,
		firma_vencida_estado,
		usuario_id_fk,
		tipo_firma_id_fk 
	)select [firma_pub],
			[firma_crt],
			[firma_p12],
			[firma_fecha_creacion],
			[firma_fecha_vencimiento],
			[firma_estado],
			[usuario_id_fk],
			[tipo_firma_id_fk]
	from [dbo].[firmas] where [firma_estado] = 0;

	
end