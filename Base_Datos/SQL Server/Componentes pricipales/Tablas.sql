/*
========================================================================================================================
	FECHA CREACION: 2026/01/21
	AUTOR         : LUIS ANGEL SARMIENTO DIAZ
	DETALLE       : Script de la base de datos, crea la base de datos, las diferentes tablas y sus respectivas
					restricciones, y también se insertan los valores por default necesarios para el funcionamiento
					de ciertos campos
========================================================================================================================
*/

/* 
=======================================================================
	BASE: Dinamo
	EMERGENCIA: use master; drop database Dinamo;
=======================================================================
*/
IF DB_ID('Dinamo') is null
	BEGIN
		create database Dinamo;
		print('Base de datos Dinamo creada');
	END
GO

use Dinamo;
GO

/* 
=======================================================================
	TABLA: Medios creacion usuario
	DETALLE: Tabla de los medios de creacion por lo cuales se 
			 crean los usuario en dinamo
=======================================================================
*/
IF OBJECT_ID('medios_creacion_usuario') is null
	BEGIN
		CREATE TABLE medios_creacion_usuario(
			medios_creacion_id int not null identity(1,1), 
		    medios_creacion varchar(50) not null unique,
			medios_creacion_descripcion nvarchar(300) not null,
		    constraint pk_medios_creacion primary key(medios_creacion_id) /* llave primaria */
		); 
		print('Tabla MEDIO_CREACION_USUARIO creada');
	END
GO

/* 
=======================================================================
	TABLA: Usuarios
	DETALLE: Tabla de usuarios 
=======================================================================
*/
IF OBJECT_ID('usuarios') is null
	BEGIN
		CREATE TABLE usuarios (
			usuario_id int not null identity(1,1),
			usuario_nombre nvarchar(50) not null unique,
			usuario_nombre_real nvarchar(200) null,
			usuario_documento bigint null,
			usuario_email nvarchar(500) not null unique,
			usuario_email_secundario nvarchar(MAX) null,
			usuario_contrasena nvarchar(MAX) not null,
			usuario_pais nvarchar(100) null,
			usuario_habilitado bit not null,
			usuario_estado bit not null,
			usuario_token_creacion nvarchar(6) null,
			medio_creacion_id_fk int not null,
			constraint pk_usuario primary key(usuario_id), /* llave primaria */
			constraint fk_medio_creacion_en_usuario foreign key(medio_creacion_id_fk) REFERENCES medios_creacion_usuario(medios_creacion_id) /* llave foranea */
		); 
		print('Tabla USUARIOS creada');
	END
GO

/* 
=======================================================================
	TABLA: Roles
	DETALLE: Tabla de roles que hay en Dinamo
=======================================================================
*/
IF OBJECT_ID('roles') is null
	BEGIN
		CREATE TABLE roles (
			rol_id int not null identity(1,1), 
		    rol_nombre varchar(50) not null unique,
			rol_descripcion nvarchar(300) not null,
		    constraint pk_rol primary key(rol_id) /* llave primaria */
		); 
		print('Tabla ROLES creada');
	END
GO

/* 
=======================================================================
	TABLA: Roles disponibles
	DETALLE: Tabla de roles disponibles para los usuarios
=======================================================================
*/
IF OBJECT_ID('roles_disponibles') is null
	BEGIN
		CREATE TABLE roles_disponibles (
			rol_disponible_id int not null identity(1,1), 
		    usuario_id_fk int not null,
			rol_id_fk int not null,
			constraint pk_rol_disponible primary key(rol_disponible_id), /* llave primaria */
			constraint fk_usuario_en_rol_disponible foreign key(usuario_id_fk) REFERENCES usuarios(usuario_id), /* llave foranea */
			constraint fk_rol_en_rol_disponible foreign key(rol_id_fk) REFERENCES roles(rol_id) /* llave foranea */
		); 
		print('Tabla ROLES_DISPONIBLES creada');
	END
GO

