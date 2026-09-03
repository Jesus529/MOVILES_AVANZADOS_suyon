// Desarrollado por: Jhon Kevin Vargas Choque

import Foundation // Importa las funciones básicas de Swift

var precios: [String: Double] = [:] // Guarda el precio de cada producto
var stocks: [String: Int] = [:] // Guarda el stock de cada producto

print("¿Cuántos productos desea registrar?") // Solicita la cantidad de productos
let cantidad = Int(readLine() ?? "") ?? 0 // Lee y convierte la cantidad a entero

if cantidad > 0 { // Verifica que la cantidad sea válida
    for i in 1...cantidad { // Repite el registro para cada producto
        print("\nProducto \(i) - Nombre:") // Solicita el nombre del producto
        let nombre = readLine() ?? "" // Lee el nombre del producto
        
        print("Precio:") // Solicita el precio
        let precio = Double(readLine() ?? "") ?? 0 // Convierte el precio a Double
        
        print("Stock:") // Solicita la cantidad disponible
        let stock = Int(readLine() ?? "") ?? 0 // Convierte el stock a entero
        
        precios[nombre] = precio // Guarda el precio en el diccionario
        stocks[nombre] = stock // Guarda el stock en el diccionario
    }
}

var continuar = true // Controla si el menú debe continuar ejecutándose

while continuar { // Repite el menú mientras continuar sea verdadero
    
    print("\nMENÚ DE INVENTARIO") // Muestra el título del menú
    print("1) Ver inventario") // Muestra la opción para ver productos
    print("2) Buscar producto") // Muestra la opción para buscar
    print("3) Stock bajo") // Muestra la opción de stock bajo
    print("4) Valor total") // Muestra la opción de valor total
    print("5) Salir") // Muestra la opción para salir
    print("Seleccione una opción:") // Solicita una opción al usuario
    
    let opcion = Int(readLine() ?? "") ?? 0 // Lee y convierte la opción a entero
    
    switch opcion { // Evalúa la opción seleccionada
        
    case 1: // Opción para mostrar todo el inventario
        print("\nINVENTARIO") // Muestra el título del inventario
        
        for (nombre, precio) in precios { // Recorre todos los productos
            if let stock = stocks[nombre] { // Busca el stock correspondiente
                print("\(nombre) | Precio: S/. \(precio) | Stock: \(stock)") // Muestra los datos del producto
            }
        }
        
    case 2: // Opción para buscar un producto
        print("\nIngrese el producto a buscar:") // Solicita el nombre
        let buscar = readLine() ?? "" // Lee el nombre buscado
        
        if let precio = precios[buscar], let stock = stocks[buscar] { // Comprueba si existe el producto
            print("\nProducto encontrado") // Informa que se encontró
            print("Nombre: \(buscar)") // Muestra el nombre
            print("Precio: S/. \(precio)") // Muestra el precio
            print("Stock: \(stock)") // Muestra el stock
        } else { // Si el producto no existe
            print("Producto no encontrado") // Muestra el mensaje de error
        }
        
    case 3: // Opción para mostrar productos con poco stock
        print("\nPRODUCTOS CON STOCK BAJO") // Muestra el título
        
        var hayStockBajo = false // Controla si existe algún producto con stock bajo
        
        for (nombre, stock) in stocks { // Recorre todos los stocks
            if stock < 5 { // Comprueba si el stock es menor a 5
                print("\(nombre): \(stock) unidades") // Muestra el producto con stock bajo
                hayStockBajo = true // Indica que se encontró un producto
            }
        }
        
        if !hayStockBajo { // Comprueba si no se encontraron productos
            print("No hay productos con stock bajo") // Muestra el mensaje correspondiente
        }
        
    case 4: // Opción para calcular el valor total
        var valorTotal = 0.0 // Crea una variable para acumular el valor
        
        for (nombre, precio) in precios { // Recorre todos los productos
            if let stock = stocks[nombre] { // Obtiene el stock del producto
                valorTotal += precio * Double(stock) // Multiplica precio por stock y suma
            }
        }
        
        print("\nVALOR TOTAL DEL INVENTARIO") // Muestra el título
        print("S/. \(valorTotal)") // Muestra el valor total
        
    case 5: // Opción para salir
        print("\nGracias por utilizar el sistema") // Muestra mensaje de despedida
        continuar = false // Detiene el ciclo del menú
        
    default: // Se ejecuta cuando se ingresa una opción incorrecta
        print("Opción no válida") // Muestra mensaje de error
    }
}
