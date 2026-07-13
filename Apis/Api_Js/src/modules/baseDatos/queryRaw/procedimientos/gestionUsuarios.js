import clientePrisma from "../../../../settings/prisma/clientePrisma.js";

export async function crearNuevotokenAutenticacion({email, tokenAutenticacion}) {
    try {
        /* Validacion de datos */
        if (email == null || tokenAutenticacion == null){
            throw new Error("Alguno de los datos esta vacio para el usp_nuevo_codigo_auth");
        }

        /* Ejecución de procedimiento */
        const consulta = await clientePrisma.$queryRaw`exec 
        usp_nuevo_codigo_auth
            @correoElectronico = ${email},
            @codigoAutenticacion = ${tokenAutenticacion}
        ` 
       return true;
        
    } catch (error) {
        if ( error?.meta?.driverAdapterError?.cause?.code == 50001 || error?.meta?.driverAdapterError?.cause?.code == 50002 || error?.meta?.driverAdapterError?.cause?.code == 50003 || error?.meta?.driverAdapterError?.cause?.code == 50004 ){
            throw new Error(`${error.meta.driverAdapterError.cause.message}`);
        }else{
            console.log(error)
            throw new Error(`Problemas para ejecutar el usp_nuevo_codigo_auth`);
        }
    }
}

export async function activarUsuario(params) {
    
}