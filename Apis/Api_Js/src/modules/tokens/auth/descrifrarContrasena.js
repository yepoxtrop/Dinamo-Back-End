import crypto from "node:crypto";
import { ENCRIPTADO_ALGORITMO, ENCRIPTADO_LLAVE_SECRETA, ENCRIPTADO_VECTOR_INICALIZACION } from "../../../settings/general/variables_generales.js";

/**
 * Descifra una contraseña previamente encriptada con los parámetros configurados.
 *
 * Autor: Luis Angel Sarmiento Diaz
 * @param {string} contrasena Contraseña encriptada en hexadecimal
 * @returns {string} Contraseña original en texto plano
 */
export function descifrarContrasena(contrasena){
    try {
        // Convertir la llave y el vector de inicialización desde hexadecimal a binario.
        const llaveBinaria = Buffer.from(ENCRIPTADO_LLAVE_SECRETA, 'hex');
        const vectorInicioBinario = Buffer.from(ENCRIPTADO_VECTOR_INICALIZACION, 'hex');

        // Crear el descifrador usando el mismo IV binario que se empleó para cifrar.
        const decipher = crypto.createDecipheriv(ENCRIPTADO_ALGORITMO, llaveBinaria, vectorInicioBinario);
        let descifrado = decipher.update(contrasena, 'hex', 'utf-8');
        descifrado += decipher.final('utf8');
        return descifrado;
    } catch (error) {
        throw new Error("Error al desencriptar la contrasena:"+error);
    }
}