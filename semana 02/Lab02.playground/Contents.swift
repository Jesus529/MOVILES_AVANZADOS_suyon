import Foundation
print("PROYECTO DE BIBLIOTECA")
print("")

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
}

print("Ingrese el nombre del libro:")
let libro = readLine() ?? ""

print("")
print("Ingrese el nombre del usuario:")
let usuario = readLine() ?? ""

print("")
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
}
else if opcion == 2 {
tipoUsuario = "Docente"
costoDiario = 2.00
diasMaximos = 15
}
else if opcion == 3 {
tipoUsuario = "Administrador"
costoDiario = 3.00
diasMaximos = 10
}
else if opcion == 4 {
tipoUsuario = "Coordinador"
costoDiario = 4.00
diasMaximos = 15
}
else {
print("Opcion no valida.")
exit(0)
}

print("")
print("Ingrese cuantos dias tuvo el libro:")
let diasUtilizados = Int(readLine() ?? "") ?? 0

var diasAtraso = 0

if diasUtilizados > diasMaximos {
diasAtraso = diasUtilizados - diasMaximos
}

var multaTotal = 0.0

if diasAtraso > 0 {

let diasCalculados = min(diasAtraso, 20)

for dia in 1...diasCalculados {

    var porcentaje = 0.0

    if dia <= 3 {
        porcentaje = 0.0
    }
    else if dia <= 6 {
        porcentaje = 0.25
    }
    else if dia <= 10 {
        porcentaje = 0.50
    }
    else {
        porcentaje = 1.00
    }

    let multaDia = costoDiario * porcentaje
    multaTotal = multaTotal + multaDia
}

}

var estado = ""
var situacion = ""

if diasAtraso == 0 {
estado = "Dentro del plazo"
situacion = "Usuario habilitado"
}
else if diasAtraso <= 20 {
estado = "Con atraso"
situacion = "Usuario habilitado"
}
else {
estado = "Atraso mayor a 20 dias"
situacion = "Usuario suspendido"
}

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
situacion: situacion
)

let costoTexto = String(format: "%.2f", prestamo.costoDiario)
let multaTexto = String(format: "%.2f", prestamo.multaTotal)

print("")
print("RESULTADO DEL USUARIO")
print("")

print("Usuario: " + prestamo.usuario)
print("Libro: " + prestamo.libro)
print("Tipo de usuario: " + prestamo.tipoUsuario)
print("Costo diario: S/ " + costoTexto)
print("Dias maximos permitidos: " + String(prestamo.diasMaximos))
print("Dias utilizados: " + String(prestamo.diasUtilizados))
print("Dias de atraso: " + String(prestamo.diasAtraso))
print("")

if prestamo.diasAtraso == 0 {
print("No tiene atraso.")
print("No tiene multa.")
}
else if prestamo.diasAtraso <= 3 {
print("Porcentaje de multa: 0%")
print("No paga multa por los primeros 3 dias.")
}
else if prestamo.diasAtraso <= 6 {
print("Porcentaje de multa: 25%")
}
else if prestamo.diasAtraso <= 10 {
print("Porcentaje de multa: 50%")
}
else if prestamo.diasAtraso <= 20 {
print("Porcentaje de multa: 100%")
}
else {
print("Supero los 20 dias de atraso.")
}

print("")
print("Multa total: S/ " + multaTexto)
print("Estado: " + prestamo.estado)
print("Situacion: " + prestamo.situacion)
print("")

if prestamo.multaTotal > 0 {
print("El usuario debe pagar S/ " + multaTexto)
}
else {
print("El usuario no debe pagar multa.")
}

if prestamo.diasAtraso > 20 {
print("El usuario esta suspendido y no puede realizar nuevos prestamos.")
}
else {
print("El usuario esta habilitado para realizar nuevos prestamos.")
}

print("")
print("Fin del registro")
