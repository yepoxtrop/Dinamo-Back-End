/* Modulos usados */
import { decodificarToken } from "../../modules/tokens/decodificarToken.js";
import { consultarRutaFirma } from "../../modules/baseDatos/prisma/consultas/firmas.js";

/**
 * Controlador para descargar la firma digital del usuario autenticado.
 * @author Luis Angel Sarmiento Diaz
 * @param {Request} request - Objeto de solicitud HTTP que contiene la cookie con el token de sesión.
 * @param {Response} response - Objeto de respuesta HTTP utilizado para enviar la respuesta al cliente.
 * @description Este controlador realiza las siguientes operaciones:
 * 1. Decodifica el token almacenado en la cookie para obtener el id del usuario.
 * 2. Consulta en la base de datos la ruta del archivo de firma digital (.p12) asociada al usuario.
 * 3. Envía el archivo .p12 como descarga adjunta al cliente.
 * 4. Captura errores internos y devuelve un estado 500 en caso de fallo.
 * @returns {File} - Devuelve el archivo .p12 como descarga adjunta.
 * @throws {Error} - Lanza un error si ocurre un problema durante la decodificación del token, la consulta en la base de datos o el envío del archivo.
 */
export const descargarFirmaController = async (request, response) => {
    
    try {

        const cookieToken = request.cookies.token; 
        const infoToken = await decodificarToken(cookieToken);
        
        const idUsuario = infoToken.Resultado["idUsuario"];

        const consultaRuta = await consultarRutaFirma(idUsuario);

        /* Respuesta con la firma digital */
        return response.sendFile(
            consultaRuta["firma_p12"], 
            {
                headers: {
                    'Content-Disposition': `attachment; filename="FirmaDigital.p12"`,
                    'Content-Type': 'application/x-pkcs12'
                }
            },
            (error) => {
                if (error) {
                    console.error("Error al enviar archivo:", error);
                    return response.status(500).json({
                        Mensaje: "Error al enviar el archivo de firma",
                        Estado: false
                    });
                }
            }
        );

        
        
    } catch (error) {

        console.log(error);
        
        response.status(500).json({
            "Mensaje": "Error al consultar la firma digital",
            "Estado": false
        })
    }
}