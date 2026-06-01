import express from "express";
import { crearUsuarioManualController } from "../../controllers/inicioSesion/crearUsuarioManual.controller.js";
import { crearNuevoTokenAuthController } from "../../controllers/inicioSesion/nuevoTokenAuth.controller.js";
import { compararTokenAuthController } from "../../controllers/inicioSesion/compararTokenAuth.controller.js";

const router = express.Router();

router.post("/Usuario/Crear_Usuario_Manual", crearUsuarioManualController);
router.post("/Usuario/Nuevo_Token_Auth", crearNuevoTokenAuthController);
router.post("/Usuario/Comparar_Token_Auth", compararTokenAuthController);


export default router;