/* 
=======================================================================
	TABLA: Tipos correos
	DETALLE: Tabla de tipos de correos que envia el sistema
=======================================================================
*/
IF OBJECT_ID('tipos_correos') is null
	BEGIN
		CREATE TABLE tipos_correos (
			tipo_correo_id int not null identity(1,1), 
		    tipo_correo_nombre varchar(50) not null unique,
			tipo_correo_descripcion nvarchar(300) not null,
		    constraint pk_tipo_correo primary key(tipo_correo_id) /* llave primaria */
		); 
		print('Tabla TIPOS_CORREOS creada');
	END
GO

/* 
=======================================================================
	TABLA: Plantillas correos
	DETALLE: Tabla de tipos de correos que envia el sistema
=======================================================================
*/
IF OBJECT_ID('plantillas_correos') is null
	BEGIN
		CREATE TABLE plantillas_correos (
			plantilla_correo_id	int not null identity(1,1), 
		    plantilla_correo_nombre varchar(50) not null unique,
			plantilla_correo_descripcion nvarchar(300) not null,
			plantilla_correo_contenido nvarchar(MAX) not null,
		    constraint pk_plantilla_correo primary key(plantilla_correo_id) /* llave primaria */
		); 
		print('Tabla PLANTILLAS_CORREOS creada');
	END
GO

/* 
=======================================================================
	TABLA: Correos enviados
	DETALLE: Tabla de con los correos que envia el sistema
=======================================================================
*/
IF OBJECT_ID('correos_enviados') is null
	BEGIN
		CREATE TABLE correos_enviados (
			correo_enviado_id int not null identity(1,1),
			correo_enviado_fecha datetime2 not null,
			correo_enviado_cuerpo nvarchar(MAX) not null,
			usuario_id_fk int not null,
			tipo_correo_id_fk int not null,
			plantilla_correo_id_fk int not null,
			constraint pk_correo_usado primary key(correo_enviado_id), /* llave primaria */
			constraint fk_usuario_en_correo_enviado foreign key(usuario_id_fk) REFERENCES usuarios(usuario_id) on delete cascade, /* llave foranea */
			constraint fk_tipo_correo_en_correo_enviado foreign key(tipo_correo_id_fk) REFERENCES tipos_correos(tipo_correo_id), /* llave foranea */
			constraint fk_plantilla_correo_en_correo_enviado foreign key(plantilla_correo_id_fk) REFERENCES plantillas_correos(plantilla_correo_id), /* llave foranea */
		);
		print('Tabla CORREOS_ENVIADOS creada');
	END
GO

/* 
=======================================================================
	TABLA: Sesion
	DETALLE: Tabla con las sesiones de los usuarios
=======================================================================
*/
IF OBJECT_ID('sesiones') is null
	 BEGIN
		CREATE TABLE sesiones (
			sesion_id int not null identity(1,1),
			sesion_fecha datetime2 not null,
			sesion_dispositivo varchar(MAX) not null,
			sesion_ip nvarchar(45) not null,
			sesion_autenticacion_token nvarchar(25) not null,/* Patron HEXA que se envia correo */
			sesion_token nvarchar(MAX) not null,
			usuario_id_fk int not null,
			constraint pk_sesion primary key(sesion_id), /* llave primaria */
			constraint fk_usuario_en_inicio_sesion foreign key(usuario_id_fk) REFERENCES usuarios(usuario_id) on delete cascade/* llave foranea */
		);
		print('Tabla SESIONES creada');
	 END
GO

/*
=======================================================================
	TABLA: Tipo firmas
	DETALLE: Tabla con el tipo de firmas manejados en Dinamo
=======================================================================
*/
IF OBJECT_ID('tipo_firmas') is null
	BEGIN
		CREATE TABLE tipo_firmas (
			tipo_firma_id int not null identity(1,1),
			tipo_firma_nombre nvarchar(30) not null unique,
			tipo_firma_descripcion nvarchar(300) not null,
			constraint pk_tipo_firma primary key(tipo_firma_id), /* llave primaria */
		); 
		print('Tabla TIPO_FIRMAS creada');
	END
