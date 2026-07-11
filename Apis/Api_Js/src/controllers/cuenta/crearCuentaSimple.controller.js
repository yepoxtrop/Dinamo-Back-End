/* Utilidades */
import { estadoObjetoKeys, estadoObjetoNull } from "../../../utils/estadoObjeto.js";

/* Modulos */


export const crearCuentaSimpleController = async (request, response) =>{
    try {
        
        /* Datos de la peticion - Informacion del usuario */
        const datos = request.body;

        if (estadoObjetoNull(datos) === false || estadoObjetoKeys(["usuario", "email", "contrasena", "condiciones", "fecha", "ip"], datos) === false) 
            {
            return response.status(400).json({
                "mensaje": "Datos incompletos o inválidos"
            });
        }



        datos["dispositivo"] =  request.headers['user-agent'];

        response.status(200).json({
            "mensaje":"usuario recibido"
        })

    } catch (error) {
        
    }
} 