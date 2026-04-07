/*========================================================================================================================
FECHA CREACION: 2026/01/25
AUTOR         : LUIS ANGEL SARMIENTO DIAZ
DETALLE       : Controlador para gestionar las sesiones de los usuarios del sistema, haciendo inserciones en la base 
                de datos en la tabla usuarios, sesiones y tokens, y si el usuario es nuevo se le envia un correo
                de bienvenida con un procedimiento de la base de datos
Modulos       : Consultas en el dominio, consultas en la base de datos y tokens
FECHA MODIFICACION: 2026/01/25
AUTOR MODIFICACION: LUIS ANGEL SARMIENTO DIAZ
MODIFICACION      : Se crea sp
========================================================================================================================*/

/* Modilos usados */
import { sesion } from "../../modules/baseDatos/prisma/procedimientos/sesiones.js";
import { insertarToken } from "../../modules/baseDatos/prisma/procedimientos/tokens.js";
/* dominio */
import { validarUsuarioDominio } from "../../modules/dominio/validarUsuarioDominio.js";
import { consultadrUsuarioDominio } from "../../modules/dominio/consultarUsuarioDominio.js";
/* base de datos */
/* tokens */
import { crearToken } from "../../modules/tokens/crearToken.js";
import { cookieMaxAge, cookieDomain, cookieSecure, cookieSameSite } from "../../settings/tokens/variablesToken.js";


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
        
        response.status(500).json({
            "Mensaje":"Error interno del servidor",
        })
    }
}