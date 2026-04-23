//Librerias
import express from "express";

//Controladores
import { inicioSesionController } from "../../controllers/inicioSesion/inicioSesion.controller.js";
import { cerrarSesionController } from "../../controllers/inicioSesion/cerrarSesion.controller.js";
import { dataSessionController } from "../../controllers/inicioSesion/dataSesion.controller.js"
import {midlewareTokens } from "../../middlewares/midlewareTokens.js"

let router = express.Router();

router.post("/Inicio_Sesion", inicioSesionController);
router.post("/Cerrar_Sesion", cerrarSesionController);
router.get("/Datos_Sesion", midlewareTokens, dataSessionController);

export default router;