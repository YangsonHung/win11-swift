import SwiftUI

struct SettingsView: View {
    @State private var selectedCategory: SettingsCategory = .system

    var body: some View {
        HStack(spacing: 0) {
            SettingsSidebar(selectedCategory: $selectedCategory)

            Divider()

            SettingsContent(category: selectedCategory)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color(nsColor: .controlBackgroundColor))
    }
}

enum SettingsCategory: String, CaseIterable, Identifiable {
    case system = "System"
    case bluetooth = "Bluetooth & devices"
    case network = "Network & internet"
    case personalize = "Personalization"
    case apps = "Apps"
    case accounts = "Accounts"
    case time = "Time & language"
    case gaming = "Gaming"
    case accessibility = "Accessibility"
    case privacy = "Privacy & security"
    case windows = "Windows Update"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .system: return "gearshape.fill"
        case .bluetooth: return "airplayaudio"
        case .network: return "wifi"
        case .personalize: return "paintbrush.fill"
        case .apps: return "square.grid.2x2"
        case .accounts: return "person.crop.circle"
        case .time: return "clock"
        case .gaming: return "gamecontroller.fill"
        case .accessibility: return "figure.roll"
        case .privacy: return "hand.raised.fill"
        case .windows: return "arrow.triangle.2.circlepath"
        }
    }
}

struct SettingsSidebar: View {
    @Binding var selectedCategory: SettingsCategory

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Settings")
                .font(.system(size: 24, weight: .bold))
                .padding(.bottom, 16)

            ForEach(SettingsCategory.allCases) { category in
                SettingsSidebarItem(
                    category: category,
                    isSelected: selectedCategory == category
                )
                .onTapGesture {
                    selectedCategory = category
                }
            }

            Spacer()
        }
        .padding()
        .frame(width: 240)
        .background(Color(nsColor: .windowBackgroundColor).opacity(0.3))
    }
}

struct SettingsSidebarItem: View {
    let category: SettingsCategory
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: category.icon)
                .font(.system(size: 16))
                .foregroundColor(isSelected ? .white : .primary)
                .frame(width: 24)

            Text(category.rawValue)
                .font(.system(size: 14))
                .foregroundColor(isSelected ? .white : .primary)

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(isSelected ? Color.blue : Color.clear)
        )
    }
}

struct SettingsContent: View {
    let category: SettingsCategory

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text(category.rawValue)
                    .font(.system(size: 28, weight: .bold))

                SettingsSection(title: "Display") {
                    SettingsToggle(title: "Night light", subtitle: "Reduce blue light with warmer colors", isOn: .constant(false))
                    SettingsSlider(title: "Brightness", value: .constant(70))
                }

                SettingsSection(title: "Sound") {
                    SettingsToggle(title: "Mute", subtitle: "Mute all sounds", isOn: .constant(false))
                }

                SettingsSection(title: "Notifications") {
                    SettingsToggle(title: "Notifications", subtitle: "Show notifications", isOn: .constant(true))
                }

                Spacer()
            }
            .padding()
        }
        .background(Color(nsColor: .textBackgroundColor))
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))

            VStack(spacing: 0) {
                content
            }
            .background(Color(nsColor: .controlBackgroundColor))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

struct SettingsToggle: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14))
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }

            Spacer()

            Toggle("", isOn: $isOn)
                .toggleStyle(.switch)
        }
        .padding()
    }
}

struct SettingsSlider: View {
    let title: String
    @Binding var value: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14))

            Slider(value: $value, in: 0...100)
        }
        .padding()
    }
}
