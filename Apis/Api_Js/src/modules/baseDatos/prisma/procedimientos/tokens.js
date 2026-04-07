import clientePrisma from "../../../../settings/prisma/clientePrisma.js";

export const insertarToken = async({usuarioId, tokenValor}) => {

    try {
        const consulta = clientePrisma.tokens.create({
            data: {
                token_valor: tokenValor,
                usuario_id_fk: usuarioId
            }
        });         
        
        return consulta;

    } catch (error) {
        throw new Error(`Error al ejecutar el usp_insertar_token:${error.message} `);
    }
}



/**
 * Elimina un token específico de la base de datos
 * @param {string} tokenValor - El valor del token a eliminar
 * @returns {Promise<Object>} - El token eliminado
 */
export const eliminarToken = async ({tokenValor}) => {
    try {
        const consulta = await clientePrisma.tokens.deleteMany({
            where: {
                token_valor: tokenValor
            }
        });

        return consulta; 
    } catch (error) {
        throw new Error(`Error al eliminar el token: ${error.message}`);    
    }
}

/**
 * Elimina todos los tokens de un usuario específico
 * @param {number} usuarioId - ID del usuario
 * @returns {Promise<Object>} - Los tokens eliminados
 */
export const eliminarTodosTokensUsuario = async ({usuarioId}) => {
    try {
        const consulta = await clientePrisma.tokens.deleteMany({
            where: {
                usuario_id_fk: usuarioId
            }
        });

        return consulta; 
    } catch (error) {
        throw new Error(`Error al eliminar los tokens del usuario: ${error.message}`);    
    }
}
