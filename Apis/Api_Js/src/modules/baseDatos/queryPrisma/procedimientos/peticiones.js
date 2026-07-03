import clientePrisma from "../../../../settings/prisma/clientePrisma.js";

/**
 * Inserta un registro de petición en la base de datos mediante el procedimiento almacenado `usp_insertar_peticiones`.
 *
 * @param {Object} params - Parámetros de la petición.
 * @param {string|Date} params.peticionFecha - Fecha/hora de la petición.
 * @param {string} params.peticionNombre - Nombre descriptivo de la petición.
 * @param {number} params.idUsuario - Identificador del usuario que realiza la petición.
 * @returns {Promise<any>} Resultado de la consulta (raw) retornada por Prisma.
 * @throws {Error} Si ocurre un error al ejecutar el procedimiento almacenado.
 */
export const insertarPeticiones = async ({peticionFecha, peticionNombre, idUsuario}) =>{
    try {
       const consulta = clientePrisma.$queryRaw`exec usp_insertar_peticiones
        @idUsuario = ${idUsuario},
        @peticionFecha = ${peticionFecha},
        @peticionNombre = ${peticionNombre}
       ` 
       return consulta;
    } catch (error) {
        throw new Error(`Error al ejecutar el usp_insertar_peticiones:${error.message}`);
    }
}

/**
 * Inserta un registro de documento asociado a una petición mediante el procedimiento almacenado `usp_insertar_documentos`.
 *
 * @param {Object} params - Parámetros del documento.
 * @param {number} params.idPeticion - Identificador de la petición padre.
 * @param {string} params.documentoNombre - Nombre del documento.
 * @param {string} params.documentoUbicacion - Ruta o ubicación del documento.
 * @param {boolean} params.documentoEstado - Estado del documento (válido/inválido).
 * @param {string} params.documentoCausaEstado - Motivo del estado del documento.
 * @param {number} params.documentoTotalFirmas - Número total de firmas encontradas en el documento.
 * @param {number} params.documentoFirmasVencidas - Número de firmas vencidas en el documento.
 * @param {string} params.documentoTipo - Tipo de documento (por ejemplo, "PDF").
 * @returns {Promise<any>} Resultado de la consulta (raw) retornada por Prisma.
 * @throws {Error} Si ocurre un error al ejecutar el procedimiento almacenado.
 */
export const insertarDocumentos = async({
        idPeticion, 
        documentoNombre, 
        documentoUbicacion, 
        documentoEstado, 
        documentoCausaEstado, 
        documentoTotalFirmas, 
        documentoFirmasVencidas, 
        documentoTipo
    }) => {
    try {
        const consulta = clientePrisma.$queryRaw`exec usp_insertar_documentos
        @idPeticion = ${idPeticion},
        @documentoNombre = ${documentoNombre},
        @documentoUbicacion = ${documentoUbicacion},
        @documentoEstado = ${documentoEstado},
        @documentoCausaEstado = ${documentoCausaEstado},
        @documentoTotalFirmas = ${documentoTotalFirmas},
        @documentoFirmasVencidas = ${documentoFirmasVencidas},
        @documentoTipo = ${documentoTipo}
       ` 
       return consulta;
    } catch (error) {
        throw new Error(`Error al ejecutar el usp_insertar_documentos:${error.message}`);
    }
}

