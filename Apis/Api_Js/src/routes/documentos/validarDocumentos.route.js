/* Librerias */
import express from "express";

/* Controladores y midlewares */
import { validarDocumentosController } from "../../controllers/documentos/validarDocumentos.controller.js";
import { midlewareTokens } from "../../middlewares/midlewareTokens.js";
import { midlewareArchivos } from "../../middlewares/midlwareArchivos.js";
import { midlewareRevisionArchivos } from "../../middlewares/midlwareRevisionArchivos.js";

let router = express.Router();

router.post("/Validar_Documentos", midlewareTokens, midlewareRevisionArchivos.array('documento', 200) ,validarDocumentosController);

export default router;