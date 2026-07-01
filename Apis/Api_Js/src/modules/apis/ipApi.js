import axios from "axios";

export async function ipDireccion(ipAdress=null) {
    try {
        const peticion = await axios.get(`https://ip.guide/127.0.0.1`);
        console.log(peticion.data);
        return peticion;
    } catch (error) {
        throw new Error("Error al rastrear la ip pública:"+error.message)
    }
}