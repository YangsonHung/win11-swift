import SwiftUI
import AppKit

struct NotepadView: View {
    @EnvironmentObject var appState: AppState
    @State private var text: String = ""
    @State private var showSaveDialog: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            NotepadToolbar()

            TextEditor(text: $text)
                .font(.system(size: 14, design: .monospaced))
                .scrollContentBackground(.hidden)
                .background(Color.white)
        }
        .onAppear {
            text = appState.notepadContent
        }
        .onChange(of: text) { newValue in
            appState.notepadContent = newValue
        }
    }
}

struct NotepadToolbar: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        HStack {
            Menu {
                Button("New") {
                    appState.notepadContent = ""
                    appState.notepadFileName = "Untitled"
                }
                Button("Open...") {
                    // Open file
                }
                Button("Save") {
                    saveFile()
                }
                Button("Save As...") {
                    saveFileAs()
                }
            } label: {
                Text("File")
                    .font(.system(size: 12))
            }
            .menuStyle(.borderlessButton)

            Menu {
                Button("Undo") {}
                Button("Cut") {}
                Button("Copy") {}
                Button("Paste") {}
                Divider()
                Button("Select All") {}
            } label: {
                Text("Edit")
                    .font(.system(size: 12))
            }
            .menuStyle(.borderlessButton)

            Menu {
                Button("Word Wrap") {}
                Divider()
                Button("Font...") {}
            } label: {
                Text("Format")
                    .font(.system(size: 12))
            }
            .menuStyle(.borderlessButton)

            Menu {
                Button("Status Bar") {}
            } label: {
                Text("View")
                    .font(.system(size: 12))
            }
            .menuStyle(.borderlessButton)

            Menu {
                Button("About Notepad") {}
            } label: {
                Text("Help")
                    .font(.system(size: 12))
            }
            .menuStyle(.borderlessButton)

            Spacer()

            Text(appState.notepadFileName)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(nsColor: .controlBackgroundColor).opacity(0.5))
    }

    private func saveFile() {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.plainText]
        panel.nameFieldStringValue = appState.notepadFileName + ".txt"

        if panel.runModal() == .OK, let url = panel.url {
            do {
                try appState.notepadContent.write(to: url, atomically: true, encoding: .utf8)
                appState.notepadFileName = url.deletingPathExtension().lastPathComponent
            } catch {
                print("Error saving file: \(error)")
            }
        }
    }

    private func saveFileAs() {
        saveFile()
    }
}
