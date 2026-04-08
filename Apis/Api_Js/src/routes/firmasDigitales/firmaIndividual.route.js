/* Librerias */
import express from "express";

/* Controladores y midlewares */
import { firmaIndividualController } from "../../controllers/firmasDigitales/firmaIndividual.controller.js";
import { consultarFirmaController } from "../../controllers/firmasDigitales/consultarFirma.controller.js";
import { descargarFirmaController } from "../../controllers/firmasDigitales/descargarFirma.controller.js";
import { midlewareTokens } from "../../middlewares/midlewareTokens.js";

let router = express.Router();

router.post("/Firma_Individual", midlewareTokens, firmaIndividualController);
router.get("/Descargar_Firma", midlewareTokens, descargarFirmaController);
router.get("/Consultar_Firma", midlewareTokens, consultarFirmaController);

export default router;