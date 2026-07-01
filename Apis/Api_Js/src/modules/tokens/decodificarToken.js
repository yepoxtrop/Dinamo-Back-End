/**
 * Decodifica un token JWT para extraer su payload.
 * @author Luis Angel Sarmiento Diaz
 * @param {string} token - El token JWT a decodificar.
 * @description Esta función decodifica la parte payload de un token JWT sin verificar la firma.
 * Realiza los siguientes pasos:
 * 1. Valida que el token sea una cadena no vacía.
 * 2. Divide el token en sus partes (header, payload, signature).
 * 3. Decodifica la parte payload de base64url a JSON.
 * 4. Retorna el payload decodificado con información de estado.
 * @returns {Promise<Object>} - Devuelve un objeto con el mensaje, estado y resultado del payload decodificado,
 * o un objeto de error si la decodificación falla.
 * @throws {Error} - No lanza errores, sino que retorna un objeto con Estado: false en caso de fallo.
 */
export async function decodificarToken(token){
    try {
        if (!token || typeof token !== 'string') {
            throw new Error('Token invalido');
        }

        const parts = token.split('.');
        if (parts.length < 2) {
            throw new Error('Token invalido');
        }

        const base64Url = parts[1]
            .replace(/-/g, '+')
            .replace(/_/g, '/');
        const padded = base64Url.padEnd(
            base64Url.length + ((4 - (base64Url.length % 4)) % 4),
            '='
        );

        const payload = JSON.parse(Buffer.from(padded, 'base64').toString('utf8'));

        return {
            "Mensaje":"Token decodificado",
            "Estado":true,
            "Resultado":payload,
        } 
    
    } catch (error) {
        return {
            "Mensaje":"Fallo al decodificar el token",
            "Estado":false,
            "Error":error
        } 
    }
}