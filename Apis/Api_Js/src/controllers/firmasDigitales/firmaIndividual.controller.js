/* Modilos usados */
import { insertarFirma } from "../../modules/baseDatos/prisma/procedimientos/firmas.js";
/* tokens */
import { decodificarToken } from "../../modules/tokens/decodificarToken.js";
/* carpetas y archivos */
import { buscarFirmas } from "../../modules/firmasDigitales/carpetas/buscarFirmas.js";
import { creacionArchivosFirmas } from "../../modules/firmasDigitales/archivos/creacion/crearArchivosFirmas.js";


/**
 * Controlador para gestionar la creación de firmas digitales individuales.
 * @author Luis Angel Sarmiento Diaz
 * @param {Request} request - Objeto de solicitud HTTP que contiene los datos necesarios para crear la firma en el body.
 * @param {Response} response - Objeto de respuesta HTTP utilizado para enviar la respuesta al cliente.
 * @description Este controlador maneja la creación de firmas digitales individuales. Realiza los siguientes pasos:
 * 1. Decodifica el token de la cookie para obtener la información del usuario.
 * 2. Crea las rutas para los archivos de firma.
 * 3. Crea los archivos de firma (.pub, .crt, .p12, etc.).
 * 4. Inserta la firma, llave privada y contraseña en la base de datos.
 * 5. Envía un correo con la firma adjunta (pendiente de implementación).
 * 6. Envía el archivo .p12 como respuesta de descarga.
 * @returns {File} - Devuelve el archivo .p12 como descarga adjunta.
 * @throws {Error} - Lanza un error si ocurre un problema durante la decodificación, creación de archivos o inserción en la base de datos.
 */

export const firmaIndividualController = async (request, response) => {

    const datos = request.body;

    const cookieToken = request.cookies.token; 
    const infoToken = await decodificarToken(cookieToken);

    const nombreDominioUsuario = infoToken.Resultado["nombreUsuario"];
    const nombreRealUsuario = infoToken.Resultado["nombreCompletoUsuario"];

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

        /* Insertar Firma, llave privada y contraseña en la base de datos */
        await insertarFirma({
            nombreUsuario: nombreDominioUsuario,
            contarsenaFirma: datos.contrasena,
            llavePrivada: peticionArchivos.llave_privada,
            ubicacionPub: peticionRutaFirmas.rutaArchivoPub,
            ubicacionCrt: peticionRutaFirmas.rutaArchivoCrt,
            ubicacionP12: peticionRutaFirmas.rutaArchivoP12,
            fechaCreacion: peticionArchivos.fecha_creacion,
            fechaVencimiento: peticionArchivos.fecha_vencimiento,
            tipoFirma: 1
        });

        /* Enviar correo con firma anexa */

        /* Respuesta con la firma digital */
        return response.sendFile(
            peticionRutaFirmas.rutaArchivoP12, 
            {
                headers: {
                    'Content-Disposition': `attachment; filename="${datos.cedula}.p12"`,
                    'Content-Type': 'application/x-pkcs12'
                }
            },
            (error) => {
                console.log(error);
                if (error) {
                    console.error("Error al enviar archivo:", error);
                    return response.status(500).json({
                        Mensaje: "Error al enviar el archivo de firma",
                        Estado: false
                    });
                }
            }
        );

    } catch(error){
        console.log(error);
        return response.status(500).json({
            "Mensaje": "Error al crear la firma digital",
            "Estado": false
        });

    }

    
}