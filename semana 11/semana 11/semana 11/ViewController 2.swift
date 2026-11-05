
import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Outlet

    @IBOutlet weak var TablaContacto: UITableView?

    // MARK: - Variables

    var contactos: [NSManagedObject] = []

    // MARK: - Ciclo de vida

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let tabla = TablaContacto else {
            print("ERROR: TablaContacto no esta conectado en Main.storyboard")
            return
        }

        tabla.delegate = self
        tabla.dataSource = self

        mostrarRutaBaseDeDatos()
        cargarInfoCoreData()

        // Ejecutar solo una vez para probar la relacion.
        // probarRelacion()
        // probarBusquedaGrupo()
    }

    // MARK: - Conexion con Core Data

    func conexion() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }

    // MARK: - Ruta de la base de datos

    func mostrarRutaBaseDeDatos() {
        let delegate = UIApplication.shared.delegate as! AppDelegate

        if let ruta = delegate.persistentContainer
            .persistentStoreDescriptions.first?.url?.path {

            print("Base de datos SQLite en: \(ruta)")
        } else {
            print("No se encontro la ruta de la base de datos")
        }
    }

    // MARK: - READ: Cargar contactos

    func cargarInfoCoreData() {
        let contexto = conexion()

        let fetchRequest = NSFetchRequest<NSManagedObject>(
            entityName: "Contacto"
        )

        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "nombre", ascending: true)
        ]

        do {
            contactos = try contexto.fetch(fetchRequest)
            TablaContacto?.reloadData()

            print("Contactos cargados: \(contactos.count)")
        } catch {
            print("Error al cargar la BD: \(error.localizedDescription)")
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return contactos.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let celda = tableView.dequeueReusableCell(
            withIdentifier: "Cell",
            for: indexPath
        )

        let contacto = contactos[indexPath.row]

        let nombre = contacto.value(forKey: "nombre") as? String ?? ""
        let telefono = contacto.value(forKey: "telefono") as? String ?? ""
        let direccion = contacto.value(forKey: "direccion") as? String ?? ""

        celda.textLabel?.text = nombre
        celda.detailTextLabel?.text = "\(telefono) | \(direccion)"

        return celda
    }

    // MARK: - UPDATE: Editar contacto

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {

        tableView.deselectRow(at: indexPath, animated: true)

        let contacto = contactos[indexPath.row]

        let alert = UIAlertController(
            title: "Editar Contacto",
            message: "Modifica los datos",
            preferredStyle: .alert
        )

        alert.addTextField { campo in
            campo.text = contacto.value(forKey: "nombre") as? String
        }

        alert.addTextField { campo in
            campo.text = contacto.value(forKey: "telefono") as? String
        }

        alert.addTextField { campo in
            campo.text = contacto.value(forKey: "direccion") as? String
        }

        let actionGuardar = UIAlertAction(
            title: "Guardar",
            style: .default
        ) { _ in

            guard let nombre = alert.textFields?[0].text,
                  !nombre.trimmingCharacters(
                    in: .whitespacesAndNewlines
                  ).isEmpty else {
                return
            }

            contacto.setValue(nombre, forKey: "nombre")
            contacto.setValue(alert.textFields?[1].text ?? "", forKey: "telefono")
            contacto.setValue(alert.textFields?[2].text ?? "", forKey: "direccion")

            do {
                try self.conexion().save()
                self.cargarInfoCoreData()

                print("Contacto actualizado correctamente")
            } catch {
                print("Error al actualizar: \(error.localizedDescription)")
            }
        }

        alert.addAction(actionGuardar)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))

        present(alert, animated: true)
    }

    // MARK: - CREATE: Agregar contacto

    @IBAction func agregarContacto(_ sender: UIBarButtonItem) {

        let alerta = UIAlertController(
            title: "Nuevo Contacto",
            message: "Ingresa los datos del contacto",
            preferredStyle: .alert
        )

        alerta.addTextField { campo in
            campo.placeholder = "Nombre"
        }

        alerta.addTextField { campo in
            campo.placeholder = "Telefono"
            campo.keyboardType = .phonePad
        }

        alerta.addTextField { campo in
            campo.placeholder = "Direccion"
        }

        let guardar = UIAlertAction(
            title: "Guardar",
            style: .default
        ) { _ in

            let nombre = alerta.textFields?[0].text ?? ""
            let telefono = alerta.textFields?[1].text ?? ""
            let direccion = alerta.textFields?[2].text ?? ""

            guard !nombre.trimmingCharacters(
                in: .whitespacesAndNewlines
            ).isEmpty else {

                let error = UIAlertController(
                    title: "Campo obligatorio",
                    message: "Debes ingresar el nombre del contacto.",
                    preferredStyle: .alert
                )

                error.addAction(
                    UIAlertAction(title: "Aceptar", style: .default)
                )

                self.present(error, animated: true)
                return
            }

            let contexto = self.conexion()

            let nuevoContacto = NSEntityDescription.insertNewObject(
                forEntityName: "Contacto",
                into: contexto
            )

            nuevoContacto.setValue(nombre, forKey: "nombre")
            nuevoContacto.setValue(telefono, forKey: "telefono")
            nuevoContacto.setValue(direccion, forKey: "direccion")

            do {
                try contexto.save()
                self.cargarInfoCoreData()

                print("Contacto guardado correctamente")
            } catch {
                print("Error al guardar contacto: \(error.localizedDescription)")
            }
        }

        alerta.addAction(UIAlertAction(
            title: "Cancelar",
            style: .cancel
        ))

        alerta.addAction(guardar)

        present(alerta, animated: true)
    }

    // MARK: - DELETE: Eliminar contacto

    func eliminarContacto(at indexPath: IndexPath) {

        guard indexPath.row < contactos.count else {
            return
        }

        let contexto = conexion()
        let contactoEliminar = contactos[indexPath.row]

        contexto.delete(contactoEliminar)

        do {
            try contexto.save()

            contactos.remove(at: indexPath.row)

            TablaContacto?.deleteRows(
                at: [indexPath],
                with: .automatic
            )

            print("Contacto eliminado correctamente")
        } catch {
            print("Error al eliminar: \(error.localizedDescription)")
        }
    }

    // Permite eliminar deslizando hacia la izquierda

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {

        if editingStyle == .delete {
            eliminarContacto(at: indexPath)
        }
    }

    // MARK: - RELACION UNO A MUCHOS: Grupo y Contacto

    func probarRelacion() {

        let contexto = conexion()

        let fetchRequest = NSFetchRequest<NSManagedObject>(
            entityName: "Grupo"
        )

        fetchRequest.predicate = NSPredicate(
            format: "nombre == %@",
            "Amigos"
        )

        do {
            let gruposExistentes = try contexto.fetch(fetchRequest)

            let grupo: NSManagedObject

            if let grupoExistente = gruposExistentes.first {
                grupo = grupoExistente
            } else {
                grupo = NSEntityDescription.insertNewObject(
                    forEntityName: "Grupo",
                    into: contexto
                )

                grupo.setValue("Amigos", forKey: "nombre")
            }

            guard let primero = contactos.first else {
                print("No hay contactos para asignar al grupo.")
                return
            }

            primero.setValue(grupo, forKey: "grupo")

            try contexto.save()

            let nombreGrupo = grupo.value(forKey: "nombre") as? String ?? ""

            let listaContactos = grupo.value(
                forKey: "contactos"
            ) as? NSSet

            print(
                "El grupo \(nombreGrupo) tiene \(listaContactos?.count ?? 0) contacto(s)"
            )

        } catch {
            print("Error al guardar la relacion: \(error.localizedDescription)")
        }
    }

    // MARK: - Buscar contactos por grupo

    func contactosDelGrupo(_ nombreGrupo: String) -> [NSManagedObject] {

        let request = NSFetchRequest<NSManagedObject>(
            entityName: "Contacto"
        )

        request.predicate = NSPredicate(
            format: "grupo.nombre == %@",
            nombreGrupo
        )

        do {
            return try conexion().fetch(request)
        } catch {
            print("Error al buscar contactos: \(error.localizedDescription)")
            return []
        }
    }

    // MARK: - Probar busqueda del grupo

    func probarBusquedaGrupo() {

        let amigos = contactosDelGrupo("Amigos")

        print("Contactos del grupo Amigos: \(amigos.count)")

        for contacto in amigos {
            let nombre = contacto.value(forKey: "nombre") as? String ?? ""
            print("Contacto: \(nombre)")
        }
    }
}