GO

/*
=======================================================================
	TABLA: Firmas
	DETALLE: Tabla con las firmas creadas o cargadas de los 
			 usuarios
=======================================================================
*/
IF OBJECT_ID('firmas') is null
	BEGIN
		CREATE TABLE firmas (
			firma_id int not null identity(1,1),
			firma_pub nvarchar(MAX) null,
			firma_crt nvarchar(MAX) null,
			firma_p12 nvarchar(MAX) not null,
	 		firma_fecha_creacion datetime2 not null,
			firma_fecha_vencimiento datetime2 not null,
			firma_correo_asociado nvarchar(MAX) not null,
			firma_ubicacion nvarchar(MAX) not null,
			firma_estado bit not null,
			usuario_id_fk int not null,
			tipo_firma_id_fk int not null,
			constraint pk_firma primary key(firma_id), /* llave primaria */
			constraint fk_usuario_en_firma foreign key(usuario_id_fk) REFERENCES usuarios(usuario_id) on delete cascade, /* llave foranea */
			constraint fk_tipo_firma_en_firma foreign key(tipo_firma_id_fk) REFERENCES tipo_firmas(tipo_firma_id), /* llave foranea */
			constraint check_fecha_vencimiento check(firma_fecha_vencimiento>firma_fecha_creacion), /* restriccion check */
		);
		print('Tabla FIRMAS creada');
	END
GO

/*
=======================================================================
	TABLA:	 Versión de firmas
	DETALLE: Tabla con la versión de las firmas creadas 
			 por los usuarios de Dinamo
=======================================================================
*/
IF OBJECT_ID('version_firmas') is null
	BEGIN
		CREATE TABLE version_firmas(
			version_firma_id int not null identity(1,1),
			version_firma nvarchar(100) not null,
			firma_id_fk int not null,
			constraint pk_version_firma primary key(version_firma_id), /* Llave primaria */
			constraint fk_firma_en_version_firma foreign key(firma_id_fk) REFERENCES firmas(firma_id) on delete cascade/* Llave foranea */
		);
		print('Tabla VERSION_FIRMAS creada');
	END
GO

/*
=======================================================================
	TABLA: Llaves privadas
	DETALLE: Tabla con las llaves privadas de las firmas creadas 
			 por los usuarios de Dinamo
=======================================================================
*/
IF OBJECT_ID('llaves_privadas') is null
	BEGIN
		CREATE TABLE llaves_privadas (
			llave_id int not null identity(1,1),
			llave_valor nvarchar(MAX) not null,
			firma_id_fk int not null unique, 
			constraint pk_llave primary key(llave_id), /* llave primaria */
			constraint fk_firmas_en_llave_privada foreign key(firma_id_fk) REFERENCES firmas(firma_id) on delete cascade/* llave foranea */
		); 
		print('Tabla LLAVES_PRIVADAS creada'); 
	END
GO

/*
=======================================================================
	TABLA: Contraseñas firmas
	DETALLE: Tabla con las llaves privadas de las firmas creadas y
			 cargadas por los usuarios de Dinamo
=======================================================================
*/
IF OBJECT_ID('contrasenas_firmas') is null
	BEGIN
		CREATE TABLE contrasenas_firmas(
			contrasena_firma_id int not null identity(1,1),
			contrasena_firma_valor nvarchar(1000) not nulL,
			firma_id_fk int not null unique,
			constraint pk_contrasena_firma primary key(contrasena_firma_id), /* llave primaria */
			constraint fk_firma_en_contrasena_firma foreign key(firma_id_fk) REFERENCES firmas(firma_id) on delete cascade/* llave foranea */
		);
		print('Tabla CONTRASENA_FIRMAS creada'); 
	END
GO

