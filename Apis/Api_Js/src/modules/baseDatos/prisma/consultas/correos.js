import clientePrisma from "../../../../settings/prisma/clientePrisma.js";

export const actualizarCorreo = async({usuarioId, correoNuevo}) =>{
    console.log(usuarioId, correoNuevo);
    
    try{

        const consulta = await clientePrisma.usuarios.update({
            where:{
                usuario_id: usuarioId
            },
            data:{
                usuario_correo: correoNuevo
            }
        })

    }catch(error){
        throw new Error(`Error al actualizar el correo del usuario: ${error.message}`);
    }
}