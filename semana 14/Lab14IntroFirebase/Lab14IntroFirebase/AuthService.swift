import Foundation
import Combine
import FirebaseAuth

@MainActor
final class AuthService: ObservableObject {
    @Published private(set) var user: User?
    @Published private(set) var isBusy = false
    @Published private(set) var isCheckingSession = true
    @Published var errorMessage: String?
    private var listener: AuthStateDidChangeListenerHandle?
    private lazy var auth = Auth.auth()

    init() {
        // Esta clase se construye después de FirebaseApp.configure().
        listener = auth.addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor [weak self] in
                self?.user = user
                self?.isCheckingSession = false
            }
        }
    }

    deinit {
        if let listener { Auth.auth().removeStateDidChangeListener(listener) }
    }

    func signIn(email: String, password: String) async {
        guard !isBusy, validate(email: email, password: password) else { return }
        isBusy = true
        defer { isBusy = false }
        do {
            let result = try await auth.signIn(withEmail: email.trimmingCharacters(in: .whitespacesAndNewlines), password: password)
            user = result.user
        } catch { errorMessage = friendly(error) }
    }

    func signUp(name: String, email: String, password: String) async {
        guard !isBusy, validate(email: email, password: password) else { return }
        guard password.count >= 6 else {
            errorMessage = "La contraseña debe tener al menos 6 caracteres."
            return
        }
        let alias = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !alias.isEmpty, alias.count <= 40 else {
            errorMessage = "Escribe un nombre público de 1 a 40 caracteres."
            return
        }
        isBusy = true
        defer { isBusy = false }
        do {
            let result = try await auth.createUser(withEmail: email.trimmingCharacters(in: .whitespacesAndNewlines), password: password)
            let change = result.user.createProfileChangeRequest()
            change.displayName = alias
            try await change.commitChanges()
            user = result.user
        } catch { errorMessage = friendly(error) }
    }

    func signOut() {
        do { try auth.signOut(); user = nil }
        catch { errorMessage = friendly(error) }
    }

    private func validate(email: String, password: String) -> Bool {
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, !password.isEmpty else {
            errorMessage = "Completa el correo y la contraseña."
            return false
        }
        return true
    }

    private func friendly(_ error: Error) -> String {
        switch (error as NSError).code {
        case AuthErrorCode.invalidEmail.rawValue: return "El correo no tiene un formato válido."
        case AuthErrorCode.emailAlreadyInUse.rawValue: return "Este correo ya está registrado. Usa Iniciar sesión."
        case AuthErrorCode.wrongPassword.rawValue, AuthErrorCode.userNotFound.rawValue,
             AuthErrorCode.invalidCredential.rawValue: return "Correo o contraseña incorrectos."
        case AuthErrorCode.weakPassword.rawValue: return "La contraseña no cumple los requisitos de Firebase."
        case AuthErrorCode.networkError.rawValue: return "No se pudo conectar. Revisa tu conexión a Internet."
        case AuthErrorCode.operationNotAllowed.rawValue: return "Habilita Correo electrónico/contraseña en Firebase Authentication."
        case AuthErrorCode.tooManyRequests.rawValue: return "Demasiados intentos. Intenta más tarde."
        default: return error.localizedDescription
        }
    }
}
