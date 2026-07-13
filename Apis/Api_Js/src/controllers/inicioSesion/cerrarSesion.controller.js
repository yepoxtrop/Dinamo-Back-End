
/* Módulos usados */
/* tokens */
import { validarToken } from "../../modules/tokens/validarToken.js";
/* base de datos */
import { eliminarToken } from "../../modules/baseDatos/queryRaw/consultas/tokens.js";

/**
 * Controlador para gestionar el cierre de sesión de los usuarios del sistema.
 * @author David Claros / ASISTENTE
 * @param {Request} request - Objeto de solicitud HTTP que contiene el token en headers o cookies.
 * @param {Response} response - Objeto de respuesta HTTP utilizado para enviar la respuesta al cliente.
 * @description Este controlador maneja el cierre de sesión de los usuarios. Realiza los siguientes pasos:
 * 1. Obtiene el token desde el header Authorization o las cookies.
 * 2. Valida que el token existe.
 * 3. Valida y decodifica el token para asegurar su autenticidad.
 * 4. Elimina el token de la base de datos.
 * 5. Limpia la cookie del navegador.
 * 6. Envía una respuesta JSON confirmando el cierre de sesión.
 * @returns {JSON} - Devuelve una respuesta JSON con un mensaje de confirmación, estado y número de tokens eliminados.
 * @throws {Error} - Lanza un error si ocurre un problema durante la validación, eliminación o respuesta.
 */
export const cerrarSesionController = async (request, response) => {
    try {
        // Obtener el token del header Authorization o de las cookies
        const tokenFromHeader = request.headers.authorization?.replace('Bearer ', '');
        const tokenFromCookie = request.cookies?.token;
        const token = tokenFromHeader || tokenFromCookie;

        // Validar que existe un token
        if (!token) {
            return response.status(401).json({
                Mensaje: "No se encontró token de autenticación",
                Estado: false
            });
        }

        // Validar y decodificar el token
        const tokenValidado = await validarToken(token);

        if (!tokenValidado.Estado) {
            return response.status(401).json({
                Mensaje: "Token inválido o expirado",
                Estado: false
            });
        }

        // Eliminar el token de la base de datos
        const tokenEliminado = await eliminarToken({ tokenValor: token });

        // Limpiar la cookie
        response.clearCookie("token", {
            httpOnly: true,
            //secure: true  // Descomentar en producción con HTTPS
        });

        // Responder exitosamente
        response.status(200).json({
            Mensaje: "Sesión cerrada exitosamente",
            Estado: true,
            TokensEliminados: tokenEliminado.count
        });

    } catch (error) {
        console.error("Error al cerrar sesión:", error);
        response.status(500).json({
            Mensaje: "Error al cerrar sesión",
            Estado: false,
            Error: error.message
        });
    }
}
