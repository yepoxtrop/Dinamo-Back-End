
/* Módulos usados */
/* tokens */
import { validarToken } from "../../modules/tokens/validarToken.js";
import { decodificarToken } from "../../modules/tokens/decodificarToken.js";

export const dataSessionController = async (request, response) => {
    
    try {

        const cookieToken = request.cookies.token; 
        console.log(cookieToken)
        const infoToken = await decodificarToken(cookieToken);
        
        const datos = infoToken.Resultado;

        return response.status(200).json({
            "Mensaje": "Datos recuperados del token",
            "Estado": true, 
            "Datos": datos
        })
        
    } catch (error) {
        
        response.status(500).json({
            "Mensaje": "Error al consultar la firma digital",
            "Estado": false
        })
    }
}