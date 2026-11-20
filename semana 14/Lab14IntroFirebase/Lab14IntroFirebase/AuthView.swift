import SwiftUI
import UIKit

struct AuthView: View {
    @StateObject private var auth = AuthService()
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var registering = false

    var body: some View {
        NavigationStack {
            Group {
                if auth.isCheckingSession {
                    ProgressView("Comprobando sesión…")
                } else if let user = auth.user {
                    VStack(spacing: 20) {
                        Text("Sesión iniciada").font(.title.bold())
                        Text(user.email ?? "")
                        Button("Sign Out", action: auth.signOut)
                    }.padding()
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            Label("TECSUP · LABORATORIO 14", systemImage: "bolt.shield.fill")
                                .font(.caption.bold()).foregroundStyle(.blue)
                            Text("Lab 14: Firebase").font(.largeTitle.bold())
                            Text(registering ? "Crea tu cuenta y participa en la sala del laboratorio." : "Inicia sesión para compartir mensajes en tiempo real.")
                                .foregroundStyle(.secondary)
                            VStack(spacing: 16) {
                                if registering {
                                    TextField("Nombre público", text: $name)
                                        .textContentType(.nickname).accessibilityIdentifier("publicName")
                                }
                                TextField("Correo electrónico", text: $email)
                                    .keyboardType(.emailAddress).textContentType(.emailAddress)
                                    .textInputAutocapitalization(.never).autocorrectionDisabled()
                                    .accessibilityIdentifier("email")
                                SecureField("Contraseña", text: $password)
                                    .textContentType(registering ? .newPassword : .password)
                                    .accessibilityIdentifier("password")
                            }.textFieldStyle(.roundedBorder)
                            Button {
                                Task {
                                    if registering { await auth.signUp(name: name, email: email, password: password) }
                                    else { await auth.signIn(email: email, password: password) }
                                    if auth.user != nil { password = "" }
                                }
                            } label: {
                                HStack {
                                    Spacer()
                                    if auth.isBusy { ProgressView().tint(.white) }
                                    Text(registering ? "Crear cuenta · Sign Up" : "Iniciar sesión · Sign In").bold()
                                    Spacer()
                                }.padding(.vertical, 7)
                            }.buttonStyle(.borderedProminent).disabled(auth.isBusy)
                                .accessibilityIdentifier("submitAuth")
                            Button(registering ? "Ya tengo una cuenta" : "Crear una cuenta nueva") {
                                registering.toggle(); password = ""
                            }.disabled(auth.isBusy)
                            Text("Tu correo solo se muestra en tu sesión. En el chat se usa tu nombre público.")
                                .font(.footnote).foregroundStyle(.secondary)
                        }.padding(28).frame(maxWidth: 520).frame(maxWidth: .infinity)
                    }.navigationTitle(registering ? "Registro" : "Bienvenido")
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Listo") {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                        }
                    }
                }
            }
        }
        .alert("Firebase", isPresented: Binding(get: { auth.errorMessage != nil }, set: { if !$0 { auth.errorMessage = nil } })) {
            Button("Aceptar") { auth.errorMessage = nil }
        } message: { Text(auth.errorMessage ?? "") }
        .onChange(of: auth.user?.uid) { newID in
            if newID == nil { email = ""; password = ""; name = ""; registering = false }
        }
    }
}
