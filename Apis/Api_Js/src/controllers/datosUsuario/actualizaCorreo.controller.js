/* Modulos */
import { actualizarCorreo } from "../../modules/baseDatos/prisma/consultas/correos.js";
import { decodificarToken } from "../../modules/tokens/decodificarToken.js";

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