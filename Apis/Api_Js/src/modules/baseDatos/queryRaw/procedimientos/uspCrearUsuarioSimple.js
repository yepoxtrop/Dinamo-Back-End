import clientePrisma from "../../../../settings/prisma/clientePrisma.js";

export async function uspCrearUsuarioBase({usuario, email, contrasena, tokenAutenticacion, pais, region, fecha, dispositivo}) {

    /* Validacion de datos */
    if (usuario == null || email == null || contrasena == null || tokenAutenticacion == null || pais == null || region == null || fecha == null || dispositivo == null){
        throw new Error("Alguno de los datos esta vacio para el usp_crear_usuario_base");
    }
    
    try { 

        /* Ejecución de procedimiento */
        const consulta = await clientePrisma.$queryRaw`exec 
            usp_crear_usuario_base
                @nombreUsuario = ${usuario},
                @correoElectronico = ${email},
                @contrasena = ${contrasena},
                @codigoAutenticacion = ${tokenAutenticacion},
                @pais = ${pais},
                @region = ${region},
                @fecha = ${fecha},
                @dispositivo = ${dispositivo}
       ` 
       return true;
    } catch (error) {

        if ( error?.meta?.driverAdapterError?.cause?.code == 50002 ){
            throw new Error(`${error.meta.driverAdapterError.cause.message}`);
        }else{
            console.log(error)
            throw new Error(`Problemas para ejecutar el usp_crear_usuario_base`);
        }
    }
}