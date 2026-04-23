/*========================================================================================================================
FECHA CREACION: 2026/01/21
AUTOR         : LUIS ANGEL SARMIENTO DIAZ
DETALLE       : Script de la base de datos, crea la base de datos, las diferentes tablas y sus respectivas
				restricciones, y también se insertan los valores por default necesarios para el funcionamiento
				de ciertos campos
FECHA MODIFICACION: 2026/01/22
AUTOR MODIFICACION: LUIS ANGEL SARMIENTO DIAZ
MODIFICACION      : Se modifican los comentarios de restricciones
========================================================================================================================*/

/* CREACION DE BASE DE DATOS */
if DB_ID('Dinamo') is null
	begin
		create database Dinamo;
		print('Base de datos DINAMO creada');
	end
/* drop database Dinamo */
go

use Dinamo;
go

/* CREACION DE TABLAS */
if OBJECT_ID('roles') is null
	begin
		create table roles (
			rol_id			int not null identity(1,1), 
		    rol_nombre		varchar(50) not null unique,
			rol_descripcion nvarchar(300) not null,
		    constraint pk_rol primary key(rol_id) /* llave primaria */
		); 
		print('Tabla ROLES creada');
	end

if OBJECT_ID('usuarios') is null
	begin
		create table usuarios (
			usuario_id			int not null identity(1,1),
			usuario_nombre		varchar(50) not null unique,
			usuario_nombre_real nvarchar(200) not null,
			usuario_correo nvarchar(500) null,
			rol_id_fk int not null default 4,
			constraint pk_usuario primary key(usuario_id), /* llave primaria */
			constraint fk_rol_en_usuarios foreign key(rol_id_fk) references roles(rol_id) /* llave foranea */
		); 

		print('Tabla USUARIOS creada');
	end

if OBJECT_ID('tipos_correos') is null
	begin
		create table tipos_correos (
			tipo_correo_id			int not null identity(1,1), 
		    tipo_correo_nombre		varchar(50) not null unique,
			tipo_correo_descripcion nvarchar(300) not null,
		    constraint pk_tipo_correo primary key(tipo_correo_id) /* llave primaria */
		); 
		print('Tabla TIPOS_CORREOS creada');
	end

if OBJECT_ID('plantillas_correos') is null
	begin
		create table plantillas_correos (
			plantilla_correo_id				int not null identity(1,1), 
		    plantilla_correo_nombre			varchar(50) not null unique,
			plantilla_correo_descripcion	nvarchar(300) not null,
			plantilla_correo_contenido		nvarchar(MAX) not null,
		    constraint pk_plantilla_correo primary key(plantilla_correo_id) /* llave primaria */
		); 
		print('Tabla PLANTILLAS_CORREOS creada');
	end

if OBJECT_ID('correos_enviados') is null
	begin
		create table correos_enviados (
			correo_enviado_id		int not null identity(1,1),
			correo_enviado_fecha	datetime2 not null,
			correo_enviado_cuerpo	nvarchar(MAX) not null,
			usuario_id_fk			int not null,
			tipo_correo_id_fk		int not null,
			plantilla_correo_id_fk	int not null,
			constraint pk_correo_usado primary key(correo_enviado_id), /* llave primaria */
			constraint fk_usuario_en_correo_enviado foreign key(usuario_id_fk) references usuarios(usuario_id), /* llave foranea */
			constraint fk_tipo_correo_en_correo_enviado foreign key(tipo_correo_id_fk) references tipos_correos(tipo_correo_id), /* llave foranea */
			constraint fk_plantilla_correo_en_correo_enviado foreign key(plantilla_correo_id_fk) references plantillas_correos(plantilla_correo_id), /* llave foranea */
		);
		print('Tabla CORREOS_ENVIADOS creada');
	end


if OBJECT_ID('sesiones') is null
	 begin
		create table sesiones (
			sesion_id			int not null identity(1,1),
			sesion_fecha		datetime2 not null,
			sesion_dispositivo	varchar(MAX) not null,
			usuario_id_fk		int not null,
			constraint pk_sesion primary key(sesion_id), /* llave primaria */
			constraint fk_usuario_en_inicio_sesion foreign key(usuario_id_fk) references usuarios(usuario_id) /* llave foranea */
		);
		print('Tabla SESIONES creada');
	 end

if OBJECT_ID('tokens') is null
	begin 
		create table tokens (
			token_id		int not null identity(1,1),
			token_valor		nvarchar(2000) not null,
			token_duracion	varchar(50) not null default '1 hora',
			usuario_id_fk	int not null,
			constraint pk_token primary key(token_id), /* llave primaria */
			constraint fk_usuario_en_tokens foreign key(usuario_id_fk) references usuarios(usuario_id), /* llave foranea */
			constraint check_token_duracion check(token_duracion='1 hora'), /* restriccion check */
		);
		print('Tablas TOKENS creada')
	end

if OBJECT_ID('peticiones_validacion') is null
	begin
		create table peticiones_validacion (
			peticion_validacion_id int not null identity(1,1),
			peticion_validacion_fecha datetime not null,
			peticion_validacion_nombre nvarchar(300) not null,
			usuario_id_fk int not null,
			constraint pk_peticion_validacion primary key(peticion_validacion_id), /* llave primaria */
			constraint fk_usuario_en_peticion_validacion foreign key(usuario_id_fk) references usuarios(usuario_id) /* llave foranea */
		);
		print('Tablas PETICIONES_VALIDACION creada');
	end

if OBJECT_ID('tipo_reportes') is null
	begin
		create table tipo_reportes (
			tipo_reporte_id int not null identity(1,1), 
		    tipo_reporte_nombre varchar(50) not null unique,
			tipo_reporte_descripcion nvarchar(300) not null,
		    constraint pk_tipo_reporte primary key(tipo_reporte_id) /* llave primaria */
		); 
		print('Tabla TIPOS_REPORTES creada');
	end

if OBJECT_ID('reportes') is null 
	begin 
		create table reportes (
			reporte_id int not null identity(1,1),
			reporte_ubicacion nvarchar(MAX) not null,
			reporte_fecha datetime2 not null,
			reporte_existencia bit not null default 1,
			peticion_validacion_id_fk int not null,
			tipo_reporte_id_fk int not null,
			constraint pk_reporte primary key(reporte_id), /* llave primaria */
			constraint fk_peticion_validacion_en_reporte foreign key(peticion_validacion_id_fk) references peticiones_validacion(peticion_validacion_id), /* llave foranea */
			constraint fk_tipo_reporte_en_reporte foreign key(tipo_reporte_id_fk) references tipo_reportes(tipo_reporte_id) /* llave foranea */
		);
		print('Tabla REPORTES creada');
	end

if OBJECT_ID('documentos_validados') is null 
	begin 
		create table documentos_validados (
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
			constraint fk_peticion_validacion_en_documento_validado foreign key(peticion_validacion_id_fk) references peticiones_validacion(peticion_validacion_id), /* llave foranea */
		);
		print('Tabla DOCUMENTOS_VALIDADOS creada');
	end

