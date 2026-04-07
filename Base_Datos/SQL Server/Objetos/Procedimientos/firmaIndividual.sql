/*
//====================================
// PROCEDIMIENTO DE CARGUE DE FIRMAS
// INDIVIDUALES
//====================================
*/

use Master;
go

if OBJECT_ID('sp_firma_individual') is not null
	drop procedure sp_firma_individual;
go

create procedure sp_firma_individual 
	@id_usuario int, 
	@contrasena_firma nvarchar(1000),
	@llave_privada nvarchar(1000), 
	@ubicacion_pub nvarchar(1000),
	@ubicacion_csr nvarchar(1000),
	@ubicacion_crt nvarchar(1000),
	@ubicacion_p12 nvarchar(1000),
	@fecha_creacion datetime,
	@fecha_vencimiento datetime,
	@tipo_firma int = 1
	as
	begin
		-- Variables de resultados
		declare @id_firma int;

		-- Inserta firma
		insert into firmas(
			firma_pub, 
			firma_csr, 
			firma_crt, 
			firma_p12, 
			firma_fecha_creacion, 
			firma_fecha_vencimiento, 
			usuario_id_fk,
			tipo_firma_id_fk
		)
		values(
			@ubicacion_pub,
			@ubicacion_csr,
			@ubicacion_crt,
			@ubicacion_p12,
			@fecha_creacion,
			@fecha_vencimiento,
			@id_usuario,
			@tipo_firma
		)

		select @id_firma = firma_id from firmas where usuario_id_fk = @id_usuario; 

		-- Inserta llave privada 
		insert into llaves_privadas(llave_valor, firma_id_fk) values(@llave_privada, @id_firma); 

		-- Insertar contrasena firma
		insert into contrasenas_firmas(contrasena_firma_valor, firma_id_fk) values(@contrasena_firma, @id_firma);

		select 'Registros Insertados'; 

	end
go
