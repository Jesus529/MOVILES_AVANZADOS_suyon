// Desarrollado por: Jhon Kevin Vargas Choque

import Foundation // Importa las funciones básicas de Swift

var alumnos: [String: [Double]] = [:] // Crea un diccionario para guardar nombre y 3 notas

print("¿Cuántos alumnos?") // Solicita la cantidad de alumnos
let cantidad = Int(readLine() ?? "") ?? 0 // Lee y convierte la cantidad a entero

if cantidad > 0 { // Verifica que la cantidad sea mayor que cero
    for i in 1...cantidad { // Repite el proceso para cada alumno
        print("\nAlumno \(i) - Nombre:") // Solicita el nombre del alumno
        let nombre = readLine() ?? "" // Lee el nombre ingresado
        
        var notas: [Double] = [] // Crea un array vacío para las notas
        
        for j in 1...3 { // Repite tres veces para pedir las notas
            print("Nota \(j):") // Solicita una nota
            let nota = Double(readLine() ?? "") ?? 0 // Convierte la entrada a Double
            notas.append(nota) // Agrega la nota al array
        }
        
        alumnos[nombre] = notas // Guarda el alumno y sus notas en el diccionario
    }
}

var promedios: [String: Double] = [:] // Crea un diccionario para guardar los promedios
var sumaGeneral = 0.0 // Variable para acumular todas las notas finales
var notaMayor = -Double.infinity // Guarda la nota más alta
var notaMenor = Double.infinity // Guarda la nota más baja
var aprobados = 0 // Cuenta la cantidad de alumnos aprobados

print("\nREPORTE DE NOTAS") // Muestra el título del reporte

for (nombre, notas) in alumnos { // Recorre todos los alumnos del diccionario
    let suma = notas.reduce(0, +) // Suma las tres notas
    let promedio = suma / Double(notas.count) // Calcula el promedio del alumno
    
    promedios[nombre] = promedio // Guarda el promedio del alumno
    
    sumaGeneral += promedio // Acumula el promedio para calcular el promedio general
    
    if let mayor = notas.max(), mayor > notaMayor { // Comprueba si existe una nota mayor
        notaMayor = mayor // Actualiza la nota más alta
    }
    
    if let menor = notas.min(), menor < notaMenor { // Comprueba si existe una nota menor
        notaMenor = menor // Actualiza la nota más baja
    }
    
    if promedio >= 13 { // Comprueba si el alumno está aprobado
        aprobados += 1 // Aumenta el contador de aprobados
    }
    
    let clasificacion: String // Declara la clasificación del alumno
    
    switch promedio { // Clasifica al alumno según su promedio
    case 18...20: // Comprueba si el promedio está entre 18 y 20
        clasificacion = "Excelente" // Asigna la clasificación Excelente
    case 15..<18: // Comprueba si el promedio está entre 15 y menos de 18
        clasificacion = "Bueno" // Asigna la clasificación Bueno
    case 13..<15: // Comprueba si el promedio está entre 13 y menos de 15
        clasificacion = "Aprobado" // Asigna la clasificación Aprobado
    default: // Considera cualquier promedio menor a 13
        clasificacion = "Desaprobado" // Asigna la clasificación Desaprobado
    }
    
    print("\(nombre): \(notas) - Promedio: \(promedio) - \(clasificacion)") // Muestra los resultados del alumno
}

if !alumnos.isEmpty { // Comprueba que existan alumnos registrados
    let promedioGeneral = sumaGeneral / Double(alumnos.count) // Calcula el promedio general
    let porcentajeAprobados = Double(aprobados) / Double(alumnos.count) * 100 // Calcula el porcentaje de aprobados
    
    print("\nESTADÍSTICAS") // Muestra el título de estadísticas
    print("Promedio general: \(promedioGeneral)") // Muestra el promedio general
    print("Nota más alta: \(notaMayor)") // Muestra la nota más alta
    print("Nota más baja: \(notaMenor)") // Muestra la nota más baja
    print("Porcentaje de aprobados: \(porcentajeAprobados)%") // Muestra el porcentaje de aprobados
    
    let ordenados = promedios.sorted { $0.value > $1.value } // Ordena los alumnos de mayor a menor promedio
    
    print("\nALUMNOS ORDENADOS POR PROMEDIO") // Muestra el título del ranking
    
    for (nombre, promedio) in ordenados { // Recorre los alumnos ordenados
        print("\(nombre): \(promedio)") // Muestra el nombre y promedio
    }
}
