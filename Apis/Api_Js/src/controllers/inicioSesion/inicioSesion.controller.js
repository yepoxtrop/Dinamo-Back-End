
/* Modilos usados */
import { sesion } from "../../modules/baseDatos/prisma/procedimientos/sesiones.js";
import { insertarToken } from "../../modules/baseDatos/prisma/consultas/tokens.js";
/* dominio */
import { validarUsuarioDominio } from "../../modules/dominio/validarUsuarioDominio.js";
import { consultadrUsuarioDominio } from "../../modules/dominio/consultarUsuarioDominio.js";
/* base de datos */
/* tokens */
import { crearToken } from "../../modules/tokens/crearToken.js";
import { cookieMaxAge, cookieDomain, cookieSecure, cookieSameSite } from "../../settings/tokens/variablesToken.js";


/**
 * Controlador para gestionar el inicio de sesión de los usuarios del sistema.
 * @author Luis Angel Sarmiento Diaz
 * @param {Request} request - Objeto de solicitud HTTP que contiene las credenciales del usuario en el body.
 * @param {Response} response - Objeto de respuesta HTTP utilizado para enviar la respuesta al cliente.
 * @description Este controlador maneja el inicio de sesión de los usuarios. Realiza los siguientes pasos:
 * 1. Valida las credenciales del usuario contra el dominio LDAP/AD.
 * 2. Si la validación falla, consulta los detalles del usuario en el dominio.
 * 3. Ejecuta el procedimiento almacenado para registrar la sesión en la base de datos.
 * 4. Crea un token JWT con la información del usuario.
 * 5. Inserta el token en la base de datos.
 * 6. Configura una cookie segura con el token.
 * 7. Envía una respuesta JSON con el mensaje de éxito y el token.
 * @returns {JSON} - Devuelve una respuesta JSON con un mensaje de acceso exitoso y el token generado.
 * @throws {Error} - Lanza un error si ocurre un problema durante la validación, consulta o inserción.
 */

export const inicioSesionController = async (request, response) => {
    try {
        const datos = request.body;

        const loginDominio = await validarUsuarioDominio(datos);


        if (loginDominio === undefined) {
            let consulta =  await consultadrUsuarioDominio(datos);



            let procedimientoSesion = await sesion({
                nombre_dominio_usuario: consulta[0].sAMAccountName,
                nombre_real_usuario: consulta[0].cn,
                fecha: datos.fecha ? new Date(datos.fecha) : new Date(),
                dispositivo: request.headers['user-agent']
            });

            let token = await crearToken({
                usuarioId: procedimientoSesion[0]["id_usuario"],
                usuarioIdRol: procedimientoSesion[0]["id_rol"],
                usuarioNombre: datos.usuario,
                usuarioNombreCompleto: consulta[0].cn,
                usuarioCedula: consulta[0].telephoneNumber
            })

            let procedimientoToken = await insertarToken({
                usuarioId: procedimientoSesion[0]["id_usuario"],
                tokenValor: token
            })

            // Configurar cookie con las opciones del .env
            const cookieOptions = {
                httpOnly: true, // Previene acceso desde JavaScript (XSS)
                secure: cookieSecure, // Solo HTTPS en producción
                sameSite: cookieSameSite, // Protección CSRF
                maxAge: cookieMaxAge, // Tiempo de expiración en milisegundos
            };

            // Agregar dominio solo si está configurado
            if (cookieDomain) {
                cookieOptions.domain = cookieDomain;
            }

            response.cookie("token", token, cookieOptions)

            response.status(200).json({
                "Mensaje":"Acceso existoso",
                "Token":token
            })
        }else{
            response.status(401).json({
                "Mensaje":"Error de autenticacion en el dominio",
            })
        }
    } catch (error) {
        console.log(error)
        response.status(500).json({
            "Mensaje":"Error interno del servidor",
        })
    }
}