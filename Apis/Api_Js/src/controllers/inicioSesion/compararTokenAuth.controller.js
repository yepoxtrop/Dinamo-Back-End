import { consultarTokenAuth } from "../../modules/baseDatos/prisma/consultas/gestionUsuarios.js"

export const compararTokenAuthController = async(request, response) =>{
    try {
        const data = request.body;

        /* Si alguno de los datos esta vacio, reporta error */
        if((data == null)||(data?.email == undefined || data?.email == null)||(data?.cadena == undefined || data?.cadena == null)){
            return response.status(403).json({
                "Mensaje": "Datos no recibidos",
            })
        }

        /* Se busca el token de atutenticacion del usuario */
        const consulta = await consultarTokenAuth({
            emailUsuario: data.email
        })

        if (consulta?.usuario_token_creacion == data.cadena ){

            

            response.status(200).json({
                "Mensaje":"Datos recibidos",
                "Resultado":consulta
            })
        }else{
            response.status(200).json({
                "Mensaje":"Datos recibidos",
                "Resultado":null
            })
        }
        
        
    } catch (error) {
        console.log(error)
        response.status(500).json({
            "Mensaje": "Error al comparar el token",
        })
    }
}