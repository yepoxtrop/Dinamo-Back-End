import crypto from "node:crypto";
import { ENCRIPTADO_ALGORITMO, ENCRIPTADO_LLAVE_SECRETA, ENCRIPTADO_VECTOR_INICALIZACION } from "../../../settings/general/variables_generales.js";

/**
 * Encripta una contraseña usando el algoritmo y parámetros configurados.
 *
 * Autor: Luis Angel Sarmiento Diaz
 * @param {string} contrasena Contraseña en texto plano
 * @returns {string} Contraseña encriptada en formato hexadecimal
 */
export function cifrarContrasena(contrasena){
    try {
        // Convertir la llave y el vector de inicialización desde hexadecimal a binario.
        const llaveBinaria = Buffer.from(ENCRIPTADO_LLAVE_SECRETA, 'hex');
        const vectorInicioBinario = Buffer.from(ENCRIPTADO_VECTOR_INICALIZACION, 'hex');

        // Crear el cifrador con el algoritmo, la clave y el vector de inicialización.
        const cipher = crypto.createCipheriv(ENCRIPTADO_ALGORITMO, llaveBinaria, vectorInicioBinario);
        let crifrado = cipher.update(contrasena, 'utf-8', 'hex');
        crifrado += cipher.final('hex');

        return crifrado;
    } catch (error) {
        throw new Error("Error al encriptar la contrasena:"+error);
    }
}

// console.log(crypto.randomBytes(32).toString('hex'));
// console.log(crypto.randomBytes(16).toString('hex'));
