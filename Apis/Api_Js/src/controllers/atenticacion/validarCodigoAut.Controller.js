export const validarCodigoAutenticacionController = async (request, response) =>{
    try{
        const data = request.body;

        
    }catch (error) {
        response.status(500).json({
            "Mensaje": "Error al validar el codigo de autenticacion",
        })
    }
}