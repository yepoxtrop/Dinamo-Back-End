/* Librerias */ 
import mime from "mime-types"; 

/* Modulos */
import fs from "fs/promises"; 
import { archivosTXT } from "./archivosTXT.js";

export const validarTipoArchivo = async ({rutaArchivo}) => {
    try {
        const consultaTipoArchivo = await mime.lookup(rutaArchivo);

        if (consultaTipoArchivo === "text/plain"){
            let peticionTXT = await archivosTXT({pathArchivo:rutaArchivo})
            return peticionTXT; 
        }else{
            throw new Error("Tipo de archivo invalido");
        }
    } catch (error) {
        throw new Error(`Error al identificar el tipo de archivo:${error.message}`);
    }
}