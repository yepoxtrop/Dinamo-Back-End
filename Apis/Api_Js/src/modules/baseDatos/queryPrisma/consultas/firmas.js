import clientePrisma from "../../../../settings/prisma/clientePrisma.js";

/**
 * Consulta la ruta del archivo de firma digital (.p12) asociado a un usuario.
 * @author Luis Angel Sarmiento Diaz
 * @param {number|string} usuarioId - Identificador del usuario en la base de datos.
 * @description Realiza una consulta a la tabla 'firmas' para obtener la información de la firma digital
 * del usuario especificado. Utiliza Prisma para ejecutar la consulta de manera segura.
 * @returns {Promise<Object|null>} - Devuelve el objeto de la firma si existe, o null si no se encuentra.
 * @throws {Error} - Si ocurre un error durante la consulta en la base de datos.
 */
export const consultarRutaFirma = async(usuarioId) =>{
    
    try{

        const consulta = await clientePrisma.firmas.findUnique({
            where:{
                usuario_id_fk: usuarioId
            }
        })

        return consulta;

    }catch(error){

        throw new Error(`Error al consultar la ruta de la firma: ${error.message}`);
    }
}