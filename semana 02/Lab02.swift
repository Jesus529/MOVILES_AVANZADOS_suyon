import Foundation

print("       PROYECTO DE BIBLIOTECA")


struct Prestamo {
    var libro: String
    var usuario: String
    var fechaPrestamo: String
    var fechaLimite: String
    var fechaDevolucion: String
    var diasAtraso: Int
    var multaTotal: Double
    var estado: String
    var situacion: String
}


// INGRESAR DATOS


print("")
print("Ingrese el nombre del libro:")
let libro = readLine() ?? ""

print("")
print("Ingrese el nombre del usuario:")
let usuario = readLine() ?? ""

print("")
print("Ingrese el tipo de usuario:")
print("1. Alumno")
print("2. Docente")
print("3. Auditoría")

let opcion = Int(readLine() ?? "1") ?? 1

var tipoUsuario = ""
var limiteDias = 0

if opcion == 1 {
    tipoUsuario = "Alumno"
    limiteDias = 7
} else if opcion == 2 {
    tipoUsuario = "Docente"
    limiteDias = 15
} else {
    tipoUsuario = "Auditoría"
    limiteDias = 10
}


// FECHAS


print("")
print("Ingrese la fecha de préstamo (dd/MM/yyyy):")
let fechaPrestamo = readLine() ?? ""

print("")
print("Ingrese la fecha límite (dd/MM/yyyy):")
let fechaLimite = readLine() ?? ""

print("")
print("Ingrese la fecha de devolución (dd/MM/yyyy):")
let fechaDevolucion = readLine() ?? ""


// CONVERTIR FECHAS


let formato = DateFormatter()
formato.dateFormat = "dd/MM/yyyy"
formato.locale = Locale(identifier: "es_PE")

let fechaLimiteDate = formato.date(from: fechaLimite)
let fechaDevolucionDate = formato.date(from: fechaDevolucion)


// CALCULAR DÍAS DE ATRASO


var diasAtraso = 0

if let limite = fechaLimiteDate,
   let devolucion = fechaDevolucionDate {
    
    let diferencia = Calendar.current.dateComponents(
        [.day],
        from: limite,
        to: devolucion
    )
    
    diasAtraso = max(0, diferencia.day ?? 0)
}


// CALCULAR MULTA PROGRESIVA


let multaNormal = 1.50
var multaTotal = 0.0

if diasAtraso > 0 {
    
    for dia in 1...diasAtraso {
        
        var multaDia = 0.0
        
        if dia <= 3 {
            
            // Días 1 al 3
            multaDia = multaNormal
            
        } else if dia <= 6 {
            
            // Días 4 al 6
            multaDia = multaNormal * 1.50
            
        } else {
            
            // Día 7 en adelante
            multaDia = multaNormal * 2.00
        }
        
        multaTotal += multaDia
        
        print(
            "Día \(dia) - Multa: S/ \(String(format: "%.2f", multaDia)) - Acumulado: S/ \(String(format: "%.2f", multaTotal))"
        )
    }
}


// ESTADO


var estado = ""
var situacion = ""

if diasAtraso > 0 {
    estado = "DEVUELTO CON ATRASO"
} else {
    estado = "DEVUELTO A TIEMPO"
}

if diasAtraso >= 10 {
    situacion = "USUARIO INHABILITADO"
} else {
    situacion = "USUARIO HABILITADO"
}

// ======================================
// CREAR PRÉSTAMO
// ======================================

let prestamo = Prestamo(
    libro: libro,
    usuario: usuario,
    fechaPrestamo: fechaPrestamo,
    fechaLimite: fechaLimite,
    fechaDevolucion: fechaDevolucion,
    diasAtraso: diasAtraso,
    multaTotal: multaTotal,
    estado: estado,
    situacion: situacion
)

// ======================================
// MOSTRAR RESULTADO
// ======================================

print("")
print("======================================")
print("          DATOS DEL PRÉSTAMO")
print("======================================")

print("Libro: \(prestamo.libro)")
print("Usuario: \(prestamo.usuario)")
print("Tipo de usuario: \(tipoUsuario)")
print("Fecha de préstamo: \(prestamo.fechaPrestamo)")
print("Fecha límite: \(prestamo.fechaLimite)")
print("Fecha de devolución: \(prestamo.fechaDevolucion)")
print("Días de atraso: \(prestamo.diasAtraso)")

print("")
print("MULTA TOTAL: S/ \(String(format: "%.2f", prestamo.multaTotal))")
print("ESTADO: \(prestamo.estado)")
print("SITUACIÓN: \(prestamo.situacion)")

// ======================================
// REGLAS
// ======================================

print("")
print("======================================")
print("          REGLAS DE PRÉSTAMO")
print("======================================")

print("Alumno: máximo 7 días")
print("Docente: máximo 15 días")
print("Auditoría: máximo 10 días")

print("")
print("MULTA PROGRESIVA")

print("Días 1 al 3: S/ 1.50 por día")
print("Días 4 al 6: S/ 2.25 por día")
print("Día 7 en adelante: S/ 3.00 por día")

if diasAtraso >= 10 {
    print("")
    print("⚠️ USUARIO SUSPENDIDO")
    print("No puede realizar nuevos préstamos.")
}

print("")
print("======================================")
print("       FIN DEL REGISTRO")
print("======================================")
