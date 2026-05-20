//Librerias
import express from "express"; 
import cors from "cors"; 
import cookieParser from 'cookie-parser';

//Rutas creadas
//--Inicio de Sesion
import rutaInicioSesion from "../src/routes/inicioSesion/inicioSesion.route.js";
import rutaDatosSesion from "../src/routes/inicioSesion/inicioSesion.route.js";
import rutaCrearUsuarioManual from "../src/routes/usuarios/crearUsuario.route.js";
//--Firmas
import rutaFirmaIndividual from "../src/routes/firmasDigitales/firmaIndividual.route.js";
import rutaFirmaMasiva from "../src/routes/firmasDigitales/firmaMasiva.route.js"; 
import rutaConsultarFirma from "../src/routes/firmasDigitales/firmaIndividual.route.js";
import rutaDescargarFirma from "../src/routes/firmasDigitales/firmaIndividual.route.js";
// --Documentos
import rutaFirmarDocumentos from "../src/routes/documentos/firmarDocumentos.route.js"
import rutaValidarDocumentos from "../src/routes/documentos/validarDocumentos.route.js"
// --Datos de Usuario
import rutaActualizarCorreo from "../src/routes/datosUsuario/datosUsuario.route.js";


const app = express(); 

/* Configuración de CORS */
app.use(express.json()) 
app.use(cors({
  origin: 'http://localhost:5173',
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  credentials: true
}));

app.use(cookieParser()); 
app.set('trust proxy', true);

/* rRutas */
app.use("/Dinamo_Js",rutaCrearUsuarioManual);
app.use("/Dinamo_Js",rutaInicioSesion);
app.use("/Dinamo_Js",rutaFirmaIndividual);
app.use("/Dinamo_Js",rutaFirmaMasiva);
app.use("/Dinamo_Js",rutaFirmarDocumentos);
app.use("/Dinamo_Js",rutaValidarDocumentos);
app.use("/Dinamo_Js",rutaActualizarCorreo);
app.use("/Dinamo_Js",rutaConsultarFirma);
app.use("/Dinamo_Js",rutaDescargarFirma);
app.use("/Dinamo_Js",rutaDatosSesion);

export default app;