// Desarrollado por: Jhon Kevin Vargas Choque

import Foundation

var precios: [String: Double] = [:]
var stocks: [String: Int] = [:]

print("¿Cuántos productos?")
let n = Int(readLine() ?? "") ?? 0

if n > 0 {
    for i in 1...n {
        print("\nProducto \(i) - Nombre:")
        let nombre = readLine() ?? ""
        
        print("Precio:")
        let precio = Double(readLine() ?? "") ?? 0
        
        print("Stock:")
        let stock = Int(readLine() ?? "") ?? 0
        
        precios[nombre] = precio
        stocks[nombre] = stock
    }
}

var valorTotal = 0.0

for (nombre, precio) in precios {
    if let stock = stocks[nombre] {
        let valorProducto = precio * Double(stock)
        valorTotal += valorProducto
        
        print("\(nombre): Precio = S/. \(precio), Stock = \(stock), Valor = S/. \(valorProducto)")
    }
}

print("\nValor total del inventario: S/. \(valorTotal)")

print("\nProductos con stock bajo:")

for (nombre, stock) in stocks {
    if stock < 5 {
        print("\(nombre): \(stock) unidades")
    }
}
