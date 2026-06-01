import crypto from "node:crypto";

/**
 * Crea un token de autenticación de 6 caracteres.
 *
 * Genera un token seguro a partir de bytes aleatorios. Si ocurre un error,
 * genera un token de respaldo compuesto por dígitos y letras alternadas.
 *
 * Autor: Luis Angel Sarmiento Diaz
 * @returns {string} Token de 6 caracteres
 */
export function crearTokenAuth(){
    try {
        let cadena = crypto.randomBytes(24);
        return cadena.toString('hex').slice(0,6);

    } catch (error) {

        let cadena = "";
        /* Ciclo para construir el token de respaldo carácter por carácter */
        for (let i = 1; i <= 6; i++){

            /* Genera 0 o 1 para elegir entre un dígito numérico o una letra */
            let tipo = Math.floor(Math.random() * (1 - 0 + 1));

            /* Si es 0, se agrega un dígito de 0 a 9 */
            if (tipo == 0){
                let numero = Math.floor(Math.random() * 10);
                cadena += numero;
            }

            /* Si es 1, se agrega una letra de a a z */
            if (tipo == 1) {
                /* Genera un valor de 0 a 25 para convertirlo en letra */
                let numero = Math.floor(Math.random() * (25 - 0 + 1) + 1);
                let caracter = String.fromCharCode(numero + 97);

                /* Convierte a mayúscula los caracteres en posiciones pares */
                if (i % 2 == 0){
                    caracter = caracter.toLocaleUpperCase();
                }
                cadena += caracter;
            }
        }
        return cadena;
    }
}