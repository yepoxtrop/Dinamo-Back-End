import clientePrisma from "../../../../settings/prisma/clientePrisma.js";

/**
 * Actualiza el correo electrónico de un usuario en la base de datos.
 * @author Luis Angel Sarmiento Diaz
 * @param {Object} params - Parámetros para la actualización.
 * @param {number} params.usuarioId - ID del usuario cuyo correo se va a actualizar.
 * @param {string} params.correoNuevo - Nuevo correo electrónico del usuario.
 * @description Esta función actualiza el campo usuario_correo en la tabla usuarios de la base de datos
 * utilizando Prisma Client. Realiza una operación de actualización (update) en el registro del usuario
 * especificado por usuarioId.
 * @returns {Promise<Object>} - Devuelve el resultado de la operación de actualización de Prisma.
 * @throws {Error} - Lanza un error si ocurre un problema durante la actualización en la base de datos.
 */
export const actualizarCorreo = async({usuarioId, correoNuevo}) =>{
    console.log(usuarioId, correoNuevo);
    
    try{

        const consulta = await clientePrisma.usuarios.update({
            where:{
                usuario_id: usuarioId
            },
            data:{
                usuario_correo: correoNuevo
            }
        })

    }catch(error){
        throw new Error(`Error al actualizar el correo del usuario: ${error.message}`);
    }
}