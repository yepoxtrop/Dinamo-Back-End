/*========================================================================================================================
FECHA CREACION: 2026/01/22
AUTOR         : LUIS ANGEL SARMIENTO DIAZ
DETALLE       : Controlador para la creacion de firmas digitales individuales, esto incluye ficheros
                .key, .pub, .csr, .crt, .p12, con su respectiva carpeta, y adicional con el
                envio de correos de notificacion al usuario y supervisor
Modulos       : Tokens, creacion de carpetas, creacion de archivos, procedimientos almacenados y 
                modulos de node
FECHA MODIFICACION: 2026/01/22
AUTOR MODIFICACION: LUIS ANGEL SARMIENTO DIAZ
MODIFICACION      : Se crea sp
========================================================================================================================*/

/* Modilos usados */
/* tokens */
import { decodificarToken } from "../../modules/tokens/decodificarToken.js";
/* carpetas y archivos */
import { buscarFirmas } from "../../modules/firmasDigitales/carpetas/buscarFirmas.js";
import { creacionArchivosFirmas } from "../../modules/firmasDigitales/archivos/creacion/crearArchivosFirmas.js";
import { correoUsuarioExito } from "../../modules/correo/correoUsuarioExito.js";
import { correoUsuarioFallo } from "../../modules/correo/correoUsuarioFallo.js";
import { correoSupervisor } from "../../modules/correo/correoSupervisor.js";


export const firmaIndividualController = async (request, response) => {

    const datos = request.body;

    const cookieToken = request.cookies.token; 
    const infoToken = await decodificarToken(cookieToken);

    const nombreDominioUsuario = infoToken.Resultado["nombreUsuario"];

    try{

        /* Crear Rutas para Ficheros */
        const peticionRutaFirmas = await buscarFirmas({ 
            nombre_usuario: datos.nombre_usuario, 
            cedula: datos.cedula 
        }); 

        /* Crear Ficheros */
        const peticionArchivos = await creacionArchivosFirmas({
            nombre_usuario: datos.nombre,
            fechaCreacion: datos.fechaCreacion,
            contrasena: datos.contrasena,
            rutaArchivoPub: peticionRutaFirmas.rutaArchivoPub,
            rutaArchivoCrt: peticionRutaFirmas.rutaArchivoCrt,
            rutaArchivoP12: peticionRutaFirmas.rutaArchivoP12
        });

        /* Insertar Firma en la base de datos */

        /* Insertar la llave privada en la base de datos */


        /* Enviar correo con firma anexa */


        return response.status(200).json({
            "Mensaje": "Firma digital creada exitosamente",
            "Estado": true
        });

    } catch(error){

        return response.status(500).json({
            "Mensaje": "Error al crear la firma digital",
            "Estado": false
        });

    }

    
}