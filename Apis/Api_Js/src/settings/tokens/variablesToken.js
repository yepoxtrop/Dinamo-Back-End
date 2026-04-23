//Librerias Instaldas
import { config } from "dotenv";

config();

export const tokensLlavePrivada = process.env.TOKENS_LLAVE_PRIVADA;
export const tokensAlgoritmo = process.env.TOKENS_ALGORITMO;
export const tokensExpiraEn = process.env.TOKENS_EXPIRA_EN || "1h"; // Por defecto 1 hora
export const cookieMaxAge = parseInt(process.env.COOKIE_MAX_AGE) || 3600000; // Por defecto 1 hora en ms
export const cookieDomain = process.env.COOKIE_DOMAIN || "";
export const cookieSecure = process.env.COOKIE_SECURE === "true";
export const cookieSameSite = process.env.COOKIE_SAMESITE || "lax";