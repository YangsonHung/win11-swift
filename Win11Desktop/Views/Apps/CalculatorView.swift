import SwiftUI

struct CalculatorView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            CalculatorDisplay()

            CalculatorKeypad()
        }
        .background(Color(nsColor: .controlBackgroundColor))
    }
}

struct CalculatorDisplay: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        HStack {
            Spacer()
            Text(appState.calculatorDisplay)
                .font(.system(size: 48, weight: .light))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .padding()
        .frame(height: 100)
        .background(Color(nsColor: .controlBackgroundColor))
    }
}

struct CalculatorKeypad: View {
    @EnvironmentObject var appState: AppState

    let buttons: [[CalculatorButton]] = [
        [.clear, .plusMinus, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equals]
    ]

    var body: some View {
        VStack(spacing: 8) {
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(row, id: \.self) { button in
                        CalculatorButtonView(button: button)
                    }
                }
            }
        }
        .padding()
    }
}

enum CalculatorButton: String, CaseIterable {
    case clear = "C"
    case plusMinus = "+/-"
    case percent = "%"
    case divide = "/"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case multiply = "*"
    case four = "4"
    case five = "5"
    case six = "6"
    case subtract = "-"
    case one = "1"
    case two = "2"
    case three = "3"
    case add = "+"
    case zero = "0"
    case decimal = "."
    case equals = "="

    var isOperator: Bool {
        switch self {
        case .divide, .multiply, .subtract, .add, .equals:
            return true
        default:
            return false
        }
    }

    var isFunction: Bool {
        switch self {
        case .clear, .plusMinus, .percent:
            return true
        default:
            return false
        }
    }
}

struct CalculatorButtonView: View {
    let button: CalculatorButton
    @EnvironmentObject var appState: AppState

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        Button(action: {
            handleButtonPress()
        }) {
            Text(button.rawValue)
                .font(.system(size: 24))
                .foregroundColor(button.isOperator ? .white : .primary)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 4))
        }
        .buttonStyle(.plain)
    }

    private var backgroundColor: Color {
        if button == .equals {
            return .blue
        } else if button.isOperator {
            return .orange
        } else if button.isFunction {
            return Color(nsColor: .controlBackgroundColor)
        } else {
            return Color(nsColor: .controlBackgroundColor).opacity(0.5)
        }
    }

    private func handleButtonPress() {
        switch button {
        case .clear:
            appState.calculatorDisplay = "0"
        case .plusMinus:
            if let value = Double(appState.calculatorDisplay) {
                appState.calculatorDisplay = String(-value)
            }
        case .percent:
            if let value = Double(appState.calculatorDisplay) {
                appState.calculatorDisplay = String(value / 100)
            }
        case .equals:
            // Calculate result - simplified
            break
        case .divide, .multiply, .subtract, .add:
            appState.calculatorDisplay += " \(button.rawValue) "
        case .decimal:
            if !appState.calculatorDisplay.contains(".") {
                appState.calculatorDisplay += "."
            }
        default:
            if appState.calculatorDisplay == "0" {
                appState.calculatorDisplay = button.rawValue
            } else {
                appState.calculatorDisplay += button.rawValue
            }
        }
    }
}
