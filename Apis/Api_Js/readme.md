# API JAVASCRIPT
Este servicio es el órgano principal de Dinamo, al igual que la base de datos, las aplicaciones extras y las otras implementaciones de las cuales hace uso el software, la más importante es el `Api_Js`, dicha api hace uso de diferente módulos externos (más tarde serán tratados, por el momento no), y cuenta con una arquitectura modular que busca tener todo organizado.

Esta api es la encargada de:
- Comunicarse con la base datos y realizar transacciones con los datos proporcionados con los usuarios.
- Recibir y analizar archivos `*.pdf` para generar reportes en formatos `*.csv`, `*.xlsx` o `.txt`.
- Enviar correos según las tareas realizadas.
- Crear firmas digitales y certificados autofirmados
- Almacenar firmas externas y firmar con ellas
- Compartir documentos con diferentes usuarios para ser editados o firmados
- Editar documentos pdf
- Crear flujos de trabajo para la edicion de documentos pdf
- Crea los JWT y cookies para su autenticación 

## Esstructura
El Api, cuenta con la siguiente estructura:
```
Api_Js
├───certificates                                            #Carpeta en donde se alamcenan los certificados
├───node_modules                                            #Modulos externos
├───patches                                                    
├───prisma                                                  #Carpeta relacionada con las updates de prisma
│   └───migrations                                          #Carpeta con las migraciones de prisma
├───reports                                                 #Carpeta donde se almacenan los reportes
├───src                                                     #Codigo fuente
│   ├───controllers                                         #Controladores para las rutas
│   │   ├───datosUsuario
│   │   ├───documentos
│   │   ├───firmasDigitales
│   │   └───inicioSesion
│   ├───middlewares                                         #Middlewares para las rutas
│   ├───modules                                             #Modulos para los controladores
│   │   ├───apis
│   │   ├───baseDatos
│   │   │   ├───consultasPrisma
│   │   │   ├───prisma
│   │   │   │   ├───consultas
│   │   │   │   └───procedimientos
│   │   │   └───uspSqlServer
│   │   ├───correo
│   │   ├───documentos
│   │   │   ├───analizarDocumentosPDF
│   │   │   └───reportes
│   │   │       ├───reportesCSV
│   │   │       ├───reportesPDF
│   │   │       └───reportesXLSX
│   │   ├───dominio
│   │   ├───firmasDigitales
│   │   │   ├───archivos
│   │   │   │   ├───creacion
│   │   │   │   └───renovacion
│   │   │   ├───carguesMasivos
│   │   │   └───carpetas
│   │   └───tokens
│   │       └───auth
│   ├───routes
│   │   ├───datosUsuario
│   │   ├───documentos
│   │   ├───firmasDigitales
│   │   ├───inicioSesion
│   │   └───usuarios
│   ├───settings
│   │   ├───correo
│   │   │   └───plantillasHTML
│   │   ├───dominio
│   │   ├───general
│   │   ├───others
│   │   │   └───plantillaCorreo
│   │   ├───prisma
│   │   └───tokens
│   └───temp
├───uploads                                              #Cargas
│   ├───documentosAnalizados
│   └───signatures
├───utils                                                #Funciones comunes

```
**NOTA: Si alguna de las carpetas no aparecen cuando clone el repositorio, tenga en cuenta que unas de ellas se van a crear automaticamente cuando inicie la aplicación en su servidor o en su equipo**

## Novedades
El API continua en desarrollo para mejorar su eficiencia
<img src="https://i.pinimg.com/736x/1d/fc/08/1dfc08fe9cf70882e98d4be7bc798ab0.jpg" />

---
<p align="center">🦝 Yepoxtrop</p>