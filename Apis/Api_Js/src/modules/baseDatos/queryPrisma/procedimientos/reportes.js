import clientePrisma from "../../../../settings/prisma/clientePrisma.js";

/**
 * Genera un reporte básico mediante el procedimiento almacenado `usp_generar_reporte_basico`.
 *
 * @param {Object} params - Parámetros del reporte.
 * @param {number} params.idUsuario - Identificador del usuario que solicita el reporte.
 * @param {number} params.idPeticion - Identificador de la petición para la cual se genera el reporte.
 * @returns {Promise<any>} Resultado de la consulta (raw) retornada por Prisma.
 * @throws {Error} Si ocurre un error al ejecutar el procedimiento almacenado.
 */
export const reporteBasico = async ({idUsuario, idPeticion}) =>{
    try {
       const consulta = clientePrisma.$queryRaw`exec usp_generar_reporte_basico
        @idPeticion = ${idPeticion},
        @idUsuario = ${idUsuario}
       ` 
       return consulta;
    } catch (error) {
        throw new Error(`Error al ejecutar el usp_generar_reporte_basico:${error.message}`);
    }
}

/**
 * Genera un reporte medio mediante el procedimiento almacenado `usp_generar_reporte_medio`.
 *
 * @param {Object} params - Parámetros del reporte.
 * @param {number} params.idUsuario - Identificador del usuario que solicita el reporte.
 * @param {number} params.idPeticion - Identificador de la petición para la cual se genera el reporte.
 * @returns {Promise<any>} Resultado de la consulta (raw) retornada por Prisma.
 * @throws {Error} Si ocurre un error al ejecutar el procedimiento almacenado.
 */
export const reporteMedio = async ({idUsuario, idPeticion}) =>{
    try {
       const consulta = clientePrisma.$queryRaw`exec usp_generar_reporte_medio
        @idPeticion = ${idPeticion},
        @idUsuario = ${idUsuario}
       ` 
       return consulta;
    } catch (error) {
        throw new Error(`Error al ejecutar el usp_generar_reporte_medio:${error.message}`);
    }
}

/**
 * Genera un reporte completo mediante el procedimiento almacenado `usp_generar_reporte_completo`.
 *
 * @param {Object} params - Parámetros del reporte.
 * @param {number} params.idUsuario - Identificador del usuario que solicita el reporte.
 * @param {number} params.idPeticion - Identificador de la petición para la cual se genera el reporte.
 * @returns {Promise<any>} Resultado de la consulta (raw) retornada por Prisma.
 * @throws {Error} Si ocurre un error al ejecutar el procedimiento almacenado.
 */
export const reporteCompleto = async ({idUsuario, idPeticion}) =>{
    try {
       const consulta = clientePrisma.$queryRaw`exec usp_generar_reporte_completo
        @idPeticion = ${idPeticion},
        @idUsuario = ${idUsuario}
       ` 
       return consulta;
    } catch (error) {
        throw new Error(`Error al ejecutar el usp_generar_reporte_completo:${error.message}`);
    }
}

export const insertarReportes = async ({idPeticion, fechaReporte, ubicacionReporte, tipoReporte}) =>{
    try {
       const consulta = clientePrisma.$queryRaw`exec usp_insertar_reportes
        @idPeticion = ${idPeticion},
        @fechaReporte = ${fechaReporte},
        @ubicacionReporte = ${ubicacionReporte},
        @tipoReporte = ${tipoReporte}
       ` 
       return consulta;
    } catch (error) {
        throw new Error(`Error al ejecutar el usp_generar_reporte_completo:${error.message}`);
    }
} 