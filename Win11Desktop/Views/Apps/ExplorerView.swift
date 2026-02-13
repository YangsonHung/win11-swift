import SwiftUI

struct ExplorerView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedItem: FileItem?

    var body: some View {
        HSplitView {
            ExplorerSidebar()
                .frame(width: 180)

            VStack(spacing: 0) {
                ExplorerToolbar()
                ExplorerContent()
            }
        }
        .background(Color(nsColor: .controlBackgroundColor))
    }
}

struct ExplorerSidebar: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            SidebarItem(icon: "house.fill", title: "Home", isSelected: true)
            SidebarItem(icon: "desktopcomputer", title: "Desktop")
            SidebarItem(icon: "doc.fill", title: "Documents")
            SidebarItem(icon: "arrow.down.circle", title: "Downloads")
            SidebarItem(icon: "photo", title: "Pictures")
            SidebarItem(icon: "music.note", title: "Music")
            SidebarItem(icon: "film", title: "Videos")

            Spacer()
        }
        .padding()
        .background(Color(nsColor: .windowBackgroundColor).opacity(0.5))
    }
}

struct SidebarItem: View {
    let icon: String
    let title: String
    var isSelected: Bool = false

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(isSelected ? .blue : .primary)
                .frame(width: 20)

            Text(title)
                .font(.system(size: 13))

            Spacer()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(isSelected ? Color.blue.opacity(0.15) : Color.clear)
        )
    }
}

struct ExplorerToolbar: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "arrow.left")
            }
            .buttonStyle(.plain)

            Button(action: {}) {
                Image(systemName: "arrow.right")
            }
            .buttonStyle(.plain)

            Button(action: {}) {
                Image(systemName: "arrow.up")
            }
            .buttonStyle(.plain)

            Divider()
                .frame(height: 20)

            Text(appState.explorerPath)
                .font(.system(size: 12))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(nsColor: .controlBackgroundColor))
                .clipShape(RoundedRectangle(cornerRadius: 4))

            Spacer()

            Button(action: {}) {
                Image(systemName: "magnifyingglass")
            }
            .buttonStyle(.plain)
        }
        .padding(8)
        .background(Color(nsColor: .controlBackgroundColor).opacity(0.3))
    }
}

struct ExplorerContent: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedItem: FileItem?

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 100))
            ], spacing: 16) {
                ForEach(appState.explorerItems) { item in
                    ExplorerItem(item: item, isSelected: selectedItem?.id == item.id)
                        .onTapGesture {
                            selectedItem = item
                        }
                        .onTapGesture(count: 2) {
                            if item.isFolder {
                                // Navigate to folder
                            }
                        }
                }
            }
            .padding()
        }
        .background(Color(nsColor: .textBackgroundColor))
    }
}

struct ExplorerItem: View {
    let item: FileItem
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: item.icon)
                .font(.system(size: 40))
                .foregroundColor(item.isFolder ? .yellow : .blue)

            Text(item.name)
                .font(.system(size: 12))
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .frame(width: 100, height: 90)
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(isSelected ? Color.blue.opacity(0.2) : Color.clear)
        )
    }
}
