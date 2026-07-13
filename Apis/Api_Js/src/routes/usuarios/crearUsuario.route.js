import express from "express";
import { compararTokenAuthController } from "../../controllers/inicioSesion/compararTokenAuth.controller.js";

const router = express.Router();

router.post("/Usuario/Comparar_Token_Auth", compararTokenAuthController);


export default router;