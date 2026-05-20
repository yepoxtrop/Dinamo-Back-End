import crypto from "node:crypto";

export function crearTokenAuth(){
    try {
        let cadena = crypto.randomBytes(24);
        return cadena.toString('hex').slice(0,6);
    } catch (error) {

        console.log("Fallo en el modulo CrearTokensAuth en firmas-digitales-back/Apis/Api_Js/src/modules/tokens/auth/crearTokenAuth.js")
        
        let cadena = "";

        /* Ciclo para manejar cada caracter */
        for (let i = 1; i<=6; i++){

            /* Genera 1 o 0 para saber si es número o letra*/
            let tipo = Math.floor(Math.random() * (1-0+1));

            /* Si es 0 es numero de 0 a 9 */
            if (tipo==0){
                let numero = Math.floor(Math.random() * 10);
                cadena += numero;
            }
            
            /* Si es 1 es una letra de a a z */
            if (tipo ==1 ){

                /* Numero de 0 a 25 para generar letras */
                let numero = Math.floor(Math.random() * (25-0+1)+1);
                let caracter = String.fromCharCode(numero + 97);
                
                /* Si la posición es pa, se pone en mayus el caracter */
                if (i%2 == 0){
                    caracter = caracter.toLocaleUpperCase();
                }
                cadena += caracter;
            }
            
        }
        return cadena;
    }
}