

export const crearCuentaSimpleController = async (request, response) =>{
    try {
        
        /* Datos de la peticion - Informacion del usuario */
        const datos = request.body;
        datos["dispositivo"] =  request.headers['user-agent'];

        response.status(200).json({
            "mensaje":"usuario recibido"
        })

    } catch (error) {
        
    }
} 