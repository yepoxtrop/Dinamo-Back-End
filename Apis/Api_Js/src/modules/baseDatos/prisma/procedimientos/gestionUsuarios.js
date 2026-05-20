import clientePrisma from "../../../../settings/prisma/clientePrisma.js";

export async function crearUsuarioManual({username, email, password, tokenAuth, pais}){
    try {
        const consulta = await clientePrisma.$queryRaw`exec 
        usp_crear_usuario_base
            @nombreUsuario = ${username},
            @correoElectronico = ${email},
            @contrasena = ${password},
            @codigoAutenticacion = ${tokenAuth},
            @pais = ${pais}
       ` 
       return consulta;
    } catch (error) {
        console.log(error)
        throw new Error(`Error al ejecutar el usp_insertar_peticiones:${error.message}`);
    }
}