/**
 * Inserta registros de certificados asociados a un documento mediante el procedimiento almacenado `usp_insertar_certficiados`.
 *
 * @param {Object} params - Parámetros del certificado.
 * @param {number} params.idDocumento - Identificador del documento al que pertenece el certificado.
 * @param {number} params.certificadoNumero - Número secuencial de la firma dentro del documento.
 * @param {number} params.certificadoVersion - Versión del certificado.
 * @param {string} params.certificadoSerial - Número de serie del certificado.
 * @param {string} params.certificadoOid - OID de la firma (algoritmo de firma).
 * @param {string|Date} params.certificadoCreacion - Fecha de creación del certificado.
 * @param {string|Date} params.certificadoVencimiento - Fecha de vencimiento del certificado.
 * @param {boolean} params.certificadoEstado - Estado de validez del certificado.
 * @param {string} params.certificadoEditor - Emisor del certificado.
 * @param {string} params.certificadoSujeto - Sujeto del certificado.
 * @param {string} params.certificadoCausaEstado - Motivo del estado del certificado.
 * @param {string} params.certificadoUso - Indicación de uso del certificado.
 * @param {boolean} params.certificadoValidacionVencimientoEstado - Resultado de la validación de vencimiento.
 * @param {string} params.certificadoValidacionVencimientoDescripcion - Descripción de la validación de vencimiento.
 * @param {boolean} params.certificadoValidacionUsoEstado - Resultado de la validación de uso.
 * @param {string} params.certificadoValidacionUsoDescripcion - Descripción de la validación de uso.
 * @param {boolean} params.certificadoValidacionHashEstado - Resultado de la validación de hash.
 * @param {string} params.certificadoValidacionHashDescripcion - Descripción de la validación de hash.
 * @param {boolean} params.certificadoValidacionIntegridadEstado - Resultado de la validación de integridad.
 * @param {string} params.certificadoValidacionIntegridadDescripcion - Descripción de la validación de integridad.
 * @returns {Promise<boolean>} `true` si la inserción fue ejecutada correctamente.
 * @throws {Error} Si ocurre un error al ejecutar el procedimiento almacenado.
 */
export const insertarCertificados = async({
        certificadoNumero,						
        certificadoVersion,			
        certificadoSerial,			
        certificadoOid,				
        certificadoCreacion,						
        certificadoVencimiento,						
        certificadoEstado,							
        certificadoEditor,	
        certificadoSujeto,			
        certificadoCausaEstado,					
        certificadoUso,							
        certificadoValidacionVencimientoEstado,		
        certificadoValidacionVencimientoDescripcion, 
        certificadoValidacionUsoEstado,				
        certificadoValidacionUsoDescripcion,		 
        certificadoValidacionHashEstado,	
        certificadoValidacionHashDescripcion,		 
        certificadoValidacionIntegridadEstado,		
        certificadoValidacionIntegridadDescripcion,
        idDocumento
    }) => {
    try {
        const resultado = await clientePrisma.$queryRaw`exec usp_insertar_certficiados
        @idDocumento = ${idDocumento},
        @certificadoNumero = ${certificadoNumero},
        @certificadoVersion	= ${certificadoVersion},
        @certificadoSerial = ${certificadoSerial}, 
        @certificadoOid	= ${certificadoOid}, 
        @certificadoCreacion = ${certificadoCreacion}, 
        @certificadoVencimiento	= ${certificadoVencimiento}, 
        @certificadoEstado = ${certificadoEstado}, 
        @certificadoEditor = ${certificadoEditor}, 
        @certificadoSujeto = ${certificadoSujeto}, 
        @certificadoCausaEstado	= ${certificadoCausaEstado}, 
        @certificadoUso	= ${certificadoUso}, 
        @certificadoValidacionVencimientoEstado	= ${certificadoValidacionVencimientoEstado}, 
        @certificadoValidacionVencimientoDescripcion = ${certificadoValidacionVencimientoDescripcion}, 
        @certificadoValidacionUsoEstado = ${certificadoValidacionUsoEstado}, 
        @certificadoValidacionUsoDescripcion = ${certificadoValidacionUsoDescripcion}, 
        @certificadoValidacionHashEstado = ${certificadoValidacionHashEstado}, 
        @certificadoValidacionHashDescripcion = ${certificadoValidacionHashDescripcion}, 
        @certificadoValidacionIntegridadEstado = ${certificadoValidacionIntegridadEstado}, 
        @certificadoValidacionIntegridadDescripcion = ${certificadoValidacionIntegridadDescripcion};
       ` 
       return true;
    } catch (error) {
        throw new Error(`Error al ejecutar el usp_insertar_certficiados:${error.message}`);
    }
}

