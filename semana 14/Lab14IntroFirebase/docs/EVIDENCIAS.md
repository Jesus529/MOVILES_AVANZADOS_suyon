# Evidencias reales del laboratorio

## Generación automática desde Windows usando GitHub

1. Descomprime el ZIP y sube su contenido a la raíz de tu repositorio, incluida .github.
2. Abre Actions → Compilar iOS y generar capturas → Run workflow.
3. Espera al resultado y descarga el artefacto Lab14-evidencias al final de la ejecución.
4. Dentro encontrarás 01-inicio-real.png y la carpeta capturas con los adjuntos de las pruebas UI. El manifiesto del exportador relaciona los archivos con sus nombres de actividad.

Las actividades esperadas son: 01-inicio-de-sesion, 02-formulario-de-registro, 03-usuario-A-autenticado, 04-mensaje-del-usuario-A, 05-inicio-con-cuenta-registrada, 06-mensajes-de-dos-usuarios y 07-usuario-A-recibe-respuesta. Esto es una lista de capturas programadas, no evidencia de una ejecución ya realizada.

El workflow crea dos cuentas de prueba con correos únicos del dominio reservado example.com y dos mensajes. Los datos quedan en Firebase para verificarlos. No se realizan envíos de correo.

## Capturas adicionales en la consola Firebase

1. Firebase → Configuración → General: proyecto App01-Lab14 y app iOS con el Bundle ID.
2. Authentication → Sign-in method: Correo electrónico/contraseña habilitado.
3. App: formulario inicial (la captura automática de Actions cubre esta pantalla).
4. App: crear una cuenta de prueba con un correo que puedas usar para pruebas y un nombre público.
5. Authentication → Users: comprobar el usuario creado; no mostrar contraseñas.
6. Cerrar sesión y volver a entrar con la misma cuenta.
7. Enviar un mensaje; mostrarlo en la aplicación y en Firestore → messages.
8. Entrar con una segunda cuenta desde otro simulador/dispositivo; responder y mostrar la sincronización en ambas sesiones.
9. Registrar una prueba de contraseña incorrecta y comprobar que aparece un error.

No registres las pruebas como realizadas hasta ejecutarlas. build.log debe terminar con BUILD SUCCEEDED y pruebas-ui.log debe mostrar que la prueba concluyó correctamente. Las capturas de la consola de Firebase se obtienen desde el navegador; no forman parte de la prueba UI de iOS.
