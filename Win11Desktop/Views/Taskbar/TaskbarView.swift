import SwiftUI

struct TaskbarView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentTime = Date()

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        HStack(spacing: 2) {
            StartButton()
                .onTapGesture {
                    appState.toggleStartMenu()
                }

            Divider()
                .frame(height: 24)

            TaskbarIconsView()

            Spacer()

            TrayView(currentTime: $currentTime)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: -2)
        )
        .onReceive(timer) { _ in
            currentTime = Date()
        }
    }
}

struct StartButton: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Image(systemName: "square.grid.2x2.fill")
            .font(.system(size: 18))
            .foregroundColor(appState.isStartMenuOpen ? .blue : .primary)
            .frame(width: 40, height: 40)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(appState.isStartMenuOpen ? Color.blue.opacity(0.2) : Color.clear)
            )
    }
}

struct TaskbarIconsView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        HStack(spacing: 4) {
            ForEach(DesktopIconData.startMenuApps) { app in
                TaskbarIconButton(app: app, isActive: appState.currentApp == app)
                    .onTapGesture {
                        if appState.currentApp == app {
                            appState.closeApp()
                        } else {
                            appState.openApp(app)
                        }
                    }
            }
        }
    }
}

struct TaskbarIconButton: View {
    let app: AppType
    let isActive: Bool

    var body: some View {
        VStack(spacing: 2) {
            Image(systemName: app.icon)
                .font(.system(size: 18))
                .foregroundColor(isActive ? .blue : .primary)

            if isActive {
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 6, height: 3)
                    .cornerRadius(1.5)
            }
        }
        .frame(width: 44, height: 40)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isActive ? Color.blue.opacity(0.15) : Color.clear)
        )
        .help(app.rawValue)
    }
}

struct TrayView: View {
    @Binding var currentTime: Date

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "wifi")
                .font(.system(size: 12))

            Image(systemName: "speaker.wave.2.fill")
                .font(.system(size: 12))

            Text(formattedTime)
                .font(.system(size: 12, weight: .medium))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
    }

    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: currentTime)
    }
}
