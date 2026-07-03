# 📋 Procedimientos Almacenados

Este directorio contiene funciones asincrónicas que invocan procedimientos almacenados en SQL Server para operaciones complejas que requieren transacciones, cálculos en BD o manipulación de múltiples tablas.

## 📂 Estructura

- `peticiones.js` – Procedimientos para gestión de peticiones, documentos y certificados.
- `reportes.js` – Procedimientos para generación de reportes consolidados.

## 🧩 Módulo: peticiones.js

Maneja la inserción y gestión de datos relacionados con peticiones de validación/firma.

### Funciones exportadas

#### `insertarPeticiones({ peticionFecha, peticionNombre, idUsuario })`
Inserta una nueva petición en la base de datos.

**Parámetros:**
- `peticionFecha` (Date|String) – Fecha/hora de la petición
- `peticionNombre` (String) – Nombre descriptivo
- `idUsuario` (Number) – ID del usuario que realiza la petición

**Retorna:** Promise<any> – Resultado de la consulta

---

#### `insertarDocumentos({ idPeticion, documentoNombre, documentoUbicacion, documentoEstado, ... })`
Inserta información de un documento validado.

**Parámetros clave:**
- `idPeticion` (Number) – ID de la petición padre
- `documentoNombre` (String) – Nombre del archivo PDF
- `documentoEstado` (Boolean) – true=válido, false=inválido
- `documentoTotalFirmas` (Number) – Total de firmas encontradas
- `documentoFirmasVencidas` (Number) – Firmas expiradas

**Retorna:** Promise<any> – Resultado de la consulta

---

#### `insertarCertificados({ certificadoNumero, certificadoSerial, certificadoEstado, ... })`
Inserta detalles de certificados encontrados en documentos.

**Parámetros principales:**
- `certificadoNumero` (Number) – Número secuencial de firma
- `certificadoSerial` (String) – Serial del certificado
- `certificadoEstado` (Boolean) – true=válido, false=vencido
- `certificadoValidacionVencimientoEstado` (Boolean) – Resultado validación
- `idDocumento` (Number) – ID del documento padre

**Retorna:** Promise<boolean> – true si inserción exitosa

---

## 🧩 Módulo: reportes.js

Genera reportes consolidados con información agregada de múltiples documentos y certificados.

### Funciones exportadas

#### `reporteBasico({ idUsuario, idPeticion })`
Genera reporte resumido de la petición especificada.

**Retorna:** Promise<any> – Datos del reporte en formato tabular

---

#### `reporteMedio({ idUsuario, idPeticion })`
Genera reporte con nivel medio de detalle.

**Retorna:** Promise<any> – Datos desglosados por documento

---

#### `reporteCompleto({ idUsuario, idPeticion })`
Genera reporte completo incluyendo todas las firmas y certificados.

**Retorna:** Promise<any> – Datos exhaustivos con todos los detalles

---

## 🔄 Procedimientos SQL Asociados

| Nombre SP | Propósito | Tabla |
|-----------|-----------|-------|
| `usp_insertar_peticiones` | Crea nueva petición | PETICIONES |
| `usp_insertar_documentos` | Registra documento analizado | DOCUMENTOS_VALIDADOS |
| `usp_insertar_certificados` | Registra certificado extraído | DATOS_CERTIFICADOS |
| `usp_generar_reporte_basico` | Reporte resumido | (VIEW) |
| `usp_generar_reporte_medio` | Reporte desglosado | (VIEW) |
| `usp_generar_reporte_completo` | Reporte exhaustivo | (VIEW) |

## 📝 Manejo de errores

Todas las funciones lanzan excepciones en caso de fallo:

```javascript
try {
  await insertarCertificados({ ... });
} catch (error) {
  console.error('Error al insertar certificado:', error.message);
  // Manejar error
}
```

## 🛡️ Observaciones

- Los SP pueden fallar por restricciones de integridad referencial.
- Asegurar que IDs de referencias (idPeticion, idDocumento) existan antes de insertar.
- Los reportes pueden tardar según volumen de datos.
- En caso de error, revisar logs de SQL Server para más detalles.
