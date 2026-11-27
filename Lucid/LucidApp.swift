import SwiftUI
import UIKit

@main
struct LucidApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

private enum LucidPalette {
    static let midnight = Color(red: 16.0 / 255.0, green: 20.0 / 255.0, blue: 38.0 / 255.0)
    static let blue = Color(red: 120.0 / 255.0, green: 155.0 / 255.0, blue: 1.0)
    static let mist = Color(red: 220.0 / 255.0, green: 231.0 / 255.0, blue: 1.0)
    static let violet = Color(red: 183.0 / 255.0, green: 164.0 / 255.0, blue: 1.0)
    static let muted = Color(red: 159.0 / 255.0, green: 171.0 / 255.0, blue: 204.0 / 255.0)
    static let surface = Color.white.opacity(0.055)
    static let border = Color.white.opacity(0.09)
}

private enum PackageManager: String, CaseIterable, Identifiable {
    case cydia
    case zebra
    case sileo

    var id: String { rawValue }
    var name: String { rawValue.capitalized }
    var tint: Color {
        switch self {
        case .cydia: return Color(red: 0.39, green: 0.73, blue: 0.91)
        case .zebra: return Color(red: 0.80, green: 0.85, blue: 0.94)
        case .sileo: return LucidPalette.blue
        }
    }

    var detail: String {
        switch self {
        case .cydia: return "Classic"
        case .zebra: return "Lightweight"
        case .sileo: return "Recommended"
        }
    }
}

private struct PreviewApp: Identifiable {
    let name: String
    let symbol: String
    let tint: Color

    var id: String { name }
}

private struct SetupLog: Identifiable {
    let elapsed: String
    let message: String

    var id: String { elapsed }
}

struct ContentView: View {
    @State private var selectedManager: PackageManager = .sileo
    @State private var isRunning = false
    @State private var isComplete = false
    @State private var visibleLogCount = 0

    private let setupLogs = [
        SetupLog(elapsed: "00:01", message: "Preparing Lucid workspace"),
        SetupLog(elapsed: "00:02", message: "Loading package index"),
        SetupLog(elapsed: "00:03", message: "Selected manager: Sileo"),
        SetupLog(elapsed: "00:04", message: "Resolving app shelf"),
        SetupLog(elapsed: "00:05", message: "Applying Dream Blue theme"),
        SetupLog(elapsed: "00:06", message: "Preview is ready")
    ]

    private let previewApps = [
        PreviewApp(name: "Filza", symbol: "folder.fill", tint: Color(red: 0.96, green: 0.68, blue: 0.27)),
        PreviewApp(name: "NewTerm", symbol: "terminal.fill", tint: Color(red: 0.48, green: 0.79, blue: 0.66)),
        PreviewApp(name: "SnowBoard", symbol: "paintpalette.fill", tint: LucidPalette.violet),
        PreviewApp(name: "iCleaner", symbol: "sparkles", tint: LucidPalette.blue)
    ]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LucidPalette.midnight.ignoresSafeArea()

                Circle()
                    .fill(LucidPalette.blue.opacity(0.14))
                    .frame(width: 340, height: 340)
                    .blur(radius: 100)
                    .offset(x: geometry.size.width * 0.38, y: -geometry.size.height * 0.36)
                    .accessibilityHidden(true)

                ScrollView {
                    VStack(alignment: .leading, spacing: 26) {
                        header
                        hero

                        if geometry.size.width > 760 {
                            HStack(alignment: .top, spacing: 18) {
                                VStack(spacing: 18) {
                                    managerPicker
                                    setupButton
                                    setupLogCard
                                }
                                appShelf
                                    .frame(width: 300)
                            }
                        } else {
                            managerPicker
                            setupButton
                            setupLogCard
                            appShelf
                        }

                        footer
                    }
                    .frame(maxWidth: 960)
                    .padding(.horizontal, geometry.size.width > 760 ? 40 : 22)
                    .padding(.top, 20)
                    .padding(.bottom, 36)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private var header: some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(LucidPalette.blue.gradient)
                    .frame(width: 25, height: 25)
                Circle()
                    .fill(LucidPalette.midnight)
                    .frame(width: 19, height: 19)
                    .offset(x: 7, y: -5)
            }
            .frame(width: 28, height: 28)
            .accessibilityHidden(true)

