# SQL SERVER - VERSION
La version de sql server es la más actualizada, la más completa y la mas confiable (como se habia mencionado en anteriores README), tenga en cuenta que esta base de datos es mejor trabajarla con versiones de sql server iguales o superiores a la de 2019.

## Estrcutura
La estructura de este paquete es la siguiente:
```
SQL Server
├────Objetos                        #Carpeta con todos los objetos de la base de datos
│    ├───Disparadores               #Carpeta con los triggers de la base de datos
│    ├───Procedimientos             #Carpeta con los procedimientos almacenados
│    │   ├───codigoAutenticacion    #Carpeta con los sp asociados a los codigos de doble autenticacion
│    │   ├───correoElectrónico      #Carpeta con los sp asociados al envio de correos electronicos
│    │   ├───crearUsuario           #Carpeta con los sp asociados para la creacón de usuarios
│    │   └───logs                   #Carpeta con los sp asociados a los logs
│    └───Vistas                     #Carpeta con las vistas relacionadas con los reportes
├────dinamo.sql                     #Script con la creación de la base de datos y sus tablas
└────installer.sql                  #Script que inserta todo
```

**NOTA: Estos scripts pueden estar dispuestos a cambios múltiples.**

## Novedades
- Dinamo sigue en su versión beta

---
<p align="center">🦝 Yepoxtrop</p>