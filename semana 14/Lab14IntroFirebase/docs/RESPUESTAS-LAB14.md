# Respuestas del laboratorio 14

## Paquetes de Firebase

- **FirebaseCore** inicializa y configura la aplicación Firebase y da acceso a su instancia.
- **FirebaseAuth** permite registrar usuarios, iniciar/cerrar sesión y observar el estado de autenticación.
- **FirebaseFirestore** permite trabajar con documentos y colecciones de Cloud Firestore, consultas y listeners en tiempo real.
- **FirebaseDatabase** corresponde al producto Firebase Realtime Database y su árbol JSON. Aparece entre los paquetes de la guía, pero el código de mensajería mostrado allí usa Firestore. Por eso no es necesario enlazarlo en esta implementación.

## Finalidad de FirebaseApp.configure()

Inicializa la app Firebase predeterminada con su configuración de proyecto antes de usar Authentication o Firestore. En este proyecto se carga el plist incluido y se llama configure(options:) explícitamente. Sin esta inicialización, los servicios no conocen a qué proyecto deben conectarse.

## Métodos principales de Auth.auth()

- createUser(withEmail:password:): crea la cuenta y autentica al nuevo usuario.
- signIn(withEmail:password:): valida las credenciales y abre la sesión.
- signOut(): cierra la sesión local; puede lanzar un error.
- addStateDidChangeListener: informa cambios de la sesión y permite restaurar la interfaz al abrir la app.
- removeStateDidChangeListener: retira el observador al liberar el servicio.
- currentUser: devuelve el usuario actual, su uid, correo y nombre público.

## Ventaja de una base con actualizaciones en tiempo real

Los listeners notifican cambios sin tener que refrescar manualmente o consultar repetidamente el servidor. En el chat, un mensaje guardado puede aparecer en otros clientes conectados. Firestore también mantiene caché local y sincroniza escrituras pendientes cuando regresa la conexión; esto no equivale a confirmar que una escritura ya fue aceptada por el servidor.

## Tres servicios adicionales

- Cloud Storage: adjuntar archivos o imágenes con sus reglas de acceso.
- Cloud Messaging: notificar mensajes nuevos cuando la aplicación no está activa.
- Crashlytics: registrar fallos para diagnosticar errores de la aplicación.

## Conclusiones técnicas

1. Firebase Authentication ofrece una identidad única por usuario que puede utilizarse para controlar las escrituras en Firestore.
2. Los listeners de Firestore permiten implementar un chat con actualización automática; su ciclo de vida debe gestionarse para evitar observadores duplicados.
3. Las validaciones de interfaz ayudan al usuario, pero las restricciones de autor, esquema y longitud deben comprobarse también en las reglas del servidor.

Estas conclusiones describen la implementación. Las pruebas de ejecución deben documentarse después de realizarlas.

## Fuentes

- https://firebase.google.com/docs/ios/setup
- https://firebase.google.com/docs/auth/ios/password-auth
- https://firebase.google.com/docs/firestore/query-data/listen
- https://firebase.google.com/docs/firestore/manage-data/add-data
- https://firebase.google.com/docs/firestore/security/rules-conditions
- https://github.com/firebase/firebase-ios-sdk/releases/tag/13.2.0
