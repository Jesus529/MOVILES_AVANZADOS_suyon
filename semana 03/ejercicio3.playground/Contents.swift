// Desarrollado por: Jhon Kevin Vargas Choque

import Foundation

var numeros: [Int] = []

for i in 1...8 {
    print("Número \(i):")
    let n = Int(readLine() ?? "") ?? 0
    numeros.append(n)
}

print("Con duplicados: \(numeros)")

let sinDuplicados = Array(Set(numeros)).sorted()

print("Sin duplicados: \(sinDuplicados)")

var lunes: Set<String> = []
var martes: Set<String> = []

print("\nAsistencia del lunes")

for i in 1...4 {
    print("Alumno \(i):")
    let nombre = readLine() ?? ""
    lunes.insert(nombre)
}

print("\nAsistencia del martes")

for i in 1...4 {
    print("Alumno \(i):")
    let nombre = readLine() ?? ""
    martes.insert(nombre)
}

let ambosDias = lunes.intersection(martes)
let soloLunes = lunes.subtracting(martes)
let soloMartes = martes.subtracting(lunes)

print("\nResultados")
print("Ambos días: \(ambosDias)")
print("Solo lunes: \(soloLunes)")
print("Solo martes: \(soloMartes)")

let a: Set = [1, 2, 3, 4, 5]
let b: Set = [4, 5, 6, 7, 8]

print(a.intersection(b))
print(a.union(b).count)
print(a.subtracting(b))

var repetidos: Set = ["A", "B", "A", "C", "B"]

print(repetidos.count)
