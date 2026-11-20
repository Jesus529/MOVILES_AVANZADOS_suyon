# Lab14IntroFirebase

Proyecto iOS en SwiftUI para el laboratorio 14: autenticación por correo y contraseña y mensajería en Cloud Firestore con actualizaciones en tiempo real.

- Firebase: **App01-Lab14**, ID **app01-lab14-32eb4**.
- App iOS: **pe.edu.tecsup.dma.Lab14IntroFirebase**.
- Firebase Apple SDK **13.2.0**, Swift Package Manager, versión exacta.
- iPhone/iPad con iOS 16 o posterior. Para compilar usa un Mac con Xcode 26.2 o posterior y acceso a Internet.
- El GoogleService-Info.plist incluido corresponde a la app iOS registrada en ese proyecto. No se incluyen sesiones de Google, contraseñas ni credenciales de administrador.

## Entrega desde Windows

1. Descomprime el ZIP.
2. Sube **el contenido de esta carpeta**, incluidas las carpetas ocultas .github y el .xcodeproj, a la raíz de tu repositorio GitHub. Subir solo el ZIP no ejecuta la compilación.
3. En GitHub abre **Actions → Compilar iOS y generar capturas → Run workflow**. También se ejecuta al subir a main o master.
4. Cuando termine, descarga los artefactos **Lab14-evidencias** y **Lab14-aplicacion-simulador**.
5. La captura 01-inicio-real.png la genera un simulador real en el Mac de GitHub. Las pruebas UI adjuntan capturas de registro, sesión y mensajes con dos usuarios en la carpeta capturas. build.log muestra la compilación y pruebas-ui.log contiene el resultado de las pruebas.

Las pruebas automáticas crean dos cuentas de laboratorio con direcciones únicas del dominio reservado example.com y escriben dos mensajes. No envían correos. Las cuentas y mensajes de prueba quedan en Firebase para poder verificarlos; cada ejecución usa identificadores diferentes. El resultado esperado son siete capturas adjuntas, pero solo se generan las pantallas que realmente alcance la prueba. Si falla, revisa los registros y no presentes las pruebas como aprobadas.

El workflow está preparado, pero no se ha ejecutado desde este equipo Windows. Si el runner trae un Xcode anterior a 26.2, selecciona un runner/imagen con esa versión o posterior. GitHub puede aplicar límites o cobrar minutos según tu plan y repositorio; revisa tu cuota antes de ejecutarlo.

La .app generada es para simulador y no se ejecuta en Windows ni se instala directamente en un iPhone. Para usar un iPhone real necesitas compilar y firmar desde un Mac con tu equipo de Apple Developer. No se incluye un IPA firmado.

## Abrir en un Mac

1. Abre Lab14IntroFirebase.xcodeproj.
2. Espera a que Xcode descargue Firebase por Swift Package Manager.
3. Selecciona el esquema Lab14IntroFirebase y un simulador iPhone; ejecuta con Run.
4. Para un iPhone físico, configura tu Team en Signing & Capabilities.

## Firebase

Consulta ESTADO-FIREBASE.md para ver qué quedó configurado en el servidor. Los archivos locales no habilitan por sí solos los servicios.

Si debes desplegar la configuración después, con Node 20 o posterior:

    npx -y firebase-tools@latest login
    npx -y firebase-tools@latest deploy --only auth,firestore --project app01-lab14-32eb4

Usa la cuenta que sea propietaria de ese proyecto. Firestore debe ser Standard, base (default). No uses reglas abiertas de prueba para publicar la aplicación.

## Funciones implementadas

- Registro con nombre público, correo y contraseña; validación y errores visibles.
- Inicio y cierre de sesión; restauración de la sesión mediante listener de FirebaseAuth.
- Chat compartido entre usuarios autenticados, limitado a los últimos 100 mensajes.
- Envío con fecha del servidor, estado pendiente y sincronización de datos locales.
- Nombre público en los mensajes. El correo solo se muestra al dueño de la sesión.
- Limpieza de listeners al liberar los modelos y reinicio por identidad del usuario.
- Reglas que validan esquema, autor, fecha y longitud; mensajes inmutables.

El laboratorio llama a la segunda parte «base de datos en tiempo real», pero sus imágenes y DatabaseService.swift usan Cloud Firestore. Esta implementación sigue Cloud Firestore; no usa el producto distinto Firebase Realtime Database.

## Evidencias de la actividad

La captura inicial por sí sola no demuestra autenticación ni envío. El workflow también ejecuta una prueba UI que registra dos usuarios, inicia sesión y verifica sus mensajes. Sus capturas y registros permiten comprobar qué pasos pasaron. Consulta docs/EVIDENCIAS.md. Todavía no se ha ejecutado el workflow y este ZIP no contiene capturas inventadas de ejecución.

## Validación realizada aquí

Se revisaron la estructura del proyecto, referencias, archivos de configuración y contenido del ZIP. No se realizó compilación iOS ni una prueba en el simulador en Windows. La compilación y la prueba funcional quedan pendientes hasta ejecutar Xcode o el workflow.
