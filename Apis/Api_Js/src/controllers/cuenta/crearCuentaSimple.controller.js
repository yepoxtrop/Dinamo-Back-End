/* Utilidades */
import { estadoObjetoKeys, estadoObjetoNull } from "../../../utils/estadoObjeto.js";

/* Modulos */
import { crearTokenAuth } from "../../modules/tokens/auth/crearTokenAuth.js";
import { uspCrearUsuarioBase } from "../../modules/baseDatos/queryRaw/procedimientos/uspCrearUsuarioSimple.js";
import { ipGeolocalizacion } from "../../../services/ip/ipGeolocalizacion.js";
import {cifrarContrasena} from "../../modules/tokens/auth/cifrarContrasena.js";

export const crearCuentaSimpleController = async (request, response) =>{
    try {
        
        /* Datos de la peticion - Informacion del usuario */
        const datos = request.body;

        /* Validacion de datos */
        if (estadoObjetoNull(datos) === false || estadoObjetoKeys(["usuario", "email", "contrasena", "condiciones", "fecha", "ip"], datos) === false) 
            {
            return response.status(400).json({
                "mensaje": "Datos incompletos o inválidos"
            });
        }

        /* Asignar información del dispositivo */
        datos["dispositivo"] =  request.headers['user-agent'];

        /* Obtener direccion ip */
        const headers = request.headers;
        const remoteAddress = request.socket.remoteAddress;
        const ipAdress =  datos["ip"];

        /* Token para correo */
        const tokenCorreo = crearTokenAuth();

        /* Cifrar contraseña */
        const contrasenaCifrada = cifrarContrasena(datos["contrasena"]);

        /* Geolocalizar direccion ip */
        const datosIp = await ipGeolocalizacion(ipAdress);

        const objetoBaseDatos = {
            usuario: datos["usuario"],
            email: datos["email"],
            contrasena: contrasenaCifrada,
            tokenAutenticacion: tokenCorreo,
            pais: datosIp?.location?.country || "NA",
            region: datosIp?.location?.city || "NA",
            fecha: datos["fecha"],
            dispositivo: datos["dispositivo"],
        }

        /* Peticion a base de datos */
        const peticionUsp = await uspCrearUsuarioBase(objetoBaseDatos);

        /* Si todo sale bien responde con un mensae de exito */
        response.status(200).json({
            "Mensaje": "Datos recibidos",
        })

    } catch (error) {
        console.log(error);
        response.status(500).json({
            "mensaje": "Error interno del servidor"
        });
    }
} 








