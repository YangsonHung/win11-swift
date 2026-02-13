import SwiftUI

struct DesktopIcon: Identifiable, Equatable {
    let id = UUID()
    let app: AppType
    let position: CGPoint

    static func == (lhs: DesktopIcon, rhs: DesktopIcon) -> Bool {
        lhs.id == rhs.id
    }
}

struct DesktopIconData {
    static let defaultIcons: [DesktopIcon] = [
        DesktopIcon(app: .thisPC, position: CGPoint(x: 20, y: 20)),
        DesktopIcon(app: .recycleBin, position: CGPoint(x: 20, y: 120)),
        DesktopIcon(app: .browser, position: CGPoint(x: 20, y: 220)),
        DesktopIcon(app: .explorer, position: CGPoint(x: 20, y: 320)),
    ]

    static let startMenuApps: [AppType] = [
        .browser,
        .explorer,
        .notepad,
        .settings,
        .calculator
    ]
}
