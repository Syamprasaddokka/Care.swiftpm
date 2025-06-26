import SwiftUI
import SwiftData

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Document.self)
                .onAppear{
                    DispatchQueue.main.async { // Important: Main thread!
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let rootViewController = windowScene.windows.first?.rootViewController {
                            rootViewController.overrideUserInterfaceStyle = .light
                        }
                    }
                }
       
        }
    }
}
