/* Modulos */ 
import { analizarDocumentoPDF } from "../../modules/documentos/analizarDocumentosPDF/analizarDocumentoPDF.js";
import { reporteDetalladoCSV } from "../../modules/documentos/reportes/reportesCSV/reporteDetalladoCSV.js";
import { reporteBasicoCSV } from "../../modules/documentos/reportes/reportesCSV/reporteBasicoCSV.js";
import { reporteXLSX } from "../../modules/documentos/reportes/reportesXLSX/reporteXLSX.js";
import { insertarPeticiones, insertarDocumentos, insertarCertificados } from "../../modules/baseDatos/queryRaw/procedimientos/peticiones.js";
import { reporteBasico, reporteMedio, reporteCompleto, insertarReportes } from "../../modules/baseDatos/queryRaw/procedimientos/reportes.js";
import { decodificarToken } from "../../modules/tokens/decodificarToken.js";
import { nombrePeticionesPDF } from "../../modules/documentos/analizarDocumentosPDF/nombrePeticionesPDF.js";
import { crearCarpetaReportes } from "../../modules/documentos/reportes/crearCarpetaReportes.js";

/** 
 * Controlador que valida documentos PDF cargados y genera reportes.
 * @author Luis Angel Sarmiento Diaz
 * @param {Request} request - Objeto de solicitud HTTP que contiene los archivos PDF cargados y la cookie de token.
 * @param {Response} response - Objeto de respuesta HTTP utilizado para enviar la respuesta al cliente.
 * @description Este controlador maneja la validación de documentos PDF cargados por el cliente. Realiza los siguientes pasos:
 * 1. Decodifica el token de la cookie para obtener información del usuario.
 * 2. Genera nombres únicos para la petición y rutas para los reportes.
 * 3. Analiza los documentos PDF utilizando el módulo analizarDocumentoPDF.
 * 4. Inserta la petición, documentos y certificados en la base de datos.
 * 5. Genera reportes en formato CSV (básico y detallado) y XLSX (completo).
 * 6. Envía una respuesta JSON con el resultado del análisis.
 * @returns {JSON} - Devuelve una respuesta JSON con un mensaje de confirmación y los resultados del análisis de los documentos PDF.
 * @throws {Error} - Lanza un error si ocurre un problema durante el análisis, inserción en BD o generación de reportes.
 */