if OBJECT_ID('datos_certificados') is null
	begin
		create table datos_certificados (
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
			constraint fk_documento_validado_en_dato_certificado foreign key(documento_validado_fk) references documentos_validados(documento_validado_id) /* llave foranea */
		);
		print('Tabla DATOS_CERTIFICADOS creada');
	end

if OBJECT_ID('tipo_firmas') is null
	begin
		create table tipo_firmas (
			tipo_firma_id int not null identity(1,1),
			tipo_firma_nombre nvarchar(30) not null unique,
			tipo_firma_descripcion nvarchar(300) not null,
			constraint pk_tipo_firma primary key(tipo_firma_id), /* llave primaria */
		); 
		print('Tabla TIPO_FIRMAS creada');
	end

if OBJECT_ID('firmas') is null
	begin
		create table firmas (
			firma_id int not null identity(1,1),
			firma_pub nvarchar(MAX) not null,
			firma_crt nvarchar(MAX) not null,
			firma_p12 nvarchar(MAX) not null,
	 		firma_fecha_creacion datetime2 not null,
			firma_fecha_vencimiento datetime2 not null,
			firma_estado bit not null,
			usuario_id_fk int not null unique,
			tipo_firma_id_fk int not null,
			constraint pk_firma primary key(firma_id), /* llave primaria */
			constraint fk_usuario_en_firma foreign key(usuario_id_fk) references usuarios(usuario_id), /* llave foranea */
			constraint fk_tipo_firma_en_firma foreign key(tipo_firma_id_fk) references tipo_firmas(tipo_firma_id), /* llave foranea */
			constraint check_fecha_vencimiento check(firma_fecha_vencimiento>firma_fecha_creacion), /* restriccion check */
			constraint check_fecha_creacion check(firma_fecha_creacion<firma_fecha_vencimiento), /* restriccion check */
		);
		print('Tabla FIRMAS creada');
	end

if OBJECT_ID('llaves_privadas') is null
	begin
		create table llaves_privadas (
			llave_id int not null identity(1,1),
			llave_valor nvarchar(MAX) not null,
			firma_id_fk int not null unique, 
			constraint pk_llave primary key(llave_id), /* llave primaria */
			constraint fk_firmas_en_llave_privada foreign key(firma_id_fk) references firmas(firma_id) /* llave foranea */
		); 
		print('Tabla LLAVES_PRIVADAS creada'); 
	end

if OBJECT_ID('contrasenas_firmas') is null
	begin
		create table contrasenas_firmas(
			contrasena_firma_id int not null identity(1,1),
			contrasena_firma_valor nvarchar(1000) not nulL,
			firma_id_fk int not null unique,
			constraint pk_contrasena_firma primary key(contrasena_firma_id), /* llave primaria */
			constraint fk_firma_en_contrasena_firma foreign key(firma_id_fk) references firmas(firma_id) /* llave foranea */
		);
		print('Tabla CONTRASENA_FIRMAS creada'); 
	end

if OBJECT_ID('documentos_firmados') is null
	begin
		create table documentos_firmados (
			documento_firmado_id int not null identity(1,1),
			documento_firmado_ubicacion nvarchar(MAX) not null,
			documento_firmado_fecha datetime2 not null,
			firma_id_fk int not null,
			constraint pk_archivo primary key(documento_firmado_id), /* llave primaria */
			constraint fk_firma_en_archivos_firmados foreign key(firma_id_fk) references firmas(firma_id) /* llave foranea */
		);
		print('Tabla DOCUMENTOS_FIRMADOS creada');
	end

if OBJECT_ID('version_firmas') is null
	begin
		create table version_firmas (
			version_firma_id int not null identity(1,1),
			version_firma_nombre nvarchar(50) not null unique,
			version_firma_descripcion nvarchar(300) not null,
			constraint pk_version_firma primary key(version_firma_id) /* llave primaria */
		)
	end

if OBJECT_ID('configuracion_firmas') is null
	begin
		create table configuracion_firmas (
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
			constraint fk_firma_en_configuracion_firma foreign key(firma_id_fk) references firmas(firma_id), /* llave foranea */
			constraint fk_version_firma foreign key(version_firma_id_fk) references version_firmas(version_firma_id), /* llave foranea */
		);
		print('Tabla CONFIGURACION_FIRMAS creada');
	end

/* REGISTROS NECESARIOS */
insert into roles(rol_nombre, rol_descripcion) values
	('ADMIN', '..'),
	('TECNICO', '..'),
	('SUPERVISOR', '..'),
	('NORMAL', '..');

insert into tipo_firmas(tipo_firma_nombre, tipo_firma_descripcion) values
	('MANUAL', '..'),
	('MASIVA', '..'),
	('EXTERNA', '..');

insert into tipos_correos(tipo_correo_nombre, tipo_correo_descripcion) values
	('BIENVENIDA', '..'),
	('CREACION_FIRMA', '..'),
	('REPORTES', '..');

insert into tipo_reportes(tipo_reporte_nombre, tipo_reporte_descripcion) values
	('COMPLETOS', 'Es el reporte más detallado en formato xlsx, se basa en la vista reporte_completo'),
	('DETALLADOS', 'Es el reporte con información meidanamente detallada en formato csv, se basa en la vista reporte_medio'),
	('BASICOS', 'Es el reporte más básico en formato csv, se basa en la vista reporte_basico');

insert into usuarios(usuario_nombre, usuario_nombre_real, rol_id_fk) values
	('user_firmas', 'user_firmas', 1),
	('soporte', 'soporte', 2);
go

