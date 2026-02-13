import SwiftUI

struct DesktopIconsView: View {
    @EnvironmentObject var appState: AppState
    @State private var contextMenuItem: DesktopIcon?

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                ForEach(DesktopIconData.defaultIcons) { icon in
                    DesktopIconItem(
                        icon: icon,
                        isSelected: appState.selectedIcons.contains(icon.id.uuidString),
                        onTap: {
                            appState.selectedIcons = [icon.id.uuidString]
                        },
                        onDoubleTap: {
                            appState.openApp(icon.app)
                        }
                    )
                    .onTapGesture {
                        appState.selectedIcons = [icon.id.uuidString]
                    }
                    .simultaneousGesture(
                        TapGesture(count: 2).onEnded {
                            appState.openApp(icon.app)
                        }
                    )
                    .contextMenu {
                        Button("Open") {
                            appState.openApp(icon.app)
                        }
                        Divider()
                        Button("Refresh") {
                            appState.refreshDesktop()
                        }
                        Divider()
                        Button("Properties") {
                            // Show properties
                        }
                    }
                }
                Spacer()
            }
            .padding(.leading, 8)
            .padding(.top, 8)
        }
    }
}

struct DesktopIconItem: View {
    let icon: DesktopIcon
    let isSelected: Bool
    let onTap: () -> Void
    let onDoubleTap: () -> Void

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(isSelected ? Color.blue.opacity(0.3) : Color.clear)
                    .frame(width: 70, height: 70)

                Image(systemName: icon.app.icon)
                    .font(.system(size: 32))
                    .foregroundColor(icon.app.accentColor)
            }

            Text(icon.app.rawValue)
                .font(.system(size: 11))
                .foregroundColor(.white)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .shadow(color: .black.opacity(0.5), radius: 1, x: 1, y: 1)
        }
        .frame(width: 80)
        .padding(4)
    }
}
