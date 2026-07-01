/* Librerias */
import express from "express";

/* Controladores y midlewares */
import { midlewareTokens } from "../../middlewares/midlewareTokens.js";
import { actualizarCorreoController } from "../../controllers/datosUsuario/actualizaCorreo.controller.js";

let router = express.Router();
router.post("/Actualizar_Correo", midlewareTokens ,actualizarCorreoController);

export default router;