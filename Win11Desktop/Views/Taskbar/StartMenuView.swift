import SwiftUI

struct StartMenuView: View {
    @EnvironmentObject var appState: AppState
    @State private var searchText = ""

    var body: some View {
        VStack(spacing: 0) {
            SearchBarView(searchText: $searchText)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    PinnedAppsSection()
                    Divider()
                    AllAppsSection()
                }
                .padding()
            }
            .frame(height: 400)

            Divider()

            PowerSection()
        }
        .frame(width: 600, height: 600)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: .black.opacity(0.3), radius: 16, x: 0, y: 4)
    }
}

struct SearchBarView: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)

            TextField("Search for apps, settings, and documents", text: $searchText)
                .textFieldStyle(.plain)
                .font(.system(size: 14))

            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(12)
        .background(Color(nsColor: .controlBackgroundColor).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .padding()
    }
}

struct PinnedAppsSection: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pinned")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary)

            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 80, maximum: 100))
            ], spacing: 8) {
                ForEach(DesktopIconData.startMenuApps) { app in
                    StartMenuAppButton(app: app)
                }
            }
        }
    }
}

struct AllAppsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("All apps")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary)

            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 80, maximum: 100))
            ], spacing: 8) {
                ForEach(DesktopIconData.startMenuApps) { app in
                    StartMenuAppButton(app: app)
                }
            }
        }
    }
}

struct StartMenuAppButton: View {
    let app: AppType
    @EnvironmentObject var appState: AppState

    var body: some View {
        Button(action: {
            appState.openApp(app)
        }) {
            VStack(spacing: 6) {
                Image(systemName: app.icon)
                    .font(.system(size: 24))
                    .foregroundColor(app.accentColor)

                Text(app.rawValue)
                    .font(.system(size: 11))
                    .lineLimit(1)
            }
            .frame(width: 80, height: 70)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct PowerSection: View {
    var body: some View {
        HStack {
            Button(action: {}) {
                HStack {
                    Image(systemName: "power")
                    Text("Power")
                }
                .font(.system(size: 12))
            }
            .buttonStyle(.plain)

            Spacer()

            Button(action: {}) {
                Image(systemName: "powerplug.fill")
                    .font(.system(size: 12))
            }
            .buttonStyle(.plain)

            Button(action: {}) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 12))
            }
            .buttonStyle(.plain)
        }
        .padding()
    }
}
