import clientePrisma from "../../../../settings/prisma/clientePrisma.js";

export async function uspCrearUsuarioBase({usuario, email, contrasena, tokenAutenticacion, pais, region, fecha, dispositivo}) {

    /* Validacion de datos */
    if (usuario == null || email == null || contrasena == null || tokenAutenticacion == null || pais == null || region == null || fecha == null || dispositivo == null){
        throw new Error("Alguno de los datos esta vacio para el usp_crear_usuario_base");
    }
    
    try { 
        const query = await clientePrisma.usuarios.findMany()
        console.log(query)
       return true;
    } catch (error) {
        console.log(error)
        return false;
    }
}

uspCrearUsuarioBase({
    usuario: "el_sapo_rico",
    email: "pruebas.neo2006@gmail.com",
    contrasena: "123x456789",
    tokenAutenticacion: "123456",
    pais: "COLOMBIA",
    region: "BOGOTA",
    fecha: "2026-01-25T19:12:03.788Z",
    dispositivo: "Android",
})
.then((resultado) => {
    console.log(resultado)
})
.catch((error) => {
    console.log(error)
})