export const validarDocumentosController = async(request, response) =>{

    /* Capturar cookie */
    const cookieToken = request.cookies.token; 
    const infoToken = await decodificarToken(cookieToken);
    
    /* Nombre de la peticion y ruta de reportes*/
    const nombresDocumentos = nombrePeticionesPDF(infoToken.Resultado["nombreUsuario"]);
    const rutasReportes = await crearCarpetaReportes(nombresDocumentos[0], nombresDocumentos[1], nombresDocumentos[2], nombresDocumentos[3]);
    

    /* Captutrar archivo */
    const archivos = request.files; 
    
    /* Analizar el pdf */
    const peticionDocumento = await analizarDocumentoPDF({arrayArchivos:archivos});

    /* Recorrer lista de objetos e insertar registros */
    const peticionBd = await insertarPeticiones({peticionFecha:new Date(), peticionNombre:nombresDocumentos[0], idUsuario:infoToken.Resultado["idUsuario"]})
    
    for(let i=0; i<peticionDocumento.length; i++){

        /* Recorrer documento */
        Object.entries(peticionDocumento[i]).forEach(async ([clave,valor])=> {
            
            const documentoBd = await insertarDocumentos({
                idPeticion:peticionBd[0]["IdPeticion"], 
                documentoNombre:clave, 
                documentoUbicacion:'./', 
                documentoEstado:valor["EstadoArchivo"], 
                documentoCausaEstado:valor["CausaVencimientoArchivo"], 
                documentoTotalFirmas:valor["NumeroFirmas"], 
                documentoFirmasVencidas:valor["NumeroFirmasVencidas"], 
                documentoTipo:valor["TipoDocumento"]
            })

            /* Recorrer certificados */
            if (valor["NumeroFirmas"] > 0){
                
                valor["Firmas"].forEach(async(certObj)=>{
                    
                    /* Recorrer los datos del certificado */
                    Object.entries(certObj).forEach(async([entrada, asignacion])=>{
                        

                        const certificadoBd = await insertarCertificados({
                            certificadoNumero:asignacion["NumeroFirma"],						
                            certificadoVersion:asignacion["Version"],			
                            certificadoSerial:asignacion["Serial"],			
                            certificadoOid:asignacion["OidFirma"],				
                            certificadoCreacion:new Date(asignacion["FechaDeCreacion"]),						
                            certificadoVencimiento:new Date(asignacion["FechaDeVencimiento"]),						
                            certificadoEstado:asignacion["EstadoDeCertificado"],							
                            certificadoEditor:asignacion["Editor"],	
                            certificadoSujeto:asignacion["sujeto"],			
                            certificadoCausaEstado:asignacion["CausaDeVencimientoDeCertificado"],					
                            certificadoUso:asignacion["FechaDeUso"] != undefined?new Date(asignacion["FechaDeUso"]):null,							
                            certificadoValidacionVencimientoEstado:asignacion["ValidacionVencimiento"][0],		
                            certificadoValidacionVencimientoDescripcion:asignacion["ValidacionVencimiento"][1], 
                            certificadoValidacionUsoEstado:asignacion["ValidacionFechaDeUso"][0],				
                            certificadoValidacionUsoDescripcion:asignacion["ValidacionFechaDeUso"][1],		 
                            certificadoValidacionHashEstado:asignacion["ValidacionHash"][0],	
                            certificadoValidacionHashDescripcion:asignacion["ValidacionHash"][1],		 
                            certificadoValidacionIntegridadEstado:asignacion["ValidacionCadenaConfianza"][0],		
                            certificadoValidacionIntegridadDescripcion:asignacion["ValidacionCadenaConfianza"][1],
                            idDocumento:documentoBd[0]["IdDocumento"]
                        })
                    })
                });
                
            }
        })
    }

    /* Reportes de csv */
    const datosReporteBasico = await reporteBasico({idUsuario:infoToken.Resultado["idUsuario"], idPeticion:peticionBd[0]["IdPeticion"]});
    const datosReporteMedio = await reporteMedio({idUsuario:infoToken.Resultado["idUsuario"], idPeticion:peticionBd[0]["IdPeticion"]});
    
    const reportesBasicosEnCSV = await reporteBasicoCSV({ pathArchivo: rutasReportes[1],listaObjetos:datosReporteBasico}); 
    const reportesMedioEnCSV = await reporteDetalladoCSV({pathArchivo: rutasReportes[2], listaObjetos:datosReporteMedio}); 

    /* Reporte en xlsx */
    const datosReporteCompleto = await reporteCompleto({idUsuario:infoToken.Resultado["idUsuario"], idPeticion:peticionBd[0]["IdPeticion"]});
    const reportesEnXLSX = await reporteXLSX({pathArchivo:rutasReportes[3], listaObjetos:datosReporteCompleto}); 

    /* Reporte en pdf */
    // Por hacer en java

    /* Insertar ubicacion de reportes en base */
    const fechaReport = new Date();
    await insertarReportes({ubicacionReporte:rutasReportes[3] , fechaReporte:fechaReport, idPeticion:peticionBd[0]["IdPeticion"], tipoReporte:1}); // XLSX
    await insertarReportes({ubicacionReporte:rutasReportes[2] , fechaReporte:fechaReport, idPeticion:peticionBd[0]["IdPeticion"], tipoReporte:2}); // CSV1
    await insertarReportes({ubicacionReporte:rutasReportes[1] , fechaReporte:fechaReport, idPeticion:peticionBd[0]["IdPeticion"], tipoReporte:3}); // CSV2

    /* Reportes */
    response.status(200).json({
        "Mensaje":"Peticion Recibida",
        "Resultado":{
            "ReporteBasico":nombresDocumentos[1],
            "ReporteDetallado":nombresDocumentos[2],
            "ReporteCompleto":nombresDocumentos[3]
        }
    })

}; 