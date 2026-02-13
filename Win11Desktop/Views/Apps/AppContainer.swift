import SwiftUI

struct AppContainer: View {
    let app: AppType

    var body: some View {
        Group {
            switch app {
            case .browser:
                BrowserView()
            case .explorer:
                ExplorerView()
            case .notepad:
                NotepadView()
            case .settings:
                SettingsView()
            case .calculator:
                CalculatorView()
            case .thisPC:
                ThisPCView()
            case .recycleBin:
                RecycleBinView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ThisPCView: View {
    private let drives = [
        ("Windows (C:)", "internaldrive.fill"),
        ("Data (D:)", "internaldrive.fill"),
        ("CD Drive (E:)", "opticaldisc.fill")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("This PC")
                .font(.system(size: 24, weight: .bold))
                .padding(.horizontal)
                .padding(.top)

            Text("Devices and drives")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary)
                .padding(.horizontal)

            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 180))
            ], spacing: 16) {
                ForEach(drives, id: \.0) { drive in
                    VStack(alignment: .leading, spacing: 8) {
                        Image(systemName: drive.1)
                            .font(.system(size: 40))
                            .foregroundColor(.blue)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(drive.0)
                                .font(.system(size: 13, weight: .medium))
                            Text("Local Disk")
                                .font(.system(size: 11))
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(width: 160, height: 100)
                    .padding()
                    .background(Color(nsColor: .controlBackgroundColor).opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .padding()

            Spacer()
        }
        .background(Color(nsColor: .textBackgroundColor))
    }
}

struct RecycleBinView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recycle Bin")
                .font(.system(size: 24, weight: .bold))
                .padding()

            Text("Recycle Bin is empty")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .padding(.horizontal)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(nsColor: .textBackgroundColor))
    }
}
