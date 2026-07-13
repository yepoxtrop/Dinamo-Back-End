# Controladores de la cuenta
Dentre de este folder se encuentran todos los controladores relacionados con la cuenta del usuario, desde crear cuentas, inhabilitar cuentas, recuperar cuentas, cambiar contraseñas e iniciar sesión.

Cada controlador tiene su propio archivo de JavaScript y una documentación básica en javadocs, sin embargo, la documentación más completa se encuentra en este archivo README.md.

### Crear cuenta simple
Este controlador se encuentra en el archivo `crearCuentaSimple.controller.js`. La función de este controlador es permitir la creación de una cuenta con un método **simple** o **básico**, es decir, no hay intervención de terceros para crear la cuenta como por ejemplo:
- Google
- Microsoft
- Github

**NOTA: Los controladores de creación de cuentas con los servicios de aplicaciones externas estarán más adelante.**

Este controlador recibirá un objeto JSON con los siguientes parámetros:
- `usuario`: Es el username o alias bajo el cual se podrá encontrar la cuenta.
- `email`: Es el correo electrónico asociado a la cuenta.
- `contrasena`: Es la contraseña para acceder a la cuenta.
- `condiciones`: Es un booleano que indica si el usuario aceptó las condiciones de uso.
- `fecha`: Es la fecha y hora en que se creó la cuenta.
- `ip`: Es la dirección IP pública desde donde se creó la petición, este parametro normalmente es la direcció IP pública del dispositivo.

El objeto JSON de ejemplo que se enviará al controlador es el siguiente:
```json
{
    "usuario":"Light Yagami",
    "email":"Light.Yagami@gmail.com",
    "contrasena":"*********",
    "condiciones":true,
    "fecha":"2026-01-25T19:12:03.788Z",
    "ip":"172.16.0.1"
}
```

También el controlador hará busqueda de un encabezado o header llamado `user-agent` que es un string que indica el tipo de dispositivo desde donde se está haciendo la petición, por ejemplo:
```
firefox/110.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/  
```

Si todo funciona correctamente, el contralodar, enviará un token de acceso de 6 dígitos al usuario, ese token será alfanumerico y tendrá una vigencia de 30 minutos, en caso de que el código no haya sido usado en dicho tiempo se invalidará el codigo y el usuario no será creado, sin embargo, en caso de que el código sea usado en el tiempo correcto, se creará la cuenta y se enviará un correo electrónico al usuario con un mensaje de bienvenida.

<!-- #Imagen de ejemplo a futuro -->
Después de que se le haya enviado al usuario el correo electrónico con su código de autenticación, el controlador respondera con un objeto JSON con un mensaje de exito y el código HTTP 200, el objeto JSON de ejemplo es el siguiente:
```json
{
    "mensaje":"Solicitud recibida exitosamente. Se ha enviado un correo electrónico con un código de autenticación al usuario.",
    "codigo":200
}
```

En caso de que se presenten problemas con la creación de la cuenta, el controlador reponderá con un objeto JSON con un mensaje de error y el código HTTP correspondiente, el objeto JSON de ejemplo es el siguiente:
```json
{
    "mensaje":"Error al crear la cuenta en el servidor.",
    "codigo":500
}
```

**NOTA: El mensaje y el código de error pueden variar dependiendo del tipo de error que se presente.**