import Foundation

print("       PROYECTO DE BIBLIOTECA")


struct Prestamo {
    var titulo: String
    var tipoUsuario: String
    var fechaPrestado: String
    var fechaDevolucion: String
}

let prestamo = Prestamo(
    titulo: "El Principito",
    tipoUsuario: "Estudiante",
    fechaPrestado: "27/08/2026",
    fechaDevolucion: "03/09/2026"
)

print("Título: \(prestamo.titulo)")
print("Tipo de usuario: \(prestamo.tipoUsuario)")
print("Fecha prestado: \(prestamo.fechaPrestado)")
print("Fecha de devolución: \(prestamo.fechaDevolucion)")

print("")
print("Préstamo registrado correctamente.")
