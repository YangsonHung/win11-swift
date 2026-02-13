import SwiftUI

struct DraggableWindow<Content: View>: View {
    let title: String
    let icon: String
    let accentColor: Color
    @ViewBuilder let content: () -> Content

    @EnvironmentObject var appState: AppState
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging: Bool = false

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                WindowChrome(
                    title: title,
                    icon: icon,
                    accentColor: accentColor,
                    onMinimize: { appState.minimizeWindow() },
                    onMaximize: { appState.maximizeWindow() },
                    onClose: { appState.closeApp() }
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if appState.windowState == .normal && !isDragging {
                                isDragging = true
                            }
                            if appState.windowState == .normal {
                                dragOffset = value.translation
                            }
                        }
                        .onEnded { _ in
                            isDragging = false
                        }
                )

                content()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(
                width: appState.windowState == .maximized ? geometry.size.width : 900,
                height: appState.windowState == .maximized ? geometry.size.height - 50 : 600
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: .black.opacity(0.3), radius: 16, x: 0, y: 8)
            .offset(dragOffset)
            .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.8), value: dragOffset)
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: appState.windowState)
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
        }
    }
}

struct WindowChrome: View {
    let title: String
    let icon: String
    let accentColor: Color
    let onMinimize: () -> Void
    let onMaximize: () -> Void
    let onClose: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                    .foregroundColor(accentColor)

                Text(title)
                    .font(.system(size: 12, weight: .medium))
            }
            .padding(.leading, 12)

            Spacer()

            WindowControlButton(icon: "minus", action: onMinimize)
            WindowControlButton(icon: "square", action: onMaximize)
            WindowControlButton(icon: "xmark", action: onClose, isClose: true)
        }
        .frame(height: 36)
        .background(Color(nsColor: .windowBackgroundColor))
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: 8,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 8
            )
        )
    }
}

struct WindowControlButton: View {
    let icon: String
    let action: () -> Void
    var isClose: Bool = false

    @State private var isHovered: Bool = false

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .medium))
                .frame(width: 46, height: 36)
                .background(isHovered && isClose ? Color.red : Color.clear)
                .foregroundColor(isHovered && isClose ? .white : .primary)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}
