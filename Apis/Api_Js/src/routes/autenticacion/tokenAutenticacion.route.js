import express from "express";
import { crearCodigoAutenticacionController } from "../../controllers/atenticacion/nuevoTokenAuth.controller.js";

const router = express.Router();

router.post("/Autenticacion/Codigo_Autenticacion_Nuevo", crearCodigoAutenticacionController);
export default router;