insert into plantillas_correos(plantilla_correo_nombre, plantilla_correo_descripcion, plantilla_correo_contenido) values
	('correo de bienvenida', '', N'<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0"/><title>Bienvenido al Sistema de Firmas ACS</title></head><body style="margin:0; padding:0; background-color:#f0f4f8; font-family:"Segoe UI", Lucida Sans, sans-serif;"><table role="presentation" width="100%" cellspacing="0" cellpadding="0" border="0" style="background-color:#f0f4f8; padding: 32px 0;"><tr><td align="center"><table role="presentation" width="620" cellspacing="0" cellpadding="0" border="0" style="max-width:620px; width:100%; background-color:#ffffff;border-radius:12px; overflow:hidden;box-shadow: 0 4px 24px rgba(0,0,0,0.09);"><tr><td style="background:  #00a8c3; padding:0;"><table width="100%" cellspacing="0" cellpadding="0" border="0"><tr><td style="padding: 22px 28px; vertical-align:middle;"><img src="https://raw.githubusercontent.com/yepoxtrop/Dinamo/main/Back/Apis/Api_Js/src/settings/others/plantillaCorreo/src/img/Logo-mi.png" width="44" height="44" alt="Logo ACS" style="display:inline-block; vertical-align:middle; margin-right:12px;"/><span style="font-size:1.55rem; font-weight:700; color:#ffffff; vertical-align:middle; letter-spacing:0.03em;">FIRMAS DIGITALES</span></td><td align="right" style="padding: 22px 28px;"><span style="background:rgba(255,255,255,0.18); color:#ffffff; font-size:0.75rem; font-weight:600; padding:5px 12px; border-radius:20px; letter-spacing:0.06em; white-space:nowrap;">👋 BIENVENIDO</span></td></tr></table></td></tr><tr><td style="background:#0c2135; padding: 18px 28px;"><table width="100%" cellspacing="0" cellpadding="0" border="0"><tr><td><p style="margin:0; font-size:0.78rem; color:#00a8c3; letter-spacing:0.1em; text-transform:uppercase; font-weight:600;">Sistema de Firmas</p><p style="margin:4px 0 0; font-size:1.25rem; color:#ffffff; font-weight:700;">Bienvenido al Sistema ACS</p></td><td align="right" style="white-space:nowrap;"><p style="margin:0; font-size:0.78rem; color:#8ab4c2;">Acceso</p><p style="margin:4px 0 0; font-size:0.95rem; color:#ffffff; font-weight:600;">100% Legal ✓</p></td></tr></table></td></tr><tr><td style="padding: 30px 28px 10px;"><p style="margin:0; font-size:1rem; color:#1a2e3b;">Estimad@ <strong style="color:#0c2135;">[NOMBRE_REAL_USUARIO]</strong>,</p><p style="margin:14px 0 0; font-size:0.97rem; color:#3d5565; line-height:1.65;">Estás a un paso de firmar documentos de forma <strong>rápida, segura y 100% legal</strong>.Con nuestro aplicativo web, olvídate del papeleo: firma contratos, acuerdos y actas en cuestión de segundos, desde cualquier lugar.</p></td></tr><tr><td style="padding: 22px 28px 10px;"><table width="100%" cellspacing="0" cellpadding="0" border="0"><tr><td width="31%" style="background:#f5fbfd; border:1px solid #d0edf4; border-radius:10px; padding:16px 12px; text-align:center; vertical-align:top;"><p style="margin:0; font-size:1.6rem;">✍️</p><p style="margin:8px 0 0; font-size:0.76rem; color:#0c2135; font-weight:700; text-transform:uppercase; letter-spacing:0.05em;">Firma Digital</p><p style="margin:5px 0 0; font-size:0.78rem; color:#5a7a8a; line-height:1.4;">Con validez legal garantizada</p></td><td width="4%"></td><td width="31%" style="background:#f5fbfd; border:1px solid #d0edf4; border-radius:10px; padding:16px 12px; text-align:center; vertical-align:top;"><p style="margin:0; font-size:1.6rem;">🔍</p><p style="margin:8px 0 0; font-size:0.76rem; color:#0c2135; font-weight:700; text-transform:uppercase; letter-spacing:0.05em;">Validación</p><p style="margin:5px 0 0; font-size:0.78rem; color:#5a7a8a; line-height:1.4;">Autenticidad de firmas externas</p></td><td width="4%"></td><td width="31%" style="background:#f5fbfd; border:1px solid #d0edf4; border-radius:10px; padding:16px 12px; text-align:center; vertical-align:top;"><p style="margin:0; font-size:1.6rem;">📊</p><p style="margin:8px 0 0; font-size:0.76rem; color:#0c2135; font-weight:700; text-transform:uppercase; letter-spacing:0.05em;">Reportes</p><p style="margin:5px 0 0; font-size:0.78rem; color:#5a7a8a; line-height:1.4;">Sobre documentos validados</p></td></tr></table></td></tr><tr><td style="padding: 22px 28px 10px;"><p style="margin:0 0 12px; font-size:0.85rem; font-weight:700; color:#0c2135;text-transform:uppercase; letter-spacing:0.07em; border-bottom:2px solid #e8f4f8;padding-bottom:8px;">Nos caracterizamos por:</p><table width="100%" cellspacing="0" cellpadding="0" border="0"><tr><td style="padding:7px 0;"><table cellspacing="0" cellpadding="0" border="0"><tr><td style="width:26px; vertical-align:top; padding-top:2px;"><span style="color:#00a8c3; font-size:1rem;">✦</span></td><td style="font-size:0.9rem; color:#3d5565; line-height:1.5;">Crear tu <strong>firma digital</strong> con validez legal.</td></tr></table></td></tr><tr><td style="padding:7px 0;"><table cellspacing="0" cellpadding="0" border="0"><tr><td style="width:26px; vertical-align:top; padding-top:2px;"><span style="color:#00a8c3; font-size:1rem;">✦</span></td><td style="font-size:0.9rem; color:#3d5565; line-height:1.5;"><strong>Validar la autenticidad</strong> de documentos PDF con firmas externas.</td></tr></table></td></tr><tr><td style="padding:7px 0;"><table cellspacing="0" cellpadding="0" border="0"><tr><td style="width:26px; vertical-align:top; padding-top:2px;"><span style="color:#00a8c3; font-size:1rem;">✦</span></td><td style="font-size:0.9rem; color:#3d5565; line-height:1.5;"><strong>Firmar documentos PDF</strong> de manera segura y ágil.</td></tr></table></td></tr><tr><td style="padding:7px 0;"><table cellspacing="0" cellpadding="0" border="0"><tr><td style="width:26px; vertical-align:top; padding-top:2px;"><span style="color:#00a8c3; font-size:1rem;">✦</span></td><td style="font-size:0.9rem; color:#3d5565; line-height:1.5;"><strong>Generar reportes</strong> detallados sobre los documentos validados.</td></tr></table></td></tr></table></td></tr><tr><td style="padding: 24px 28px 10px; text-align:center;"><a href="https://aciel.co/" target="_blank" style="display:inline-block; background: #00a8c3;color:#ffffff; font-size:0.95rem; font-weight:700; text-decoration:none;padding:14px 36px; border-radius:8px; letter-spacing:0.04em;">Acceder al Sistema →</a><p style="margin:12px 0 0; font-size:0.78rem; color:#8a9fad;">Si el botón no funciona, copia y pega este enlace en tu navegador:<a href="https://aciel.co/" style="color:#00a8c3;">https://aciel.co/</a></p></td></tr><tr><td style="padding: 18px 28px 10px;"><table width="100%" cellspacing="0" cellpadding="0" border="0" style="background:#fff8f0; border-left:4px solid #e05a2b; border-radius:0 8px 8px 0;"><tr><td style="padding:13px 16px;"><p style="margin:0; font-size:0.82rem; color:#8a4020; font-weight:700;">🔒 Seguridad y privacidad</p><p style="margin:5px 0 0; font-size:0.82rem; color:#7a5030; line-height:1.5;">Tus documentos están protegidos bajo la normativa colombiana de firmaelectrónica. Nunca compartas tus credenciales de acceso con terceros.</p></td></tr></table></td></tr><tr><td style="padding: 22px 28px 28px;"><p style="margin:0; font-size:0.95rem; color:#3d5565; line-height:1.6;">Si tienes alguna duda o inconveniente para acceder al sistema, no dudes encontactarnos a través de los canales indicados a continuación.</p><ul><li style="margin:0; font-size:0.95rem; color:#3d5565; line-height:1.6;">Mesa de ayuda: <a href="https://helpdesk.acielcolombia.com:8080/" style="color:#00a8c3;">https://helpdesk.acielcolombia.com:8080/</a></li><li style="margin:0; font-size:0.95rem; color:#3d5565; line-height:1.6;">Teléfono de soporte técnico 1: <span style="color:#00a8c3;">+57 3173733028</span></li><li style="margin:0; font-size:0.95rem; color:#3d5565; line-height:1.6;">Teléfono de soporte técnico 2: <span style="color:#00a8c3;">+57 3182066802</span></li></ul><p style="margin:0; font-size:0.95rem; color:#3d5565; line-height:1.6;">Estaremos encantados de ayudarte.</p><p style="margin:16px 0 0; font-size:0.95rem; color:#0c2135; font-weight:700;">Cordialmente,<br/><span style="color:#00a8c3;">Firmas ACS</span></p></td></tr><tr><td style="padding: 0 28px;"><hr style="border:none; border-top:1px solid #e0edf2; margin:0;"/></td></tr><tr><td style="padding: 22px 28px;"><table width="100%" cellspacing="0" cellpadding="0" border="0"><tr><td style="vertical-align:top; padding-right:20px;border-right:1px solid #d0dde6; width:200px;"><a href="https://aciel.co/acielemailsig/acsiso900120152020.pdf" target="_blank" style="text-decoration:none;"><img src="https://raw.githubusercontent.com/yepoxtrop/Dinamo/main/Back/Apis/Api_Js/src/settings/others/plantillaCorreo/src/img/logo.png" width="170" alt="Logo Aciel" style="max-width:170px; display:block;"/></a></td><td style="vertical-align:top; padding-left:20px;"><table cellspacing="0" cellpadding="0" border="0"><tr><td style="padding:4px 0; vertical-align:middle;"><img src="https://raw.githubusercontent.com/yepoxtrop/Dinamo/main/Back/Apis/Api_Js/src/settings/others/plantillaCorreo/src/img/correo.png" width="12" height="12" alt="correo" style="display:inline-block; vertical-align:middle; margin-right:7px;"/><a href="mailto:firmas@acielcolombia.com" style="font-size:0.82rem; color:#00a8c3; text-decoration:none;">firmas@acielcolombia.com</a></td></tr><tr><td style="padding:4px 0; vertical-align:middle;"><img src="https://raw.githubusercontent.com/yepoxtrop/Dinamo/main/Back/Apis/Api_Js/src/settings/others/plantillaCorreo/src/img/telefono.png" width="12" height="12" alt="telefono" style="display:inline-block; vertical-align:middle; margin-right:7px;"/><a href="callto:+576012687585" style="font-size:0.82rem; color:#00a8c3; text-decoration:none;">+57 (601) 268-7585</a></td></tr><tr><td style="padding:4px 0; vertical-align:middle;"><img src="https://raw.githubusercontent.com/yepoxtrop/Dinamo/main/Back/Apis/Api_Js/src/settings/others/plantillaCorreo/src/img/direccion.png" width="12" height="12" alt="dirección" style="display:inline-block; vertical-align:middle; margin-right:7px;"/><span style="font-size:0.82rem; color:#00a8c3;">Calle 85A #28C11, Bogotá, Colombia</span></td></tr><tr><td style="padding:4px 0; vertical-align:middle;"><img src="https://raw.githubusercontent.com/yepoxtrop/Dinamo/main/Back/Apis/Api_Js/src/settings/others/plantillaCorreo/src/img/hipervinculo.png" width="12" height="12" alt="web" style="display:inline-block; vertical-align:middle; margin-right:7px;"/><a href="https://aciel.co/" target="_blank" style="font-size:0.82rem; color:#00a8c3; text-decoration:none;">https://aciel.co/</a></td></tr><tr><td style="padding-top:10px;"><a href="https://www.linkedin.com/company/acielcolombia/mycompany/" target="_blank" style="text-decoration:none; margin-right:6px;"><img src="https://raw.githubusercontent.com/yepoxtrop/Dinamo/main/Back/Apis/Api_Js/src/settings/others/plantillaCorreo/src/img/linkedin.png" width="22" height="22" alt="LinkedIn"/></a><a href="https://www.facebook.com/AcielColombia.S.A.S" target="_blank" style="text-decoration:none; margin-right:6px;"><img src="https://raw.githubusercontent.com/yepoxtrop/Dinamo/main/Back/Apis/Api_Js/src/settings/others/plantillaCorreo/src/img/facebook.png" width="22" height="22" alt="Facebook"/></a><a href="https://www.youtube.com/channel/UC2xTc4uxduvw0DXv670Sjcw" target="_blank" style="text-decoration:none;"><img src="https://raw.githubusercontent.com/yepoxtrop/Dinamo/main/Back/Apis/Api_Js/src/settings/others/plantillaCorreo/src/img/youtube.png" width="30" height="22" alt="YouTube"/></a></td></tr></table></td></tr></table></td></tr><tr><td style="border-top:1px solid #dde8ef; padding:0;"><img src="https://raw.githubusercontent.com/yepoxtrop/Dinamo/main/Back/Apis/Api_Js/src/settings/others/plantillaCorreo/src/img/descripcion.png" width="620" alt="Descripción Aciel" style="display:block; max-width:100%; height:auto;"/></td></tr><tr><td style="background:#f0f4f8; padding:14px 28px; border-radius:0 0 12px 12px;"><p style="margin:0; font-size:0.72rem; color:#8a9fad; text-align:center; line-height:1.5;">Este correo fue generado automáticamente por el Sistema de Firmas Digitales ACS.Por favor, no responda directamente a este mensaje.<br/>© 2026 Aciel Colombia S.A.S · Todos los derechos reservados.</p></td></tr></table></td></tr></table></body></html>'),
	('correo de reportes', '', N'<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0"/><title>Reporte de Firmas Digitales – ACS</title></head><body style="margin:0; padding:0; background-color:#f0f4f8; font-family:"Segoe UI", Lucida Sans, sans-serif;"><table role="presentation" width="100%" cellspacing="0" cellpadding="0" border="0" style="background-color:#f0f4f8; padding: 32px 0;"><tr><td align="center"><table role="presentation" width="620" cellspacing="0" cellpadding="0" border="0" style="max-width:620px; width:100%; background-color:#ffffff;border-radius:12px; overflow:hidden;box-shadow: 0 4px 24px rgba(0,0,0,0.09);"><tr><td style="background:  #00a8c3 ; padding: 0;"><table width="100%" cellspacing="0" cellpadding="0" border="0"><tr><td style="padding: 22px 28px; vertical-align:middle;"><img src="https://raw.githubusercontent.com/yepoxtrop/Dinamo/main/Back/Apis/Api_Js/src/settings/others/plantillaCorreo/src/img/Logo-mi.png" width="44" height="44" alt="Logo ACS" style="display:inline-block; vertical-align:middle; margin-right:12px;"/><span style="font-size:1.55rem; font-weight:700; color:#ffffff; vertical-align:middle; letter-spacing:0.03em;">FIRMAS DIGITALES</span></td><td align="right" style="padding: 22px 28px;"><span style="background:rgba(255,255,255,0.18); color:#ffffff; font-size:0.75rem; font-weight:600; padding:5px 12px; border-radius:20px; letter-spacing:0.06em; white-space:nowrap;">📊 REPORTE ADJUNTO</span></td></tr></table></td></tr><tr><td style="background:#0c2135; padding: 18px 28px;"><table width="100%" cellspacing="0" cellpadding="0" border="0"><tr><td><p style="margin:0; font-size:0.78rem; color:#00a8c3; letter-spacing:0.1em; text-transform:uppercase; font-weight:600;">Informe de Actividad</p><p style="margin:4px 0 0; font-size:1.25rem; color:#ffffff; font-weight:700;">Reporte de Firmas Digitales</p></td><td align="right" style="white-space:nowrap;"><p style="margin:0; font-size:0.78rem; color:#8ab4c2;">Período</p><p style="margin:4px 0 0; font-size:0.95rem; color:#ffffff; font-weight:600;">[MES / AÑO]</p></td></tr></table></td></tr><tr><td style="padding: 30px 28px 10px;"><p style="margin:0; font-size:1rem; color:#1a2e3b;">Estimad@ <strong style="color:#0c2135;">[NOMBRE_REAL_USUARIO]</strong>,</p><p style="margin:14px 0 0; font-size:0.97rem; color:#3d5565; line-height:1.65;">A continuación encontrará adjunto el reporte en formato <strong>Excel (.xlsx)</strong>con el resumen de actividad del sistema de <strong>Firmas Digitales ACS</strong>correspondiente al período <strong>[MES / AÑO]</strong>. Este informe ha sido generadoautomáticamente y refleja el estado actualizado de todos los documentos procesados.</p></td></tr><tr><td style="padding: 22px 28px 10px;"><table width="100%" cellspacing="0" cellpadding="0" border="0"><tr><td width="31%" style="background:#f5fbfd; border:1px solid #d0edf4; border-radius:10px; padding:16px 12px; text-align:center; vertical-align:top;"><p style="margin:0; font-size:1.8rem; font-weight:700; color:#00a8c3;">[##]</p><p style="margin:5px 0 0; font-size:0.76rem; color:#5a7a8a; font-weight:600; text-transform:uppercase; letter-spacing:0.05em;">Documentos<br/>Firmados</p></td><td width="4%"></td><td width="31%" style="background:#f5fbfd; border:1px solid #d0edf4; border-radius:10px; padding:16px 12px; text-align:center; vertical-align:top;"><p style="margin:0; font-size:1.8rem; font-weight:700; color:#0c2135;">[##]</p><p style="margin:5px 0 0; font-size:0.76rem; color:#5a7a8a; font-weight:600; text-transform:uppercase; letter-spacing:0.05em;">Documentos<br/>Validados</p></td><td width="4%"></td><td width="31%" style="background:#f5fbfd; border:1px solid #d0edf4; border-radius:10px; padding:16px 12px; text-align:center; vertical-align:top;"><p style="margin:0; font-size:1.8rem; font-weight:700; color:#e05a2b;">[##]</p><p style="margin:5px 0 0; font-size:0.76rem; color:#5a7a8a; font-weight:600; text-transform:uppercase; letter-spacing:0.05em;">Pendientes<br/>de Firma</p></td></tr></table></td></tr><tr><td style="padding: 22px 28px 10px;"><table width="100%" cellspacing="0" cellpadding="0" border="0" style="background:#f8fafb; border:1.5px dashed #b0d4de;border-radius:10px;"><tr><td style="padding:16px 18px; vertical-align:middle;"><table cellspacing="0" cellpadding="0" border="0"><tr><td style="vertical-align:middle;"><div style="width:40px; height:40px; background:#1d6f42;border-radius:8px; text-align:center; line-height:40px;font-size:1.2rem; color:#ffffff; font-weight:700;display:inline-block;">X</div></td><td style="padding-left:14px; vertical-align:middle;"><p style="margin:0; font-size:0.9rem; font-weight:700; color:#0c2135;">Reporte_Firmas_[MES]_[AÑO].xlsx</p><p style="margin:3px 0 0; font-size:0.78rem; color:#7a99a8;">Hoja de cálculo Excel · Generado automáticamente por el sistema ACS</p></td></tr></table></td><td align="right" style="padding:16px 18px; vertical-align:middle; white-space:nowrap;"><span style="font-size:0.75rem; color:#00a8c3; font-weight:600; background:#e6f7fb; padding:5px 11px; border-radius:20px;">📎 ADJUNTO</span></td></tr></table></td></tr><tr><td style="padding: 22px 28px 10px;"><p style="margin:0 0 12px; font-size:0.85rem; font-weight:700; color:#0c2135;text-transform:uppercase; letter-spacing:0.07em; border-bottom:2px solid #e8f4f8;padding-bottom:8px;">El reporte incluye:</p><table width="100%" cellspacing="0" cellpadding="0" border="0"><tr><td style="padding:6px 0;"><table cellspacing="0" cellpadding="0" border="0"><tr><td style="width:24px; vertical-align:top; padding-top:1px;"><span style="color:#00a8c3; font-size:1rem;">✦</span></td><td style="font-size:0.9rem; color:#3d5565; line-height:1.5;">Listado completo de documentos <strong>firmados y validados</strong>en el período.</td></tr></table></td></tr><tr><td style="padding:6px 0;"><table cellspacing="0" cellpadding="0" border="0"><tr><td style="width:24px; vertical-align:top; padding-top:1px;"><span style="color:#00a8c3; font-size:1rem;">✦</span></td><td style="font-size:0.9rem; color:#3d5565; line-height:1.5;">Estado de cada firma: <strong>aprobada, rechazada o pendiente</strong>.</td></tr></table></td></tr><tr><td style="padding:6px 0;"><table cellspacing="0" cellpadding="0" border="0"><tr><td style="width:24px; vertical-align:top; padding-top:1px;"><span style="color:#00a8c3; font-size:1rem;">✦</span></td><td style="font-size:0.9rem; color:#3d5565; line-height:1.5;">Datos del firmante: <strong>nombre, cédula, fecha y hora</strong> de firma.</td></tr></table></td></tr><tr><td style="padding:6px 0;"><table cellspacing="0" cellpadding="0" border="0"><tr><td style="width:24px; vertical-align:top; padding-top:1px;"><span style="color:#00a8c3; font-size:1rem;">✦</span></td><td style="font-size:0.9rem; color:#3d5565; line-height:1.5;">Resumen estadístico y <strong>gráfico de actividad</strong> mensual.</td></tr></table></td></tr></table></td></tr><tr><td style="padding: 18px 28px 10px;"><table width="100%" cellspacing="0" cellpadding="0" border="0" style="background:#fff8f0; border-left:4px solid #e05a2b; border-radius:0 8px 8px 0;"><tr><td style="padding:13px 16px;"><p style="margin:0; font-size:0.82rem; color:#8a4020; font-weight:700;">⚠ Confidencialidad</p><p style="margin:5px 0 0; font-size:0.82rem; color:#7a5030; line-height:1.5;">Este reporte contiene información confidencial. Por favor, no reenvíeeste correo a personas no autorizadas. El archivo está protegido con validezlegal bajo la normativa colombiana de firma electrónica.</p></td></tr></table></td></tr><tr><td style="padding: 22px 28px 28px;"><p style="margin:0; font-size:0.95rem; color:#3d5565; line-height:1.6;">Si tiene alguna inquietud sobre la información contenida en el reporte,no dude en contactarnos a través de los canales indicados a continuación.</p><p style="margin:16px 0 0; font-size:0.95rem; color:#0c2135; font-weight:700;">Cordialmente,<br/><span style="color:#00a8c3;">Firmas ACS</span></p></td></tr><tr><td style="padding: 0 28px;"><hr style="border:none; border-top:1px solid #e0edf2; margin:0;"/></td></tr><tr><td style="padding: 22px 28px;"><table width="100%" cellspacing="0" cellpadding="0" border="0"><tr><td style="vertical-align:top; padding-right:20px;border-right:1px solid #d0dde6; width:200px;"><a href="https://aciel.co/acielemailsig/acsiso900120152020.pdf" target="_blank" style="text-decoration:none;"><img src="https://raw.githubusercontent.com/yepoxtrop/Dinamo/main/Back/Apis/Api_Js/src/settings/others/plantillaCorreo/src/img/logo.png" width="170" alt="Logo Aciel" style="max-width:170px; display:block;"/></a></td><td style="vertical-align:top; padding-left:20px;"><table cellspacing="0" cellpadding="0" border="0"><tr><td style="padding:4px 0; vertical-align:middle;"><img src="https://raw.githubusercontent.com/yepoxtrop/Dinamo/main/Back/Apis/Api_Js/src/settings/others/plantillaCorreo/src/img/correo.png" width="12" height="12" alt="correo" style="display:inline-block; vertical-align:middle; margin-right:7px;"/><a href="mailto:firmas@acielcolombia.com" style="font-size:0.82rem; color:#00a8c3; text-decoration:none;">firmas@acielcolombia.com</a></td></tr><tr><td style="padding:4px 0; vertical-align:middle;"><img src="https://raw.githubusercontent.com/yepoxtrop/Dinamo/main/Back/Apis/Api_Js/src/settings/others/plantillaCorreo/src/img/telefono.png" width="12" height="12" alt="telefono" style="display:inline-block; vertical-align:middle; margin-right:7px;"/><a href="callto:+576012687585" style="font-size:0.82rem; color:#00a8c3; text-decoration:none;">+57 (601) 268-7585</a></td></tr><tr><td style="padding:4px 0; vertical-align:middle;"><img src="https://raw.githubusercontent.com/yepoxtrop/Dinamo/main/Back/Apis/Api_Js/src/settings/others/plantillaCorreo/src/img/direccion.png" width="12" height="12" alt="dirección" style="display:inline-block; vertical-align:middle; margin-right:7px;"/><span style="font-size:0.82rem; color:#00a8c3;">Calle 85A #28C11, Bogotá, Colombia</span></td></tr><tr><td style="padding:4px 0; vertical-align:middle;"><img src="https://raw.githubusercontent.com/yepoxtrop/Dinamo/main/Back/Apis/Api_Js/src/settings/others/plantillaCorreo/src/img/hipervinculo.png" width="12" height="12" alt="web" style="display:inline-block; vertical-align:middle; margin-right:7px;"/><a href="https://aciel.co/" target="_blank" style="font-size:0.82rem; color:#00a8c3; text-decoration:none;">https://aciel.co/</a></td></tr><tr><td style="padding-top:10px;"><a href="https://www.linkedin.com/company/acielcolombia/mycompany/" target="_blank" style="text-decoration:none; margin-right:6px;"><img src="https://raw.githubusercontent.com/yepoxtrop/Dinamo/main/Back/Apis/Api_Js/src/settings/others/plantillaCorreo/src/img/linkedin.png" width="22" height="22" alt="LinkedIn"/></a><a href="https://www.facebook.com/AcielColombia.S.A.S" target="_blank" style="text-decoration:none; margin-right:6px;"><img src="https://raw.githubusercontent.com/yepoxtrop/Dinamo/main/Back/Apis/Api_Js/src/settings/others/plantillaCorreo/src/img/facebook.png" width="22" height="22" alt="Facebook"/></a><a href="https://www.youtube.com/channel/UC2xTc4uxduvw0DXv670Sjcw" target="_blank" style="text-decoration:none;"><img src="https://raw.githubusercontent.com/yepoxtrop/Dinamo/main/Back/Apis/Api_Js/src/settings/others/plantillaCorreo/src/img/youtube.png" width="30" height="22" alt="YouTube"/></a></td></tr></table></td></tr></table></td></tr><tr><td style="border-top:1px solid #dde8ef; padding:0;"><img src="https://raw.githubusercontent.com/yepoxtrop/Dinamo/main/Back/Apis/Api_Js/src/settings/others/plantillaCorreo/src/img/descripcion.png" width="620" alt="Descripción Aciel" style="display:block; max-width:100%; height:auto;"/></td></tr><tr><td style="background:#f0f4f8; padding:14px 28px; border-radius:0 0 12px 12px;"><p style="margin:0; font-size:0.72rem; color:#8a9fad; text-align:center; line-height:1.5;">Este correo fue generado automáticamente por el Sistema de Firmas Digitales ACS.Por favor, no responda directamente a este mensaje.<br/>© 2026 Aciel Colombia S.A.S · Todos los derechos reservados.</p></td></tr></table></td></tr></table></body></html>'),
	('correo de certificados', '', N'<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0"/><title>Tu Firma Digital P12 – ACS</title></head><body style="margin:0; padding:0; background-color:#f0f4f8; font-family:"Segoe UI", Lucida Sans, sans-serif;"><table role="presentation" width="100%" cellspacing="0" cellpadding="0" border="0" style="background-color:#f0f4f8; padding: 32px 0;"><tr><td align="center"><table role="presentation" width="620" cellspacing="0" cellpadding="0" border="0" style="max-width:620px; width:100%; background-color:#ffffff;border-radius:12px; overflow:hidden;box-shadow: 0 4px 24px rgba(0,0,0,0.09);"><tr><td style="background-color:#00a8c3; padding:0;"><table width="100%" cellspacing="0" cellpadding="0" border="0"><tr><td style="padding: 24px 28px; vertical-align:middle;"><img src="https://raw.githubusercontent.com/yepoxtrop/Dinamo/main/Back/Apis/Api_Js/src/settings/others/plantillaCorreo/src/img/Logo-mi.png" width="44" height="44" alt="Logo ACS" style="display:inline-block; vertical-align:middle; margin-right:12px;"/><span style="font-size:1.55rem; font-weight:700; color:#ffffff; vertical-align:middle; letter-spacing:0.03em;">FIRMAS DIGITALES</span></td><td align="right" style="padding: 24px 28px;"><span style="background:rgba(255,255,255,0.22); color:#ffffff; font-size:0.75rem; font-weight:600; padding:5px 13px; border-radius:20px; letter-spacing:0.06em; white-space:nowrap;">🔐 CERTIFICADO P12</span></td></tr></table></td></tr><tr><td style="background:#0c2135; padding: 18px 28px;"><table width="100%" cellspacing="0" cellpadding="0" border="0"><tr><td><p style="margin:0; font-size:0.78rem; color:#00a8c3; letter-spacing:0.1em; text-transform:uppercase; font-weight:600;">Certificado de Firma Electrónica</p><p style="margin:4px 0 0; font-size:1.25rem; color:#ffffff; font-weight:700;">Tu firma digital está lista</p></td><td align="right" style="white-space:nowrap;"><p style="margin:0; font-size:0.78rem; color:#8ab4c2;">Formato</p><p style="margin:4px 0 0; font-size:0.95rem; color:#ffffff; font-weight:600;">PKCS#12 (.p12)</p></td></tr></table></td></tr><tr><td style="padding: 30px 28px 10px;"><p style="margin:0; font-size:1rem; color:#1a2e3b;">Estimad@ <strong style="color:#0c2135;">[NOMBRE_REAL_USUARIO]</strong>,</p><p style="margin:14px 0 0; font-size:0.97rem; color:#3d5565; line-height:1.65;">Tu <strong>certificado de firma digital</strong> ha sido generado exitosamente.Adjunto a este correo encontrarás el archivo <strong>.p12</strong> que contienetu identidad digital con validez legal bajo la normativa colombiana de firma electrónica.</p></td></tr><tr><td style="padding: 22px 28px 10px;"><table width="100%" cellspacing="0" cellpadding="0" border="0" style="background:#f5fbfd; border:1.5px solid #b0d4de;border-radius:10px;"><tr><td style="padding:18px 20px; vertical-align:middle;"><table cellspacing="0" cellpadding="0" border="0"><tr><td style="vertical-align:middle;"><div style="width:46px; height:46px; background:#0c2135;border-radius:10px; text-align:center; line-height:46px;font-size:0.75rem; color:#00a8c3; font-weight:800;letter-spacing:-0.02em; display:inline-block;">P12</div></td><td style="padding-left:14px; vertical-align:middle;"><p style="margin:0; font-size:0.92rem; font-weight:700; color:#0c2135;">Firma_Digital_[NOMBRE_USUARIO].p12</p><p style="margin:4px 0 0; font-size:0.78rem; color:#7a99a8;">Certificado PKCS#12 · Generado por el Sistema de Firmas ACS</p></td></tr></table></td><td align="right" style="padding:18px 20px; vertical-align:middle; white-space:nowrap;"><span style="font-size:0.75rem; color:#00a8c3; font-weight:600; background:#ddf1f7; padding:5px 11px; border-radius:20px;">📎 ADJUNTO</span></td></tr></table></td></tr><tr><td style="padding: 18px 28px 10px;"><p style="margin:0 0 10px; font-size:0.85rem; font-weight:700; color:#0c2135;text-transform:uppercase; letter-spacing:0.07em; border-bottom:2px solid #e8f4f8;padding-bottom:8px;">Credenciales de acceso</p><table width="100%" cellspacing="0" cellpadding="0" border="0"><tr><td style="padding: 14px 0;"><table width="100%" cellspacing="0" cellpadding="0" border="0" style="background: linear-gradient(180deg, #f8fcfe 0%, #edf6fa 100%);border:1px solid #c4e3ed; border-radius:10px;"><tr><td style="padding:16px 20px;"><p style="margin:0; font-size:0.75rem; color:#5a7a8a; text-transform:uppercase; letter-spacing:0.08em; font-weight:600;">🔑 &nbsp;Contraseña del archivo P12</p><p style="margin:10px 0 0; font-size:1.45rem; font-weight:800; color:#0c2135; letter-spacing:0.12em; font-family: "Courier New", Courier, monospace; background:#ffffff; border:1.5px dashed #b0d4de; border-radius:8px; padding:10px 16px; display:inline-block;">[CONTRASEÑA_GENERADA]</p><p style="margin:10px 0 0; font-size:0.78rem; color:#7a99a8; line-height:1.5;">Usa esta contraseña cada vez que importes o uses tu certificadoen aplicaciones externas.</p></td></tr></table></td></tr></table></td></tr><tr><td style="padding: 10px 28px 10px;"><p style="margin:0 0 12px; font-size:0.85rem; font-weight:700; color:#0c2135;text-transform:uppercase; letter-spacing:0.07em; border-bottom:2px solid #e8f4f8;padding-bottom:8px;">¿Cómo usar tu certificado?</p><table width="100%" cellspacing="0" cellpadding="0" border="0"><tr><td style="padding:6px 0;"><table cellspacing="0" cellpadding="0" border="0"><tr><td style="width:28px; vertical-align:top; padding-top:2px;"><span style="background:#00a8c3; color:#fff; font-size:0.68rem; font-weight:700; border-radius:50%; width:18px; height:18px; display:inline-block; text-align:center; line-height:18px;">1</span></td><td style="font-size:0.9rem; color:#3d5565; line-height:1.5; padding-left:4px;">Descarga el archivo <strong>Firma_Digital_[NOMBRE_USUARIO].p12</strong>adjunto en este correo.</td></tr></table></td></tr><tr><td style="padding:6px 0;"><table cellspacing="0" cellpadding="0" border="0"><tr><td style="width:28px; vertical-align:top; padding-top:2px;"><span style="background:#00a8c3; color:#fff; font-size:0.68rem; font-weight:700; border-radius:50%; width:18px; height:18px; display:inline-block; text-align:center; line-height:18px;">2</span></td><td style="font-size:0.9rem; color:#3d5565; line-height:1.5; padding-left:4px;">Ingresa al <strong>Sistema de Firmas ACS</strong> y carga el archivoen tu perfil.</td></tr></table></td></tr><tr><td style="padding:6px 0;"><table cellspacing="0" cellpadding="0" border="0"><tr><td style="width:28px; vertical-align:top; padding-top:2px;"><span style="background:#00a8c3; color:#fff; font-size:0.68rem; font-weight:700; border-radius:50%; width:18px; height:18px; display:inline-block; text-align:center; line-height:18px;">3</span></td><td style="font-size:0.9rem; color:#3d5565; line-height:1.5; padding-left:4px;">Ingresa la <strong>contraseña</strong> indicada arriba cuando el sistemala solicite.</td></tr></table></td></tr><tr><td style="padding:6px 0;"><table cellspacing="0" cellpadding="0" border="0"><tr><td style="width:28px; vertical-align:top; padding-top:2px;"><span style="background:#00a8c3; color:#fff; font-size:0.68rem; font-weight:700; border-radius:50%; width:18px; height:18px; display:inline-block; text-align:center; line-height:18px;">4</span></td><td style="font-size:0.9rem; color:#3d5565; line-height:1.5; padding-left:4px;">¡Listo! Ya puedes <strong>firmar documentos PDF</strong> con validezlegal desde el sistema.</td></tr></table></td></tr></table></td></tr><tr><td style="padding: 18px 28px 10px;"><table width="100%" cellspacing="0" cellpadding="0" border="0" style="background:#fff8f0; border-left:4px solid #e05a2b; border-radius:0 8px 8px 0;"><tr><td style="padding:13px 16px;"><p style="margin:0; font-size:0.82rem; color:#8a4020; font-weight:700;">⚠ Importante — Guarda tu certificado de forma segura</p><p style="margin:5px 0 0; font-size:0.82rem; color:#7a5030; line-height:1.5;">Este archivo P12 y su contraseña representan tu <strong>identidad digital</strong>.No compartas este correo, el archivo ni la contraseña con ninguna persona.Si crees que tu certificado ha sido comprometido, contáctanos de inmediatopara revocarlo y generar uno nuevo.</p></td></tr></table></td></tr><tr><td style="padding: 24px 28px 28px; text-align:center;"><a href="https://aciel.co/" target="_blank" style="display:inline-block; background-color:#00a8c3;color:#ffffff; font-size:0.95rem; font-weight:700; text-decoration:none;padding:14px 36px; border-radius:8px; letter-spacing:0.04em;">Ir al Sistema de Firmas →</a><p style="margin:12px 0 0; font-size:0.78rem; color:#8a9fad;">O ingresa directamente en:<a href="https://aciel.co/" style="color:#00a8c3;">https://aciel.co/</a></p></td></tr><tr><td style="padding: 0 28px;"><hr style="border:none; border-top:1px solid #e0edf2; margin:0;"/></td></tr><tr><td style="padding: 22px 28px;"><table width="100%" cellspacing="0" cellpadding="0" border="0"><tr><td style="vertical-align:top; padding-right:20px;border-right:1px solid #d0dde6; width:200px;"><a href="https://aciel.co/acielemailsig/acsiso900120152020.pdf" target="_blank" style="text-decoration:none;"><img src="https://raw.githubusercontent.com/yepoxtrop/Dinamo/main/Back/Apis/Api_Js/src/settings/others/plantillaCorreo/src/img/logo.png" width="170" alt="Logo Aciel" style="max-width:170px; display:block;"/></a></td><td style="vertical-align:top; padding-left:20px;"><table cellspacing="0" cellpadding="0" border="0"><tr><td style="padding:4px 0; vertical-align:middle;"><img src="https://raw.githubusercontent.com/yepoxtrop/Dinamo/main/Back/Apis/Api_Js/src/settings/others/plantillaCorreo/src/img/correo.png" width="12" height="12" alt="correo" style="display:inline-block; vertical-align:middle; margin-right:7px;"/><a href="mailto:firmas@acielcolombia.com" style="font-size:0.82rem; color:#00a8c3; text-decoration:none;">firmas@acielcolombia.com</a></td></tr><tr><td style="padding:4px 0; vertical-align:middle;"><img src="https://raw.githubusercontent.com/yepoxtrop/Dinamo/main/Back/Apis/Api_Js/src/settings/others/plantillaCorreo/src/img/telefono.png" width="12" height="12" alt="telefono" style="display:inline-block; vertical-align:middle; margin-right:7px;"/><a href="callto:+576012687585" style="font-size:0.82rem; color:#00a8c3; text-decoration:none;">+57 (601) 268-7585</a></td></tr><tr><td style="padding:4px 0; vertical-align:middle;"><img src="https://raw.githubusercontent.com/yepoxtrop/Dinamo/main/Back/Apis/Api_Js/src/settings/others/plantillaCorreo/src/img/direccion.png" width="12" height="12" alt="dirección" style="display:inline-block; vertical-align:middle; margin-right:7px;"/><span style="font-size:0.82rem; color:#00a8c3;">Calle 85A #28C11, Bogotá, Colombia</span></td></tr><tr><td style="padding:4px 0; vertical-align:middle;"><img src="https://raw.githubusercontent.com/yepoxtrop/Dinamo/main/Back/Apis/Api_Js/src/settings/others/plantillaCorreo/src/img/hipervinculo.png" width="12" height="12" alt="web" style="display:inline-block; vertical-align:middle; margin-right:7px;"/><a href="https://aciel.co/" target="_blank" style="font-size:0.82rem; color:#00a8c3; text-decoration:none;">https://aciel.co/</a></td></tr><tr><td style="padding-top:10px;"><a href="https://www.linkedin.com/company/acielcolombia/mycompany/" target="_blank" style="text-decoration:none; margin-right:6px;"><img src="https://raw.githubusercontent.com/yepoxtrop/Dinamo/main/Back/Apis/Api_Js/src/settings/others/plantillaCorreo/src/img/linkedin.png" width="22" height="22" alt="LinkedIn"/></a><a href="https://www.facebook.com/AcielColombia.S.A.S" target="_blank" style="text-decoration:none; margin-right:6px;"><img src="https://raw.githubusercontent.com/yepoxtrop/Dinamo/main/Back/Apis/Api_Js/src/settings/others/plantillaCorreo/src/img/facebook.png" width="22" height="22" alt="Facebook"/></a><a href="https://www.youtube.com/channel/UC2xTc4uxduvw0DXv670Sjcw" target="_blank" style="text-decoration:none;"><img src="https://raw.githubusercontent.com/yepoxtrop/Dinamo/main/Back/Apis/Api_Js/src/settings/others/plantillaCorreo/src/img/youtube.png" width="30" height="22" alt="YouTube"/></a></td></tr></table></td></tr></table></td></tr><tr><td style="border-top:1px solid #dde8ef; padding:0;"><img src="https://raw.githubusercontent.com/yepoxtrop/Dinamo/main/Back/Apis/Api_Js/src/settings/others/plantillaCorreo/src/img/descripcion.png" width="620" alt="Descripción Aciel" style="display:block; max-width:100%; height:auto;"/></td></tr><tr><td style="background:#f0f4f8; padding:14px 28px; border-radius:0 0 12px 12px;"><p style="margin:0; font-size:0.72rem; color:#8a9fad; text-align:center; line-height:1.5;">Este correo fue generado automáticamente por el Sistema de Firmas Digitales ACS.Por favor, no responda directamente a este mensaje.<br/>© 2026 Aciel Colombia S.A.S · Todos los derechos reservados.</p></td></tr></table></td></tr></table></body></html>')
go