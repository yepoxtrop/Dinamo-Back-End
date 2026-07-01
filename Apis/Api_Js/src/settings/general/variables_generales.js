/* Librerias */
import { config } from "dotenv"; 
config(); 

export const puerto = process.env.PUERTO; 
export const ENCRIPTADO_LLAVE_SECRETA = process.env.ENCRIPTADO_LLAVE_SECRETA;
export const ENCRIPTADO_ALGORITMO = process.env.ENCRIPTADO_ALGORITMO;
export const ENCRIPTADO_VECTOR_INICALIZACION = process.env.ENCRIPTADO_VECTOR_INICALIZACION;