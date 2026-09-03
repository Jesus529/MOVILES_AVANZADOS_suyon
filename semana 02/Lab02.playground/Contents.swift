import Foundation

print("PROYECTO DE BIBLIOTECA")
print("")

// Estructura del préstamo
struct Prestamo {
var libro: String
var usuario: String
var tipoUsuario: String
var costoDiario: Double
var diasMaximos: Int
var diasUtilizados: Int
var diasAtraso: Int
var multaTotal: Double
var estado: String
var situacion: String
var fechaPrestamo: String
var fechaDevolucion: String
}

// Datos del libro
print("Ingrese el nombre del libro:")
let libro = readLine() ?? ""

print("")
// Datos del usuario
print("Ingrese el nombre del usuario:")
let usuario = readLine() ?? ""

print("")

// Tipo de usuario
print("Seleccione el tipo de usuario:")
print("1. Alumno - S/ 1.50 - Maximo 7 dias")
print("2. Docente - S/ 2.00 - Maximo 15 dias")
print("3. Administrador - S/ 3.00 - Maximo 10 dias")
print("4. Coordinador - S/ 4.00 - Maximo 15 dias")

print("")

print("Ingrese una opcion:")
let opcion = Int(readLine() ?? "") ?? 1

var tipoUsuario = ""
var costoDiario = 0.0
var diasMaximos = 0

if opcion == 1 {
tipoUsuario = "Alumno"
costoDiario = 1.50
diasMaximos = 7

} else if opcion == 2 {
tipoUsuario = "Docente"
costoDiario = 2.00
diasMaximos = 15

} else if opcion == 3 {
tipoUsuario = "Administrador"
costoDiario = 3.00
diasMaximos = 10

} else if opcion == 4 {
tipoUsuario = "Coordinador"
costoDiario = 4.00
diasMaximos = 15

} else {
print("Opcion no valida.")
exit(0)
}

print("")

// Fecha del préstamo
print("Ingrese la fecha del préstamo (dd/MM/yyyy):")
let fechaPrestamoTexto = readLine() ?? ""

print("")

// Fecha de devolución
print("Ingrese la fecha de devolución (dd/MM/yyyy):")
let fechaDevolucionTexto = readLine() ?? ""

// Configuración para trabajar con fechas
let formatoFecha = DateFormatter()
formatoFecha.dateFormat = "dd/MM/yyyy"
formatoFecha.locale = Locale(identifier: "es_PE")
formatoFecha.calendar = Calendar(identifier: .gregorian)

// Convertir las fechas ingresadas
guard let fechaPrestamo = formatoFecha.date(from: fechaPrestamoTexto),
let fechaDevolucion = formatoFecha.date(from: fechaDevolucionTexto) else {

print("")
print("ERROR: La fecha ingresada no es válida.")
print("Utilice el formato dd/MM/yyyy.")
exit(0)


}

// Verificar que la devolución no sea anterior al préstamo
if fechaDevolucion < fechaPrestamo {
print("")
print("ERROR: La fecha de devolución no puede ser anterior a la fecha del préstamo.")
exit(0)
}

// Calcular días utilizados
let calendario = Calendar(identifier: .gregorian)

let diasUtilizados = calendario.dateComponents(
[.day],
from: fechaPrestamo,
to: fechaDevolucion
).day ?? 0

// Calcular días de atraso
var diasAtraso = 0

if diasUtilizados > diasMaximos {
diasAtraso = diasUtilizados - diasMaximos
}

// Calcular multa
var multaTotal = 0.0

if diasAtraso > 0 {

// Máximo de 20 días para calcular la multa
let diasCalculados = min(diasAtraso, 20)

for dia in 1...diasCalculados {
    
    var porcentaje = 0.0
    
    if dia <= 3 {
        porcentaje = 0.0
        
    } else if dia <= 6 {
        porcentaje = 0.25
        
    } else if dia <= 10 {
        porcentaje = 0.50
        
    } else {
        porcentaje = 1.00
    }
    
    let multaDia = costoDiario * porcentaje
    multaTotal = multaTotal + multaDia
}

}

// Estado del préstamo
var estado = ""
var situacion = ""

if diasAtraso == 0 {

estado = "Dentro del plazo"
situacion = "Usuario habilitado"


} else if diasAtraso <= 20 {

estado = "Con atraso"
situacion = "Usuario habilitado"


} else {


estado = "Atraso mayor a 20 dias"
situacion = "Usuario suspendido"


}

// Crear objeto préstamo
let prestamo = Prestamo(
libro: libro,
usuario: usuario,
tipoUsuario: tipoUsuario,
costoDiario: costoDiario,
diasMaximos: diasMaximos,
diasUtilizados: diasUtilizados,
diasAtraso: diasAtraso,
multaTotal: multaTotal,
estado: estado,
situacion: situacion,
fechaPrestamo: fechaPrestamoTexto,
fechaDevolucion: fechaDevolucionTexto
)

// Formatear dinero
let costoTexto = String(format: "%.2f", prestamo.costoDiario)
let multaTexto = String(format: "%.2f", prestamo.multaTotal)

// Mostrar resultados
print("")
print("====================================")
print("        RESULTADO DEL USUARIO")
print("====================================")
print("")

print("Usuario: " + prestamo.usuario)
print("Libro: " + prestamo.libro)
print("Tipo de usuario: " + prestamo.tipoUsuario)

print("")

print("Fecha del préstamo: " + prestamo.fechaPrestamo)
print("Fecha de devolución: " + prestamo.fechaDevolucion)

print("")

print("Costo diario: S/ " + costoTexto)
print("Días máximos permitidos: " + String(prestamo.diasMaximos))
print("Días utilizados: " + String(prestamo.diasUtilizados))
print("Días de atraso: " + String(prestamo.diasAtraso))

print("")

// Mostrar información de la multa
if prestamo.diasAtraso == 0 {


print("No tiene atraso.")
print("No tiene multa.")


} else if prestamo.diasAtraso <= 3 {


print("Porcentaje de multa: 0%")
print("No paga multa por los primeros 3 días.")


} else if prestamo.diasAtraso <= 6 {


print("Porcentaje de multa: 25%")


} else if prestamo.diasAtraso <= 10 {


print("Porcentaje de multa: 50%")


} else if prestamo.diasAtraso <= 20 {


print("Porcentaje de multa: 100%")


} else {


print("Superó los 20 días de atraso.")


}

print("")

print("Multa total: S/ " + multaTexto)
print("Estado: " + prestamo.estado)
print("Situación: " + prestamo.situacion)

print("")

// Mensaje sobre el pago
if prestamo.multaTotal > 0 {


print("El usuario debe pagar S/ " + multaTexto)


} else {


print("El usuario no debe pagar multa.")


}

// Mensaje sobre la situación del usuario
if prestamo.diasAtraso > 20 {


print("El usuario está suspendido y no puede realizar nuevos préstamos.")

} else {


print("El usuario está habilitado para realizar nuevos préstamos.")


}

print("")
print("====================================")
print("          FIN DEL REGISTRO")
print("====================================")
