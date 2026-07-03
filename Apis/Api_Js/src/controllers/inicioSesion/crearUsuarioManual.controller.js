import { crearTokenAuth } from "../../modules/tokens/auth/crearTokenAuth.js";
import { crearUsuarioManual } from "../../modules/baseDatos/queryRaw/procedimientos/gestionUsuarios.js";
import { ipDireccion } from "../../modules/apis/ipApi.js";
import { crifrarContrasena } from "../../modules/tokens/auth/modificarContrasena.js"

export const crearUsuarioManualController = async (request, response) => {
    try {
        const data = request.body;
        
        /* Si alguno de los datos esta vacio, reporta error */
        if((data == null)||((data?.username == undefined || data?.username == null)||(data?.email == undefined || data?.email == null)||(data?.password == undefined || data?.password == null))){
            return response.status(403).json({
                "Mensaje": "Datos no recibidos",
            })
        }

        console.log(data)

        /* Obtener direccion ip */
        const headers = request.headers;
        const remoteAddress = request.socket.remoteAddress;
        const ipAdress =  
            request.headers['x-forwarded-for']?.split(',')[0] || 
            request.ip ||
            request.socket.remoteAddress;

        /* Token para correo */
        const tokenCorreo = crearTokenAuth();

        /* Cifrar contraseña */
        const contrasenaCifrada = crifrarContrasena(data.password);

        /* Peticion a base de datos */
        const peticionUsp = await crearUsuarioManual({
            username:data.username, 
            email:data.email, 
            password:contrasenaCifrada, 
            tokenAuth:tokenCorreo,
            pais:"co"
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