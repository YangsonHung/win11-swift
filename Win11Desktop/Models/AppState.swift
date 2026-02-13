import SwiftUI

enum AppType: String, CaseIterable, Identifiable {
    case browser = "Microsoft Edge"
    case explorer = "File Explorer"
    case notepad = "Notepad"
    case settings = "Settings"
    case calculator = "Calculator"
    case recycleBin = "Recycle Bin"
    case thisPC = "This PC"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .browser: return "globe"
        case .explorer: return "folder"
        case .notepad: return "doc.text"
        case .settings: return "gearshape"
        case .calculator: return "plus.forwardslash.minus"
        case .recycleBin: return "trash"
        case .thisPC: return "desktopcomputer"
        }
    }

    var accentColor: Color {
        switch self {
        case .browser: return .blue
        case .explorer: return .yellow
        case .notepad: return .gray
        case .settings: return .cyan
        case .calculator: return .gray
        case .recycleBin: return .blue
        case .thisPC: return .blue
        }
    }
}

enum WindowState {
    case minimized
    case normal
    case maximized
}

class AppState: ObservableObject {
    @Published var currentApp: AppType?
    @Published var windowState: WindowState = .normal
    @Published var isStartMenuOpen: Bool = false
    @Published var selectedIcons: Set<String> = []
    @Published var isDesktopRefreshed: Bool = false

    @Published var browserURL: String = "https://www.bing.com"
    @Published var browserHistory: [String] = []
    @Published var canGoBack: Bool = false
    @Published var canGoForward: Bool = false

    @Published var notepadContent: String = ""
    @Published var notepadFileName: String = "Untitled"

    @Published var calculatorDisplay: String = "0"
    @Published var calculatorMemory: Double = 0

    @Published var explorerPath: String = "C:\\Users\\User"
    @Published var explorerItems: [FileItem] = []

    var isAppRunning: Bool {
        currentApp != nil
    }

    init() {
        setupExplorerItems()
    }

    func openApp(_ app: AppType) {
        withAnimation(.easeInOut(duration: 0.2)) {
            currentApp = app
            windowState = .normal
            isStartMenuOpen = false
        }
    }

    func closeApp() {
        withAnimation(.easeInOut(duration: 0.2)) {
            currentApp = nil
            windowState = .normal
        }
    }

    func toggleStartMenu() {
        withAnimation(.easeInOut(duration: 0.2)) {
            isStartMenuOpen.toggle()
            if isStartMenuOpen {
                currentApp = nil
            }
        }
    }

    func minimizeWindow() {
        withAnimation(.easeInOut(duration: 0.2)) {
            windowState = .minimized
        }
    }

    func maximizeWindow() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            windowState = windowState == .maximized ? .normal : .maximized
        }
    }

    func restoreWindow() {
        withAnimation(.easeInOut(duration: 0.2)) {
            windowState = .normal
        }
    }

    func refreshDesktop() {
        isDesktopRefreshed.toggle()
    }

    private func setupExplorerItems() {
        explorerItems = [
            FileItem(name: "Documents", icon: "folder.fill", isFolder: true),
            FileItem(name: "Downloads", icon: "folder.fill", isFolder: true),
            FileItem(name: "Pictures", icon: "folder.fill", isFolder: true),
            FileItem(name: "Music", icon: "folder.fill", isFolder: true),
            FileItem(name: "Videos", icon: "folder.fill", isFolder: true),
            FileItem(name: "readme.txt", icon: "doc.text.fill", isFolder: false),
            FileItem(name: "notes.txt", icon: "doc.text.fill", isFolder: false)
        ]
    }
}

struct FileItem: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let isFolder: Bool
}
