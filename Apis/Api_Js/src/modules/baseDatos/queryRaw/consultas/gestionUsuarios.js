import clientePrisma from "../../../../settings/prisma/clientePrisma.js";

export async function consultarTokenAuth({emailUsuario}) {
    try {
        const consulta =  await clientePrisma.usuarios.findUnique({
            where:{
                usuario_email: emailUsuario
            }
        })        
        return consulta;
    } catch (error) {
        throw new Error(`Error al consultar la el token auth: ${error}`);
    }
}