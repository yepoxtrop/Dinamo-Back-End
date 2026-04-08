/* ORM */
import pkg from '@prisma/client';
const {sql} = pkg;

//Conifguraciones creadas
import clientePrisma from "../../../settings/prisma/clientePrisma.js";
import { error } from 'node:console';

export const uspEnviarCorreos = async({cuerpoCorreo, destinatarios, tituloCorreo}) =>{
    try {
        let consulta = await clientePrisma.$queryRaw(
            sql`EXEC usp_enviar_correos @cuerpoCorreo = ${cuerpoCorreo}, 
                @destinatarios = ${destinatarios}, 
                @tituloCorrreo = ${tituloCorreo}`
        )
        
        return consulta; 
    } catch (error) {
        throw new Error("Error al ejecutar el usp:"+error.message)
    }
}