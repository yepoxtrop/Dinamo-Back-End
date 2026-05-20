import { crearTokenAuth } from "../../modules/tokens/auth/crearTokenAuth.js";
import { crearUsuarioManual } from "../../modules/baseDatos/prisma/procedimientos/gestionUsuarios.js";
import { ipDireccion } from "../../modules/apis/ipApi.js";

export const crearUsuarioManualController = async (request, response) => {
    try {
        const data = request.body;
        const headers = request.headers;
        const remoteAddress = request.socket.remoteAddress;1
        
        console.log(request.ip)
        const ipAdress =  
            request.headers['x-forwarded-for']?.split(',')[0] || 
            request.ip ||
            request.socket.remoteAddress;

        /* Token para correo */
        const tokenCorreo = crearTokenAuth();
        //const peticionApiIp = await ipDireccion(ipAdress)

        const peticionUsp = await crearUsuarioManual({
            username:data.username, 
            email:data.emailAdress, 
            password:data.contrsena, 
            tokenAuth:tokenCorreo,
            pais:"co"
        })
        console.log(peticionUsp)

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