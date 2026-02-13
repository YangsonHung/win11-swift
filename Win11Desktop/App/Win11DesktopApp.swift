import SwiftUI

@main
struct Win11DesktopApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            DesktopView()
                .environmentObject(appState)
                .frame(minWidth: 1024, minHeight: 768)
                .background(WindowBackground())
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}

struct WindowBackground: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = .hudWindow
        view.blendingMode = .behindWindow
        view.state = .active
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}
