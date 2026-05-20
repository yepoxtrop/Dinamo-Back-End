import express from "express";
import { crearUsuarioManualController } from "../../controllers/inicioSesion/crearUsuarioManual.controller.js";

const router = express.Router();

router.post("/Usuario/Crear_Usuario", crearUsuarioManualController);

export default router;