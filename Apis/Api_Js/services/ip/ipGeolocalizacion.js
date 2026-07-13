import axios from "axios";

/**
 * Obtiene la información de geolocalización asociada a una dirección IP.
 *
 * Realiza una consulta al servicio ip.guide y devuelve la respuesta completa
 * de Axios con los datos de ubicación disponibles para la dirección indicada.
 *
 * @async
 * @function ipGeolocalizacion
 * @author Luis Angel Sarmiento Diaz
 * @param {string} ipAdress Dirección IP pública que se desea geolocalizar.
 * @returns {Promise<import("axios").AxiosResponse>} Respuesta de Axios con la
 * información de geolocalización en la propiedad `data`.
 * @throws {Error} Si no es posible consultar la información de la dirección IP.
 */
export async function ipGeolocalizacion(ipAdress) {
    try {
        const peticion = await axios.get(`https://ip.guide/${ipAdress}`);
        console.log(peticion.data);
        return peticion;
    } catch (error) {
        throw new Error("Error al rastrear la ip pública:"+error.message)
    }
}