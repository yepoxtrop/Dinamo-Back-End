import clientePrisma from "../../../../settings/prisma/clientePrisma.js";

export const sesion = async({nombre_dominio_usuario, nombre_real_usuario, fecha, dispositivo}) => {
    try {
        const consulta = clientePrisma.$queryRaw`exec usp_insertar_usuario
        @nombre_dominio_usuario = ${nombre_dominio_usuario},
        @nombre_real_usuario = ${nombre_real_usuario},
        @fecha_sesion = ${fecha},
        @dispositivo_sesion = ${dispositivo}
       ` 

       return consulta;

    } catch (error) {
        throw new Error(`Error al ejecutar el usp_insertar_usuario:${error.message} `);
    }
}