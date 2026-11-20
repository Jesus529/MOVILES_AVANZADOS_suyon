# Estado del servidor Firebase

Configurado el 19 de noviembre de 2026.

| Elemento | Estado verificado |
| --- | --- |
| Proyecto | App01-Lab14, ID app01-lab14-32eb4 |
| App iOS | Lab14IntroFirebase |
| Bundle ID | pe.edu.tecsup.dma.Lab14IntroFirebase |
| App ID | 1:109262679380:ios:b676c7263adbed1e19ecc1 |
| Configuración cliente | GoogleService-Info.plist descargado de Firebase e incluido |
| Authentication | Proveedor email/password habilitado mediante despliegue completado |
| Cloud Firestore | Base (default), edición STANDARD, región nam5, modo nativo |
| Actualizaciones en tiempo real | Habilitadas |
| Reglas | Compiladas por Firebase y publicadas |
| Índices | Configuración desplegada |

Consola: https://console.firebase.google.com/project/app01-lab14-32eb4/overview

## Alcance de las reglas

La colección messages es una sala compartida entre usuarios autenticados. El autor de una escritura debe coincidir con el UID de la sesión. Se restringen los campos, tipos, longitudes y la fecha del servidor. No se permiten actualizaciones ni eliminaciones desde el cliente. Los mensajes usan un nombre público y no guardan correos ni contraseñas.

I've set up prototype Security Rules to keep the data in Firestore safe. They are designed to be secure for an authenticated laboratory chat by validating the message schema, author UID, length limits, and server timestamps, while denying edits and deletions. However, you should review and verify them before broadly sharing your app. If you'd like, I can help you harden these rules.

## Pruebas pendientes

No se ha compilado la app iOS ni se han registrado usuarios o enviado mensajes desde un simulador. Eso requiere ejecutar el proyecto en un Mac o el workflow incluido. El despliegue de servicios no sustituye las pruebas funcionales de la aplicación.