            Text("lucid")
                .font(.system(size: 21, weight: .semibold, design: .rounded))
                .tracking(-0.7)
                .foregroundStyle(LucidPalette.mist)

            Spacer()

            HStack(spacing: 6) {
                Circle()
                    .fill(LucidPalette.blue)
                    .frame(width: 6, height: 6)
                Text("PREVIEW")
                    .font(.system(size: 9, weight: .semibold, design: .monospaced))
                    .tracking(1)
            }
            .foregroundStyle(LucidPalette.mist.opacity(0.8))
            .padding(.horizontal, 11)
            .padding(.vertical, 8)
            .glassEffect(.regular, in: Capsule())
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your phone\nis dreaming.")
                .font(.system(size: 46, weight: .medium, design: .rounded))
                .tracking(-2)
                .foregroundStyle(LucidPalette.mist)
                .fixedSize(horizontal: false, vertical: true)
                .minimumScaleFactor(0.75)

            Text("A new state of iOS.")
                .font(.system(size: 16))
                .foregroundStyle(LucidPalette.muted)
        }
        .padding(.top, 24)
        .padding(.bottom, 2)
    }

    private var managerPicker: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Choose your package manager")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(LucidPalette.mist)
                Text("Select a home for your package library.")
                    .font(.system(size: 13))
                    .foregroundStyle(LucidPalette.muted)
            }

            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3),
                spacing: 10
            ) {
                ForEach(PackageManager.allCases) { manager in
                    managerOption(manager)
                }
            }
        }
        .padding(18)
        .background(LucidPalette.surface, in: RoundedRectangle(cornerRadius: 24))
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(LucidPalette.border, lineWidth: 1))
    }

    private func managerOption(_ manager: PackageManager) -> some View {
        let isSelected = selectedManager == manager

        return Button {
            selectedManager = manager
        } label: {
            VStack(spacing: 9) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [manager.tint.opacity(0.95), manager.tint.opacity(0.58)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 54, height: 54)

                    if manager == .zebra {
                        VStack(spacing: 4) {
                            ForEach(0..<5, id: \.self) { _ in
                                Capsule()
                                    .fill(LucidPalette.midnight.opacity(0.8))
                                    .frame(width: 24, height: 3)
                            }
                        }
                    } else {
                        Text(manager == .cydia ? "C" : "S")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(LucidPalette.midnight.opacity(0.82))
                    }
                }

                VStack(spacing: 3) {
                    Text(manager.name)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(LucidPalette.mist)
                    Text(manager.detail)
                        .font(.system(size: 9, weight: manager == .sileo ? .semibold : .regular))
                        .foregroundStyle(manager == .sileo ? LucidPalette.blue : LucidPalette.muted)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 14))
                    .foregroundStyle(isSelected ? LucidPalette.blue : LucidPalette.muted.opacity(0.45))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .background(
                isSelected ? LucidPalette.blue.opacity(0.09) : Color.clear,
                in: RoundedRectangle(cornerRadius: 18)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isSelected ? LucidPalette.blue.opacity(0.5) : LucidPalette.border, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(manager.name), \(manager.detail), \(isSelected ? "selected" : "not selected")")
    }

    private var setupButton: some View {
        Button(action: startPreview) {
            HStack(spacing: 11) {
                if isRunning {
                    ProgressView()
                        .tint(LucidPalette.midnight)
                } else {
                    Image(systemName: isComplete ? "checkmark" : "sparkles")
                        .font(.system(size: 16, weight: .semibold))
                }

                Text(buttonTitle)
                    .font(.system(size: 16, weight: .semibold))

                Spacer()

                Image(systemName: "arrow.right")
                    .font(.system(size: 13, weight: .semibold))
                    .opacity(0.7)
            }
            .foregroundStyle(LucidPalette.midnight)
            .padding(.horizontal, 20)
            .frame(height: 58)
            .background(LucidPalette.mist, in: RoundedRectangle(cornerRadius: 18))
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 18))
        }
        .buttonStyle(.plain)
        .disabled(isRunning)
    }

    private var buttonTitle: String {
        if isRunning { return "Preparing your preview…" }
        if isComplete { return "Run preview again" }
        return "Prepare Lucid"
    }

    private var setupLogCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Label("Setup activity", systemImage: "waveform.path")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(LucidPalette.mist)

                Spacer()

                Text("DEMO RUN")
                    .font(.system(size: 9, weight: .semibold, design: .monospaced))
                    .tracking(0.8)
                    .foregroundStyle(LucidPalette.blue)
            }

            if visibleLogCount == 0 {
                Text("Your setup activity will appear here.")
                    .font(.system(size: 12))
                    .foregroundStyle(LucidPalette.muted)
                    .padding(.vertical, 9)
            } else {
                VStack(alignment: .leading, spacing: 11) {
                    ForEach(Array(setupLogs.prefix(visibleLogCount))) { entry in
                        HStack(alignment: .top, spacing: 10) {
                            Text(entry.elapsed)
                                .foregroundStyle(LucidPalette.blue.opacity(0.85))
                                .frame(width: 42, alignment: .leading)
                            Text(entry.message)
                                .foregroundStyle(LucidPalette.mist.opacity(0.9))
                            Spacer(minLength: 0)
                        }
                        .font(.system(size: 11, weight: .regular, design: .monospaced))
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
                .animation(.easeOut(duration: 0.25), value: visibleLogCount)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(LucidPalette.surface, in: RoundedRectangle(cornerRadius: 24))
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(LucidPalette.border, lineWidth: 1))
    }

    private var appShelf: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .firstTextBaseline) {
                Text("App shelf")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(LucidPalette.mist)
                Spacer()
                Text("PREVIEW")
                    .font(.system(size: 9, weight: .semibold, design: .monospaced))
                    .tracking(0.8)
                    .foregroundStyle(LucidPalette.muted)
            }

            Text("A glimpse of the apps in your Lucid space.")
                .font(.system(size: 12))
                .foregroundStyle(LucidPalette.muted)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(previewApps) { app in
                    VStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 17)
                            .fill(
                                LinearGradient(
                                    colors: [app.tint.opacity(0.95), app.tint.opacity(0.58)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 58, height: 58)
                            .overlay {
                                Image(systemName: app.symbol)
                                    .font(.system(size: 23, weight: .medium))
                                    .foregroundStyle(.white)
                            }
                            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 17))

                        Text(app.name)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(LucidPalette.mist.opacity(0.92))
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 3)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(LucidPalette.surface, in: RoundedRectangle(cornerRadius: 24))
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(LucidPalette.border, lineWidth: 1))
    }

    private var footer: some View {
        Text("A familiar iPhone, seen in a different state.")
            .font(.system(size: 11))
            .foregroundStyle(LucidPalette.muted.opacity(0.8))
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 2)
    }

    private func startPreview() {
        guard !isRunning else { return }

        visibleLogCount = 0
        isComplete = false
        isRunning = true

        let managerName = selectedManager.name
        let logs = setupLogs.enumerated().map { index, entry in
            index == 2
                ? SetupLog(elapsed: entry.elapsed, message: "Selected manager: \(managerName)")
                : entry
        }

        Task { @MainActor in
            for index in logs.indices {
                try? await Task.sleep(nanoseconds: 650_000_000)
                visibleLogCount = index + 1
            }
            isRunning = false
            isComplete = true
        }
    }
}
