/* Modulos */
import { actualizarCorreo } from "../../modules/baseDatos/queryRaw/consultas/correos.js";
import { decodificarToken } from "../../modules/tokens/decodificarToken.js";

/**
 * Controlador para actualizar el correo electrónico de un usuario.
 * @author Luis Angel Sarmiento Diaz
 * @param {Request} request - Objeto de solicitud HTTP que contiene el nuevo correo en el body y el token en cookies.
 * @param {Response} response - Objeto de respuesta HTTP utilizado para enviar la respuesta al cliente.
 * @description Este controlador maneja la actualización del correo electrónico de un usuario. Realiza los siguientes pasos:
 * 1. Extrae el nuevo correo del body de la solicitud.
 * 2. Decodifica el token de las cookies para obtener el ID del usuario.
 * 3. Llama al módulo actualizarCorreo para actualizar el correo en la base de datos.
 * 4. Envía una respuesta JSON confirmando la actualización exitosa.
 * @returns {JSON} - Devuelve una respuesta JSON con un mensaje de confirmación de actualización exitosa.
 * @throws {Error} - Lanza un error si ocurre un problema durante la decodificación del token o la actualización en BD.
 */
export const actualizarCorreoController = async (request, response) => {
    try {
    
        /* Capturar Correo */
        const datos = request.body;
        const cookieToken = request.cookies.token; 
        const infoToken = await decodificarToken(cookieToken);
        
        const idUsuario = infoToken.Resultado["idUsuario"];

        await actualizarCorreo({
            usuarioId: idUsuario,
            correoNuevo: datos.correoNuevo
        })

        response.status(200).json({
            "Mensaje": "Correo actualizado exitosamente"
        });

    } catch (error) {
        
        response.status(500).json({
            "Mensaje": `Error al actualizar el correo del usuario: ${error.message}`
        })
    }
}