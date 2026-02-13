# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A native macOS application that simulates the Windows 11 desktop environment, built with SwiftUI.

## Build Commands

```bash
cd /Users/yangsonhung/Projects/personal/win11-swift

# Generate Xcode project (if project.yml changes)
xcodegen generate

# Build the project
xcodebuild -project Win11Desktop.xcodeproj -scheme Win11Desktop -configuration Debug build

# Run directly from DerivedData
open ~/Library/Developer/Xcode/DerivedData/Win11Desktop-*/Build/Products/Debug/Win11\ Desktop.app
```

## Architecture

- **UI Framework**: SwiftUI + AppKit (NSVisualEffectView for blur effects)
- **Browser**: WKWebView for native web browsing
- **State Management**: `@StateObject` with `AppState` class as central state
- **Window System**: Custom draggable windows using `DragGesture` and `.offset()`

### Key Components

- `AppState.swift` - Central state management containing `currentApp`, `windowState`, app-specific states
- `DraggableWindow.swift` - Generic window wrapper with title bar, drag/close/minimize/maximize
- `AppContainer.swift` - Switches between apps based on `AppType` enum
- `BrowserView.swift` - Uses `WKWebView` with notification-based control for navigation

### Adding New Apps

1. Add new case to `AppType` enum in `Models/AppState.swift`
2. Add view in `Views/Apps/`
3. Add case to switch in `AppContainer.swift`

### Window Drag Fix

When implementing draggable windows, use `.offset()` instead of `.position()` to avoid UI jitter. Use `interactiveSpring` animation for smooth dragging:

```swift
.offset(dragOffset)
.animation(.interactiveSpring(response: 0.3, dampingFraction: 0.8), value: dragOffset)
```

## Notes

- Target: macOS 13.0+
- App runs in accessory mode (fullscreen desktop simulation)
- Browser requires network access for web browsing
