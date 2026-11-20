import XCTest

@MainActor
final class LaboratorioCapturasTests: XCTestCase {
    private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testCapturarLaboratorioConDosUsuarios() {
        app.launch()
        if app.buttons["signOut"].waitForExistence(timeout: 5) { app.buttons["signOut"].tap() }
        XCTAssertTrue(app.textFields["email"].waitForExistence(timeout: 30))
        capture("01-inicio-de-sesion")

        let run = UUID().uuidString.lowercased()
        let emailA = "lab14-a-\(run)@example.com"
        let emailB = "lab14-b-\(run)@example.com"
        let password = "Lab14!" + UUID().uuidString
        register(name: "Estudiante A", email: emailA, password: password, captureForm: true)
        capture("03-usuario-A-autenticado")
        let firstMessage = "Hola desde el usuario A · " + String(run.prefix(8))
        send(firstMessage)
        capture("04-mensaje-del-usuario-A")

        signOut()
        signIn(email: emailA, password: password)
        XCTAssertTrue(app.staticTexts[firstMessage].waitForExistence(timeout: 30))
        capture("05-inicio-con-cuenta-registrada")

        signOut()
        register(name: "Estudiante B", email: emailB, password: password, captureForm: false)
        XCTAssertTrue(app.staticTexts[firstMessage].waitForExistence(timeout: 30))
        let reply = "Respuesta desde el usuario B · " + String(run.prefix(8))
        send(reply)
        capture("06-mensajes-de-dos-usuarios")

        signOut()
        signIn(email: emailA, password: password)
        XCTAssertTrue(app.staticTexts[reply].waitForExistence(timeout: 30))
        capture("07-usuario-A-recibe-respuesta")
    }

    private func register(name: String, email: String, password: String, captureForm: Bool) {
        app.buttons["Crear una cuenta nueva"].tap()
        XCTAssertTrue(app.textFields["publicName"].waitForExistence(timeout: 10))
        if captureForm { capture("02-formulario-de-registro") }
        fill(app.textFields["publicName"], with: name)
        fill(app.textFields["email"], with: email)
        fill(app.secureTextFields["password"], with: password)
        dismissKeyboard()
        app.buttons["submitAuth"].tap()
        XCTAssertTrue(app.buttons["signOut"].waitForExistence(timeout: 45), "Firebase no confirmó el registro")
        XCTAssertTrue(messageInput.waitForExistence(timeout: 15))
    }

    private func signIn(email: String, password: String) {
        XCTAssertTrue(app.textFields["email"].waitForExistence(timeout: 15))
        fill(app.textFields["email"], with: email)
        fill(app.secureTextFields["password"], with: password)
        dismissKeyboard()
        app.buttons["submitAuth"].tap()
        XCTAssertTrue(app.buttons["signOut"].waitForExistence(timeout: 45), "Firebase no confirmó el inicio de sesión")
    }

    private func signOut() {
        app.buttons["signOut"].tap()
        XCTAssertTrue(app.textFields["email"].waitForExistence(timeout: 15))
    }

    private func send(_ text: String) {
        let input = messageInput
        fill(input, with: text)
        app.buttons["sendMessage"].tap()
        let cleared = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "value == %@ OR value == '' OR value == nil", "Escribe un mensaje…"), object: input)
        XCTAssertEqual(XCTWaiter.wait(for: [cleared], timeout: 45), .completed,
                       "El servidor no confirmó la escritura del mensaje")
        XCTAssertTrue(app.staticTexts[text].waitForExistence(timeout: 15))
        dismissKeyboard()
    }

    private var messageInput: XCUIElement {
        app.descendants(matching: .any).matching(identifier: "messageInput").firstMatch
    }

    private func fill(_ field: XCUIElement, with text: String) {
        XCTAssertTrue(field.waitForExistence(timeout: 10))
        field.tap()
        field.typeText(text)
    }

    private func dismissKeyboard() {
        let done = app.buttons["Listo"]
        if done.waitForExistence(timeout: 2) { done.tap() }
    }

    private func capture(_ name: String) {
        XCTContext.runActivity(named: name) { activity in
            let attachment = XCTAttachment(screenshot: app.screenshot())
            attachment.name = name
            attachment.lifetime = .keepAlways
            activity.add(attachment)
        }
    }
}
