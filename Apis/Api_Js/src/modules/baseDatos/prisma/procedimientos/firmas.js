import clientePrisma from "../../../../settings/prisma/clientePrisma.js";

/**
 * Inserta una firma digital en la base de datos mediante el procedimiento almacenado `usp_insertar_firma`.
 * @author Luis Angel Sarmiento Diaz
 * @param {Object} params - Parámetros necesarios para insertar la firma.
 * @param {string} params.nombreUsuario - Nombre de usuario del dominio que crea la firma.
 * @param {string} params.contarsenaFirma - Contraseña de la firma digital.
 * @param {string} params.llavePrivada - Contenido de la llave privada asociada a la firma.
 * @param {string} params.ubicacionPub - Ruta del archivo .pub generado.
 * @param {string} params.ubicacionCrt - Ruta del archivo .crt generado.
 * @param {string} params.ubicacionP12 - Ruta del archivo .p12 generado.
 * @param {Date|string} params.fechaCreacion - Fecha de creación de la firma.
 * @param {Date|string} params.fechaVencimiento - Fecha de vencimiento de la firma.
 * @param {number} params.tipoFirma - Identificador numérico del tipo de firma.
 * @description Ejecuta el procedimiento almacenado para registrar los datos de la firma digital
 * en la base de datos. Si ocurre un error, lanza una excepción con información detallada.
 * @returns {Promise<void>} - Resuelve cuando la operación se completa correctamente.
 * @throws {Error} - Si el procedimiento almacenado falla o la consulta no se puede ejecutar.
 */
export const insertarFirma = async ({nombreUsuario, contarsenaFirma, llavePrivada, ubicacionPub, ubicacionCrt, ubicacionP12, fechaCreacion, fechaVencimiento, tipoFirma}) =>{

    try {
       const consulta = await clientePrisma.$queryRaw`exec usp_insertar_firma
        @nombre_usuario	= ${nombreUsuario}, 
        @contrasena_firma =${contarsenaFirma},
        @llave_privada = ${llavePrivada}, 
        @ubicacion_pub = ${ubicacionPub},
        @ubicacion_crt = ${ubicacionCrt},
        @ubicacion_p12 = ${ubicacionP12},
        @fecha_creacion = ${fechaCreacion},
        @fecha_vencimiento = ${fechaVencimiento},
        @tipo_firma = ${tipoFirma}
       ` 

    } catch (error) {
        throw new Error(`Error al ejecutar el usp_insertar_firma:${error.message}`);
    }
}

/**
 * Consulta si un usuario tiene una firma digital registrada en la base de datos.
 * @author Luis Angel Sarmiento Diaz
 * @param {number|string} idUsuario - Identificador del usuario en la base de datos.
 * @description Ejecuta el procedimiento almacenado `usp_consultar_firma_usuario` para recuperar
 * la información de la firma digital asociada al usuario. Retorna el resultado de la consulta.
 * @returns {Promise<Array>} - Devuelve un arreglo con el resultado de la consulta del procedimiento almacenado.
 * @throws {Error} - Si la ejecución del procedimiento almacenado falla.
 */
export const consultarFirma = async(idUsuario) =>{
    try {
        
        const consulta = await clientePrisma.$queryRaw`exec usp_consultar_firma_usuario
            @id_usuario = ${idUsuario}
        `; 

        return consulta;
    } catch (error) {

        throw new Error(`Error al ejecutar el usp_consultar_firma_usuario:${error.message}`);
    }
}