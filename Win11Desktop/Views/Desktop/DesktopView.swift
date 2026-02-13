import SwiftUI

struct DesktopView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            WallpaperView()

            VStack(spacing: 0) {
                if let currentApp = appState.currentApp {
                    DraggableWindow(
                        title: currentApp.rawValue,
                        icon: currentApp.icon,
                        accentColor: currentApp.accentColor
                    ) {
                        AppContainer(app: currentApp)
                    }
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .scale.combined(with: .opacity)
                    ))
                }

                Spacer()
            }

            VStack {
                DesktopIconsView()
                Spacer()
                TaskbarView()
            }
        }
        .ignoresSafeArea(.all)
    }
}

struct WallpaperView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.18, green: 0.33, blue: 0.53),
                Color(red: 0.08, green: 0.19, blue: 0.38),
                Color(red: 0.04, green: 0.12, blue: 0.27)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}
