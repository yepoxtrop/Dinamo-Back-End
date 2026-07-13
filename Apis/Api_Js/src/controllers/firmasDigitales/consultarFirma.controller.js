/* Modulos usados */
import { consultarFirma } from "../../modules/baseDatos/queryRaw/procedimientos/firmas.js"
import { decodificarToken } from "../../modules/tokens/decodificarToken.js";

/**
 * Controlador para consultar la firma digital del usuario autenticado.
 * @author Luis Angel Sarmiento Diaz
 * @param {Request} request - Objeto de solicitud HTTP que contiene la cookie con el token de sesión.
 * @param {Response} response - Objeto de respuesta HTTP utilizado para enviar la respuesta al cliente.
 * @description Este controlador realiza las siguientes operaciones:
 * 1. Decodifica el token almacenado en la cookie para obtener el id del usuario.
 * 2. Consulta en la base de datos si existe una firma digital asociada al usuario.
 * 3. Retorna un mensaje de estado 200 si la firma existe.
 * 4. Retorna un mensaje de estado 404 si no se encuentra firma digital para el usuario.
 * 5. Captura errores internos y devuelve un estado 500 en caso de fallo.
 * @returns {JSON} - Devuelve un objeto JSON con el mensaje y el estado de la consulta.
 * @throws {Error} - Lanza un error si ocurre un problema durante la decodificación del token o la consulta en la base de datos.
 */
export const consultarFirmaController = async (request, response) => {
    
    try {

        const cookieToken = request.cookies.token; 
        const infoToken = await decodificarToken(cookieToken);
        
        const idUsuario = infoToken.Resultado["idUsuario"];

        const consulta = await consultarFirma(idUsuario);

        if (consulta[0]["id_firma"] === null){

            return response.status(404).json({
                "Mensaje": "No se encontró una firma digital para el usuario",
                "Estado": false, 
            })
        }else{

            return response.status(200).json({
                "Mensaje": "Firma digital encontrada",
                "Estado": true, 
            })
        }
        
    } catch (error) {
        
        response.status(500).json({
            "Mensaje": "Error al consultar la firma digital",
            "Estado": false
        })
    }
}