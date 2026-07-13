/* Libreria */
import express from "express";
/* Controladores */
import { crearCuentaSimpleController} from "../../controllers/cuenta/crearCuentaSimple.controller.js";
/* Middlewares */

let router = express.Router()

router.post("/Cuenta/Crear_Cuenta_Simple", crearCuentaSimpleController);
// router.post("/Cuenta/Crear_Cuenta_Google", /* Controlador para crear cuenta */);
// router.post("/Cuenta/Crear_Cuenta_Microsoft", /* Controlador para crear cuenta */);
// router.post("/Cuenta/Crear_Cuenta_Outlook", /* Controlador para crear cuenta */);

export default router;