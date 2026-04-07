/*========================================================================================================================
FECHA CREACION: 2026/02/06
AUTOR         : David Claros / ASISTENTE
DETALLE       : Controlador para gestionar el cierre de sesión de los usuarios del sistema, eliminando tokens de la 
                base de datos y limpiando las cookies del navegador
Modulos       : Validación de tokens y eliminación de tokens de base de datos
FECHA MODIFICACION: 2026/02/06
AUTOR MODIFICACION: David Claros
MODIFICACION      : Se crea controller
========================================================================================================================*/

/* Módulos usados */
/* tokens */
import { validarToken } from "../../modules/tokens/validarToken.js";
/* base de datos */
import { eliminarToken } from "../../modules/baseDatos/prisma/procedimientos/tokens.js";

/**
 * Controlador para cerrar sesión
 * Elimina el token de la base de datos y limpia las cookies
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
