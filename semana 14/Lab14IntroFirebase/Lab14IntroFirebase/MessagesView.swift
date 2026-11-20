import SwiftUI
import UIKit

struct MessagesView: View {
    let userID: String
    let email: String
    let signOut: () -> Void
    @StateObject private var database = DatabaseService()
    @State private var draft = ""

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Lab 14: Firebase").font(.headline)
                Text(email).font(.caption).foregroundStyle(.secondary)
                Label(database.isFromCache ? "Datos locales · esperando sincronización" : "Mensajes en tiempo real", systemImage: database.isFromCache ? "icloud.slash" : "bolt.horizontal.circle")
                    .font(.caption).foregroundStyle(database.isFromCache ? Color.orange : Color.blue)
            }.frame(maxWidth: .infinity, alignment: .leading).padding()
            Divider()
            if database.isLoading {
                Spacer(); ProgressView("Cargando mensajes…"); Spacer()
            } else if database.messages.isEmpty {
                Spacer()
                Image(systemName: "bubble.left.and.bubble.right").font(.largeTitle).foregroundStyle(.blue)
                Text("Comienza la conversación").font(.headline).padding(.top, 10)
                Text("Envía el primer mensaje del laboratorio.").foregroundStyle(.secondary).padding(.top, 4)
                Button("Volver a conectar") { database.startListening() }.padding(.top, 12)
                Spacer()
            } else {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 14) {
                            ForEach(database.messages) { message in
                                messageRow(message)
                            }
                        }.padding()
                    }
                    .onChange(of: database.messages.last?.id) { id in
                        if let id { withAnimation { proxy.scrollTo(id, anchor: .bottom) } }
                    }
                }
            }
            if database.isSending {
                Text("Guardando en Firebase… Si estás sin conexión, se sincronizará al reconectar.")
                    .font(.caption).foregroundStyle(.secondary).padding(.horizontal)
            }
        }
        .navigationTitle("Messages")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Sign Out", role: .destructive, action: signOut).accessibilityIdentifier("signOut")
            }
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Listo") {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            HStack(alignment: .bottom, spacing: 12) {
                TextField("Escribe un mensaje…", text: $draft, axis: .vertical)
                    .lineLimit(1...4).textFieldStyle(.roundedBorder).accessibilityIdentifier("messageInput")
                Button {
                    let sending = draft
                    Task { if await database.addMessage(text: sending), draft == sending { draft = "" } }
                } label: { Image(systemName: "paperplane.fill").padding(6) }
                    .buttonStyle(.borderedProminent)
                    .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || database.isSending || draft.count > 2000)
                    .accessibilityLabel("Enviar mensaje").accessibilityIdentifier("sendMessage")
            }.padding().background(.bar)
        }
        .task(id: userID) { database.startListening() }
        .alert("Mensajería", isPresented: Binding(get: { database.errorMessage != nil }, set: { if !$0 { database.errorMessage = nil } })) {
            Button("Aceptar") { database.errorMessage = nil }
        } message: { Text(database.errorMessage ?? "") }
    }

    private func messageRow(_ message: Message) -> some View {
        let mine = message.userID == userID
        return HStack {
            if mine { Spacer(minLength: 32) }
            VStack(alignment: .leading, spacing: 6) {
                Text(mine ? "Tú · \(message.authorName)" : message.authorName).font(.caption.bold())
                Text(message.text).textSelection(.enabled)
                HStack(spacing: 6) {
                    if let time = message.timestamp { Text(time, style: .time) }
                    if message.isPending { Text("Pendiente") }
                }.font(.caption2).foregroundStyle(.secondary)
            }
            .padding(12).background(mine ? Color.blue.opacity(0.12) : Color.secondary.opacity(0.10))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            if !mine { Spacer(minLength: 32) }
        }.id(message.id)
    }
}
