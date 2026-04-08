/*========================================================================================================================
FECHA CREACION: 2026/01/29
AUTOR         : LUIS ANGEL SARMIENTO DIAZ
DETALLE       : Controlador para hacer la creacion de firmas de forma masiva en a partir de un objeto con 
                objetos en su interior con la informacion de los usuario o con archivos csv y txt usando
                como delimitado el ";" y en caso de estos la primera fila no se tomara en cuenta.
Modulos       : Tokens, creacion de carpetas, creacion de archivos, procedimientos almacenados y 
                modulos de node
FECHA MODIFICACION: 2026/01/29
AUTOR MODIFICACION: LUIS ANGEL SARMIENTO DIAZ
MODIFICACION      : Se crea sp
========================================================================================================================*/

/* Modulos */
import { validarTipoArchivo } from "../../modules/firmasDigitales/carguesMasivos/validarTipoArchivo.js";
import { creacionArchivosFirmas } from "../../modules/firmasDigitales/archivos/creacion/crearArchivosFirmas.js";
import { buscarFirmas } from "../../modules/firmasDigitales/carpetas/buscarFirmas.js";

export const firmaMasivaController = async(request, response) =>{
    try {
        const archivo = request.file;
        const peticion =  await validarTipoArchivo({rutaArchivo: archivo.path.replaceAll("\\","/")});
        
        for (let [indice, valor] of peticion.entries()) {
            let peticionRutas = await buscarFirmas({
                nombre_usuario:valor.usuarioDominio,
                cedula:valor.cedula
            })

            let peticionCreacionArchivos = await creacionArchivosFirmas({
                nombre_usuario:valor.nombreCompleto, 
                fechaCreacion:new Date(),
                contrasena:"5oP0rteAci3l!",
                rutaArchivoPub:peticionRutas.rutaArchivoPub,
                rutaArchivoCrt:peticionRutas.rutaArchivoCrt,
                rutaArchivoP12:peticionRutas.rutaArchivoP12
            })

        }


        response.status(200).json({
            "Mensaje":"Archivo recibido"
        }); 
    } catch (error) {
        
        response.status(500).json({
            "Mensaje":"Un error dentro del servidor"
        })
    }
}