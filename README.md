# Dinamo - Firmas Digitales

Dinamo es una aplicacion de firmas digitales que busca reducir el uso de papel y asegurar la integridad de los datos del firmante.
Nace como un proyecto empresarial básico para la generación de certificados digitales, pero he decidio convertirlo en un proyecto más ambicioso.
Dianmo se divide en dos partes:

- <a href="https://github.com/yepoxtrop/Dinamo-Back-End">Api - BackEnd</a> - Servicio de Api Rest con Javascript
- <a href="https://github.com/yepoxtrop/Dinamo-Front-End">UI - FrontEnd</a> - Interfaz gráfica con React JS

# Dinamo BacKend

Este es el repositorio oficial del API de Dinamo, el API se encarga de gestionar tareas fundamentales para el firmado de documentos digitales, como pueden ser:

- Modulo de usuarios
  - [ ] Autenticación de usuarios con active directory corporativo
  - [ ] Personalización de perfl dentro de dinamo
  - [ ] Gestion de sesiones con JWT y cookies
- Modulo de firmas digitales
  - [ ] Creación de certificados digitales autofirmados y firmas **.p12**
  - [ ] Aceptar el cargue de analisis de firmas externas para firmar documentos
- Modulo de analisis de documentos
  - [ ] Analizar documentos pdf con un máximo de 12 archivos
  - [ ] Generar reportes de los archivos cargados, siendo en formato xlsx, csv o txt
- Modulo de integridad de datos
  - [ ] Integración de base de datos multicliente con prisma como ORM para varios SGBD, existen procedimientos, vistas y disparadores, pero el SGBD en el que esta basado es **SQL SERVER**.

La versión que encontrará aqui (en la rama **devLuis**) es la más reciente en desarrollo, la versión más estable la encuentra en la rama **main**.

## Estructura

El backend de Dinamo cuenta con la siguiente estructura en la distribucion delproyecto:

```
DINAMO-BACK-END          #Directorio principal del backend de Dinamo
├───Apis                 #Todos los serivcios relacionados con el API de Dinamo
│   ├───Api_Js           #APi escrita en JS
│   ├───java-maker-pdf   #Paquete de JAVA para manipular PDFS
│   └───java-signer      #Paquete de JAVA para manipular PDFS
├───Aplicaciones_Extra   #Aplicaciones extras para hacer pruebas
└───Base_Datos           #Versiones de la base de datos para SGBD
    ├───MySQL            #Version de MYSQL
    └───SQL Server       #Version para SQLSERVER (Más actualizada)
```

**NOTA: Tenga en cuenta que cada carpeta importante tendra su propio** `README.MD` **Con el fn de documentar a mas detalle cada modulo**

## Versiones

La version principal de Dinamo es de un aplicativo completo incluyendo su `Login` y `Register` por vía de correos electrónicos o por las pasarelas ofrecidas por plataformas como `Google`, `Outlook` o `Github`, sin embargo, Dinammo ofrece su versión enfocada al logueo por `Active Directory`, más adelente exploraremos los datalles y particularidades de cada versión.

## Novedades

- Dinamo sigue en su versión beta

---

<p align="center">🦝 Yepoxtrop</p>
