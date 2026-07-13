import axios from "axios";

/**
 * Obtiene la dirección IP pública del cliente o del entorno donde se ejecuta.
 *
 * Realiza una consulta al servicio ipify y devuelve la respuesta completa de
 * Axios, cuya propiedad `data` contiene la dirección IP obtenida.
 *
 * @async
 * @function ipDireccion
 * @author Luis Angel Sarmiento Diaz
 * @returns {Promise<import("axios").AxiosResponse<{ip: string}>>} Respuesta de
 * Axios con la dirección IP pública en `data.ip`.
 * @throws {Error} Si no es posible consultar la dirección IP pública.
 */
export async function ipDireccion() {
    try {
        const peticion = await axios.get(`https://api.ipify.org/?format=json%27)`);
        console.log(peticion.data);
        return peticion;
    } catch (error) {
        throw new Error("Error al rastrear la ip pública:"+error.message)
    }
}