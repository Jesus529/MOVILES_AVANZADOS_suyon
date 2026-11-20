import SwiftUI
import FirebaseCore

@main
struct Lab14IntroFirebaseApp: App {
    private let configurationError: String?

    init() {
        if let file = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
           let options = FirebaseOptions(contentsOfFile: file),
           options.bundleID == Bundle.main.bundleIdentifier {
            FirebaseApp.configure(options: options)
            configurationError = nil
        } else {
            configurationError = "Agrega el GoogleService-Info.plist de la app iOS con el identificador pe.edu.tecsup.dma.Lab14IntroFirebase."
        }
    }

    var body: some Scene {
        WindowGroup {
            if let configurationError {
                VStack(spacing: 20) {
                    Image(systemName: "gearshape.2.fill").font(.largeTitle)
                    Text("Configura Firebase").font(.title.bold())
                    Text(configurationError).multilineTextAlignment(.center)
                }.padding(32)
            } else {
                ContentView()
            }
        }
    }
}
