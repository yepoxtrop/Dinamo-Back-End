/* Configuracion De Variables De Entorno */
import { puerto } from "./src/settings/general/variables_generales.js";

/* Servidor */
import app from "./src/app.js";

/* Funciones de inicio */
import carpetasInciales from "./utils/carpetasIniciales.js";

async function main(puerto) {
    try {
        app.listen(puerto || 3000, ()=>{
            console.log('[ALERTA]:APLICACIÓN ARRIBA EN EL PUERTO 3000');
            /* Crear carpeta de documentos */
            carpetasInciales();
        })
    } catch (error) {

        throw new Error(`Error al iniciar el servidor: ${error.message}`);
    }
}

main(puerto); 