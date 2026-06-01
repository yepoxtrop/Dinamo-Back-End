import clientePrisma from "../../../../settings/prisma/clientePrisma.js";

export async function crearUsuarioManual({username, email, password, tokenAuth, pais}){

    /* Validacion de datos */
    if (username == null || email == null || password == null || tokenAuth == null || pais == null){
        throw new Error("Alguno de los datos esta vacio para el usp_crear_usuario_base");
    }

    const fecha =  new Date();
    
    try { 

        /* Ejecución de procedimiento */
        const consulta = await clientePrisma.$queryRaw`exec 
        usp_crear_usuario_base
            @nombreUsuario = ${username},
            @correoElectronico = ${email},
            @contrasena = ${password},
            @codigoAutenticacion = ${tokenAuth},
            @pais = ${pais},
            @fecha = ${fecha}
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

export async function crearNuevoTokenAuth({email, tokenAuth}) {
    try {
        /* Validacion de datos */
        if (email == null || tokenAuth == null){
            throw new Error("Alguno de los datos esta vacio para el usp_nuevo_codigo_auth");
        }

        /* Ejecución de procedimiento */
        const consulta = await clientePrisma.$queryRaw`exec 
        usp_nuevo_codigo_auth
            @correoElectronico = ${email},
            @codigoAutenticacion = ${tokenAuth}
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