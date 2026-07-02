/*
========================================================================================================================
	FECHA CREACION: 2026/07/02
	AUTOR         : LUIS ANGEL SARMIENTO DIAZ
	DETALLE       : Script que ejecuta todos los scripts de Dinamo
========================================================================================================================
*/

:r "C:\Users\luis.sarmiento\Desktop\Proyectos\Dinamo\Dinamo-Back-End\Base_Datos\SQL Server\Objetos\Vistas\vistasReportes.sql";
go

:r "C:\Users\luis.sarmiento\Desktop\Proyectos\Dinamo\Dinamo-Back-End\Base_Datos\SQL Server\Objetos\Procedimientos\correoElectrónico\usp_enviar_correos.sql";
go

:r "C:\Users\luis.sarmiento\Desktop\Proyectos\Dinamo\Dinamo-Back-End\Base_Datos\SQL Server\Objetos\Procedimientos\logs\usp_insertar_logs.sql";
go

:r "C:\Users\luis.sarmiento\Desktop\Proyectos\Dinamo\Dinamo-Back-End\Base_Datos\SQL Server\Objetos\Procedimientos\insertarTokens.sql";
go

:r "C:\Users\luis.sarmiento\Desktop\Proyectos\Dinamo\Dinamo-Back-End\Base_Datos\SQL Server\Objetos\Procedimientos\usp_insertar_llaves_privadas.sql";
go


:r "C:\Users\luis.sarmiento\Desktop\Proyectos\Dinamo\Dinamo-Back-End\Base_Datos\SQL Server\Objetos\Procedimientos\usp_reportes_firmas.sql";
go