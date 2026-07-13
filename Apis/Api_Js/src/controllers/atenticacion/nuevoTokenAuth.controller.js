import { crearTokenAuth } from "../../modules/tokens/auth/crearTokenAuth.js";
import { crearNuevotokenAutenticacion } from "../../modules/baseDatos/queryRaw/procedimientos/gestionUsuarios.js";

export const crearCodigoAutenticacionController = async (request, response) =>{
    try {
        const data = request.body;

        /* Si alguno de los datos esta vacio, reporta error */
        if((data == null)||(data?.email == undefined || data?.email == null)){
            return response.status(403).json({
                "Mensaje": "Datos no recibidos",
            })
        }

        /* Token para correo */
        const tokenCorreo = crearTokenAuth();

        /* Peticion a base de datos */
        const peticionUsp = await crearNuevoTokenAuth({
            email:data.email, 
            tokenAuth:tokenCorreo,
        })

        /* Si todo sale bien responde con un mensae de exito */
        response.status(200).json({
            "Mensaje": "Datos recibidos",
        })

    } catch (error) {
        console.log(error)
        response.status(500).json({
            "Mensaje": "Error al crear el usuario manual",
        })
    }
}