/*
=======================================================================
	TABLA: Tipo logs
	DETALLE: Tabla con los tipos de logs en Dinamo
=======================================================================
*/
IF OBJECT_ID('tipos_logs') is null
	BEGIN
		CREATE TABLE tipos_logs (
			tipo_log_id int not null identity(1,1),
			tipo_log_nombre nvarchar(30) not null,
			tipo_log_descripcion nvarchar(MAX) not null,
			constraint pk_tipo_log primary key(tipo_log_id) /* llave primaria */
		);
		print('Tabla TIPO_LOGS creada');
	END
GO

/*
=======================================================================
	TABLA: logs
	DETALLE: Tabla con los logs de Dinamo
=======================================================================
*/
IF OBJECT_ID('logs') is null
	BEGIN
		CREATE TABLE logs (
			log_id int not null identity(1,1),
			log_titulo nvarchar(30) not null,
			log_descripcion_base nvarchar(MAX) not null,
			log_descripcion_completa nvarchar(MAX) not null,
			log_fecha datetime2 not null, 
			log_usuario_bd nvarchar(MAX) not null,
			log_ip_peticion nvarchar(30) not null,
			log_dispositivo_peticion nvarchar(100) not null,
			log_tipo_id_fk int not null,
			usuario_id_fk int null,
			constraint pk_log primary key(log_id), /* llave primaria */
			constraint fk_tipo_log_en_log foreign key(log_tipo_id_fk) REFERENCES tipos_logs(tipo_log_id), /* llave foranea */
			constraint fk_usuario_en_log foreign key(usuario_id_fk) REFERENCES usuarios(usuario_id) on delete cascade /* llave foranea */
		);
		print('Tabla LOGS creada');
	END
GO

/*
=======================================================================
	TABLA: Estado documentos
	DETALLE: Tabla con los estados posibles para los documentos en
			 Dinamo
=======================================================================
*/
IF OBJECT_ID('estado_documentos') is null
	BEGIN
		CREATE TABLE estado_documentos (
			estado_documento_id int not null identity(1,1),
			estado_documento nvarchar(30) not null,
			estado_documento_descripcion nvarchar(MAX) not null,
			constraint pk_estado_documento primary key(estado_documento_id), /* llave primaria */
		);
		print('Tabla ESTADO_DOCUMENTOS creada');
	END
GO

/*
=======================================================================
	TABLA: Tipo documentos
	DETALLE: Tabla con los tipos dedocumentos en Dinamo
=======================================================================
*/
IF OBJECT_ID('tipo_documentos') is null
	BEGIN
		CREATE TABLE tipo_documentos (
			tipo_documento_id int not null identity(1,1),
			tipo_documento nvarchar(30) not null,
			tipo_documento_descripcion nvarchar(MAX) not null,
			constraint pk_tipo_documento primary key(tipo_documento_id), /* llave primaria */
		);
		print('Tabla TIPO_DOCUMENTOS creada');
	END
GO

/*
=======================================================================
	TABLA: Dcumentos
	DETALLE: Tabla con los documentos de Dinamo
=======================================================================
*/
IF OBJECT_ID('documentos') is null
	BEGIN
		CREATE TABLE documentos (
			documento_id int not null identity(1,1),
			documento_ubicacion nvarchar(MAX) not null,
			documento_estado bit not null,
			documento_fecha datetime2 not null,
			documento_token_acceso nvarchar(MAX) null, /* Para modificaciones anónimas */
			documento_permiso bit not null, 
			tipo_documento_id_fk int not null,
			estado_documento_id_fk int not null,
			constraint pk_documento primary key(documento_id), /* llave primaria */
			constraint fk_tipo_documento_en_documento foreign key(tipo_documento_id_fk) REFERENCES tipo_documentos(tipo_documento_id), /* llave primaria */
			constraint fk_estado_documento_en_documento foreign key(estado_documento_id_fk) REFERENCES estado_documentos(estado_documento_id) /* llave primaria */
		);
		print('Tabla DOCUMENTOS creada');
	END
GO

