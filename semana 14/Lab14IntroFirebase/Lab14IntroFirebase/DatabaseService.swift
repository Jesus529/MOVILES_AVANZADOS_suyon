import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

struct Message: Identifiable {
    let id: String
    let text: String
    let userID: String
    let authorName: String
    let timestamp: Date?
    let isPending: Bool

    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let text = data["text"] as? String,
              let uid = data["userId"] as? String,
              let name = data["authorName"] as? String else { return nil }
        self.id = document.documentID
        self.text = text
        self.userID = uid
        self.authorName = name
        self.timestamp = (data["timestamp"] as? Timestamp)?.dateValue()
        self.isPending = document.metadata.hasPendingWrites
    }
}

@MainActor
final class DatabaseService: ObservableObject {
    @Published private(set) var messages: [Message] = []
    @Published private(set) var isLoading = true
    @Published private(set) var isSending = false
    @Published private(set) var isFromCache = false
    @Published var errorMessage: String?
    private lazy var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    private var generation = UUID()

    deinit { listener?.remove() }

    func startListening() {
        listener?.remove()
        generation = UUID()
        let currentGeneration = generation
        isLoading = true
        errorMessage = nil
        listener = db.collection("messages")
            .order(by: "timestamp", descending: true).limit(to: 100)
            .addSnapshotListener(includeMetadataChanges: true) { [weak self] snapshot, error in
                Task { @MainActor [weak self] in
                    guard let self, self.generation == currentGeneration else { return }
                    self.isLoading = false
                    if let error { self.errorMessage = error.localizedDescription; return }
                    guard let snapshot else { return }
                    self.messages = Array(snapshot.documents.compactMap { Message(document: $0) }.reversed())
                    self.isFromCache = snapshot.metadata.isFromCache
                }
            }
    }

    func addMessage(text: String) async -> Bool {
        guard !isSending, let user = Auth.auth().currentUser else { return false }
        let clean = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !clean.isEmpty, clean.count <= 2000 else {
            errorMessage = "El mensaje debe contener de 1 a 2000 caracteres."
            return false
        }
        isSending = true
        defer { isSending = false }
        let name = String((user.displayName ?? "Usuario \(user.uid.prefix(6))").prefix(40))
        let data: [String: Any] = [
            "text": clean, "userId": user.uid, "authorName": name,
            "timestamp": FieldValue.serverTimestamp()
        ]
        do {
            try await db.collection("messages").document().setData(data)
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