/*
=======================================================================
	TABLA: Documentos firmas
	DETALLE: Tabla con las firmas relacionadas a un documento
=======================================================================
*/
IF OBJECT_ID('documentos_firmas') is null
	BEGIN
		CREATE TABLE documentos_firmas (
			documento_firma_id int not null identity(1,1),
			documento_firma_fecha datetime2 not null,
			firma_id_fk int not null,
			documento_id_fk int not null,
			constraint pk_documento_firma primary key(documento_firma_id), /* llave primaria */
			constraint fk_documento_en_documento_firma foreign key(documento_id_fk) REFERENCES documentos(documento_id) on delete cascade, /* llave foranea */
			constraint fk_firma_en_documento_firma foreign key(firma_id_fk) REFERENCES firmas(firma_id) on delete cascade/* llave foranea */
		);
		print('Tabla DOCUMENTOS_FIRMAS creada');
	END
GO


/*
=======================================================================
	TABLA: Configuracion firmas
	DETALLE: Tabla con datos de las firmas creadas en Dinamo
=======================================================================
*/
IF OBJECT_ID('configuracion_firmas') is null
	BEGIN
		CREATE TABLE configuracion_firmas (
			configuracion_firma_id int not null identity(1,1),
			configuracion_firma_version nvarchar(100) not null default 'X.509',
			configuracion_firma_serie nvarchar(100) not null, 
			configuracion_firma_algoritmo nvarchar(100) not null default 'rsa',
			configuracion_firma_emisor nvarchar(300) not null,
			configuracion_firma_cn nvarchar(300) not null,
			configuracion_firma_o nvarchar(100) not null,
			configuracion_firma_ou nvarchar(100) not null,
			configuracion_firma_i nvarchar(100) not null,
			configuracion_firma_st nvarchar(100) not null,
			configuracion_firma_c nvarchar(100) not null,
			firma_id_fk int not null,
			version_firma_id_fk int not null,
			constraint pk_configuracion_firma primary key (configuracion_firma_id), /* llave primaria */
			constraint fk_firma_en_configuracion_firma foreign key(firma_id_fk) REFERENCES firmas(firma_id) on delete cascade, /* llave foranea */
			constraint fk_version_firma foreign key(version_firma_id_fk) REFERENCES version_firmas(version_firma_id), /* llave foranea */
		);
		print('Tabla CONFIGURACION_FIRMAS creada');
	END
GO

/*
=======================================================================
	TABLA: Peticiones validacion
	DETALLE: Tabla con datos de las firmas creadas en Dinamo
=======================================================================
*/
IF OBJECT_ID('peticiones_validacion') is null
	BEGIN
		CREATE TABLE peticiones_validacion (
			peticion_validacion_id int not null identity(1,1),
			peticion_validacion_fecha datetime2 not null,
			peticion_validacion_nombre nvarchar(300) not null,
			usuario_id_fk int not null,
			constraint pk_peticion_validacion primary key(peticion_validacion_id), /* llave primaria */
			constraint fk_usuario_en_peticion_validacion foreign key(usuario_id_fk) REFERENCES usuarios(usuario_id) on delete cascade/* llave foranea */
		);
		print('Tablas PETICIONES_VALIDACION creada');
	END
GO

/*
=======================================================================
	TABLA: Documentos validados
	DETALLE: Tabla con los datos de los documentos validados 
			 en las peticiones de validacion Dinamo
=======================================================================
*/
IF OBJECT_ID('documentos_validados') is null 
	BEGIN 
		CREATE TABLE documentos_validados (
			documento_validado_id int not null identity(1,1),
			documento_validado_ubicacion nvarchar(MAX) not null,
			documento_validado_estado bit null,
			documento_validado_nombre nvarchar(MAX) not null,
			documento_validado_causa_estado nvarchar(MAX) null,
			documento_validado_total_firmas int null,
			documento_validado_firmas_vencidas int null,
			documento_validado_tipo nvarchar(30) not null,
			peticion_validacion_id_fk int not null,
			constraint pk_documento_validado primary key(documento_validado_id), /* llave primaria */
			constraint fk_peticion_validacion_en_documento_validado foreign key(peticion_validacion_id_fk) REFERENCES peticiones_validacion(peticion_validacion_id) on delete cascade, /* llave foranea */
		);
		print('Tabla DOCUMENTOS_VALIDADOS creada');
	END
GO

/*
=======================================================================
	TABLA: Tipo documentos
	DETALLE: Tabla con tipos de reportes en Dinamo
=======================================================================
*/
IF OBJECT_ID('tipo_reportes') is null
	BEGIN
		CREATE TABLE tipo_reportes (
			tipo_reporte_id int not null identity(1,1), 
		    tipo_reporte_nombre varchar(50) not null unique,
			tipo_reporte_descripcion nvarchar(300) not null,
		    constraint pk_tipo_reporte primary key(tipo_reporte_id) /* llave primaria */
		); 
		print('Tabla TIPOS_REPORTES creada');
	END
GO

/*
=======================================================================
	TABLA: Reportes
	DETALLE: Tabla con los datos de los reportes en dinamo
=======================================================================
*/
IF OBJECT_ID('reportes') is null 
	BEGIN 
		CREATE TABLE reportes (
			reporte_id int not null identity(1,1),
			reporte_ubicacion nvarchar(MAX) not null,
			reporte_fecha datetime2 not null,
			reporte_existencia bit not null default 1,
			peticion_validacion_id_fk int not null,
			tipo_reporte_id_fk int not null,
			constraint pk_reporte primary key(reporte_id), /* llave primaria */
			constraint fk_peticion_validacion_en_reporte foreign key(peticion_validacion_id_fk) REFERENCES peticiones_validacion(peticion_validacion_id) on delete cascade, /* llave foranea */
			constraint fk_tipo_reporte_en_reporte foreign key(tipo_reporte_id_fk) REFERENCES tipo_reportes(tipo_reporte_id) on delete cascade /* llave foranea */
		);
		print('Tabla REPORTES creada');
	END
GO

/*
=======================================================================
	TABLA: Datos certificados
	DETALLE: Tabla con los datos de los certificados encontrados en
			 documentos analizados
=======================================================================
*/
IF OBJECT_ID('datos_certificados') is null
	BEGIN
		CREATE TABLE datos_certificados (
			dato_certificado_id int not null identity(1,1),
			dato_certificado_numero int not null,
			dato_certificado_version nvarchar(100) not null,
			dato_certificado_serial nvarchar(200) not null, 
			dato_certificado_oid nvarchar(200) not null,
			dato_certificado_fecha_creacion date not null,
			dato_certificado_fecha_vencimiento date not null,
			dato_certificado_estado bit not null,
			dato_certificado_editor nvarchar(MAX) not null,
			dato_certificado_sujeto nvarchar(MAX) not null,
			dato_certificado_causa_estado nvarchar(MAX) not null,
			dato_certificado_fecha_uso date null,
			dato_certificado_validacion_vencimiento_estado bit not null,
			dato_certificado_validacion_vencimiento_descripcion nvarchar(MAX) not null,
			dato_certificado_validacion_uso_estado bit null,
			dato_certificado_validacion_uso_descripcion nvarchar(MAX) not null,
			dato_certificado_validacion_hash_estado bit not null,
			dato_certificado_validacion_hash_descripcion nvarchar(MAX) not null,
			dato_certificado_validacion_integridad_estado bit not null,
			dato_certificado_validacion_integridad_descripcion nvarchar(MAX) not null,
			documento_validado_fk int not null,
			constraint pk_datos_certificados primary key (dato_certificado_id), /* llave primaria */
			constraint fk_documento_validado_en_dato_certificado foreign key(documento_validado_fk) REFERENCES documentos_validados(documento_validado_id) on delete cascade /* llave foranea */
		);
		print('Tabla DATOS_CERTIFICADOS creada');
	END
GO