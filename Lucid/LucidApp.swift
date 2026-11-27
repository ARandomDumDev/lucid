import Foundation
import SwiftUI
import UIKit
import WebKit

@main
struct LucidApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

private enum DeviceProfile {
    static var family: String {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: return "iPhone"
        case .pad: return "iPad"
        default: return UIDevice.current.localizedModel
        }
    }

    static var deviceSummary: String {
        "\(family) · iOS \(UIDevice.current.systemVersion)"
    }

    static var heroTitle: String {
        "Your \(family)\nis dreaming."
    }

    static var heroSubtitle: String {
        UIDevice.current.userInterfaceIdiom == .pad
            ? "A wider canvas, in a different state."
            : "A new state of iOS."
    }

    static var bootHeadline: String {
        "Waking into a new state on \(family)."
    }

    static let styleRange = "iOS 7 – iOS 27"
}

private enum BootSequencePhase: Equatable {
    case activity
    case blackout
    case moon
    case wordmark
}


import SwiftUI
import WebKit

private struct LucidBootSequence: View {
    @Environment(\.dismiss) private var dismiss

    @State private var visibleLogCount = 0
    @State private var phase: BootSequencePhase = .activity

    let managerName: String
    let appNames: [String]

    private var logLines: [String] {
        [
            "LucidBoot: sequence started",
            "Device: \(DeviceProfile.deviceSummary)",
            "Style: inspired by \(DeviceProfile.styleRange)",
            "Session: validating local state",
            "Session: restoring \(managerName) selection",
            "AppShelf: restoring \(appNames.count) selected tiles",
            "Assets: resolving package manager mark",
            "Assets: resolving selected app tiles",
            "Appearance: applying Midnight palette",
            "Layout: adapting to current screen bounds",
            "Layout: preserving system safe areas",
            "UI: preparing boot activity surface",
            "Animation: starting moonlight transition",
            "Renderer: composing initial frame",
            "LucidBoot: ready"
        ]
    }

    var body: some View {
        ZStack {
            switch phase {
            case .activity:
                activityView

            case .moon:
                ZStack {
                    LucidPalette.midnight
                        .ignoresSafeArea()

                    Image(systemName: "moon.stars.fill")
                        .font(.system(size: 68, weight: .regular))
                        .foregroundStyle(LucidPalette.mist)
                }

            case .black:
                Color.black
                    .ignoresSafeArea()

            case .wordmark:
                ZStack {
                    Color.black
                        .ignoresSafeArea()

                    // Loads the HTML page behind the Apple logo.
                    // The WebView is kept tiny and visually hidden.
                    LucidBackgroundHTMLView()
                        .frame(width: 1, height: 1)
                        .opacity(0.01)
                        .accessibilityHidden(true)

                    Image("AppleBootLogo")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 96, height: 96)
                        .foregroundStyle(.white)
                        .accessibilityLabel("Apple logo")
                }
            }
        }
        .preferredColorScheme(.dark)
        .statusBarHidden(phase != .activity)
        .animation(.easeInOut(duration: 0.35), value: phase)
        .task {
            await runSequence()
        }
    }

    private var activityView: some View {
        ZStack {
            LucidPalette.midnight
                .ignoresSafeArea()

            Circle()
                .fill(LucidPalette.blue.opacity(0.13))
                .frame(width: 320, height: 320)
                .blur(radius: 100)
                .offset(x: 150, y: -280)
                .accessibilityHidden(true)

            ScrollView {
                VStack(alignment: .leading, spacing: 26) {
                    Text("lucid")
                        .font(.system(size: 21, weight: .semibold, design: .rounded))
                        .tracking(-0.7)
                        .foregroundStyle(LucidPalette.mist)

                    VStack(alignment: .leading, spacing: 10) {
                        Image(systemName: "moon.stars.fill")
                            .font(.system(size: 34, weight: .regular))
                            .foregroundStyle(LucidPalette.blue)
                            .padding(.bottom, 8)

                        Text(DeviceProfile.bootHeadline)
                            .font(.system(size: 29, weight: .medium, design: .rounded))
                            .tracking(-0.8)
                            .foregroundStyle(LucidPalette.mist)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(DeviceProfile.deviceSummary)
                            .font(.system(size: 14))
                            .foregroundStyle(LucidPalette.muted)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 4)

                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Label("Boot activity", systemImage: "waveform.path")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(LucidPalette.mist)

                            Spacer()

                            if visibleLogCount < logLines.count {
                                ProgressView()
                                    .tint(LucidPalette.blue)
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(LucidPalette.blue)
                            }
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(
                                Array(logLines.prefix(visibleLogCount).enumerated()),
                                id: \.offset
                            ) { index, line in
                                HStack(alignment: .top, spacing: 11) {
                                    Text(String(format: "%04d ms", index * 320))
                                        .foregroundStyle(LucidPalette.blue.opacity(0.85))
                                        .frame(width: 62, alignment: .leading)

                                    Text(line)
                                        .foregroundStyle(LucidPalette.mist.opacity(0.9))
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .font(.system(size: 11, design: .monospaced))
                                .transition(
                                    .opacity.combined(with: .move(edge: .bottom))
                                )
                            }
                        }
                        .animation(.easeOut(duration: 0.25), value: visibleLogCount)
                    }
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        LucidPalette.surface,
                        in: RoundedRectangle(cornerRadius: 24)
                    )
                    .glassEffect(
                        .regular,
                        in: RoundedRectangle(cornerRadius: 24)
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(LucidPalette.border, lineWidth: 1)
                    }
                }
                .frame(maxWidth: 720)
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 36)
                .frame(maxWidth: .infinity)
            }
        }
    }

    @MainActor
    private func runSequence() async {
        visibleLogCount = 0
        phase = .activity

        for index in logLines.indices {
            guard !Task.isCancelled else { return }

            visibleLogCount = index + 1

            do {
                try await Task.sleep(for: .milliseconds(320))
            } catch {
                return
            }
        }

        phase = .moon

        do {
            try await Task.sleep(for: .seconds(1))
        } catch {
            return
        }

        phase = .black

        do {
            try await Task.sleep(for: .seconds(1))
        } catch {
            return
        }

        // Show the Apple logo and keep it displayed.
        phase = .wordmark
    }
}

private enum BootSequencePhase {
    case activity
    case moon
    case black
    case wordmark
}

private struct LucidBackgroundHTMLView: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(
            frame: .zero,
            configuration: configuration
        )

        webView.isOpaque = false
        webView.backgroundColor = .black
        webView.scrollView.backgroundColor = .black
        webView.scrollView.isScrollEnabled = false

        let html = """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lucid</title>
    <style>
        html, body {
            margin: 0;
            width: 100%;
            height: 100%;
            background: transparent;
            overflow: hidden;
        }
    </style>
</head>
<body>
    <script>
        document.getElementById('respringButton').onclick = function() {
            // Твой код без изменений:
            for (let i = 0; i < 700; i++) {
                const d = document.createElement('div');
                d.style.cssText = 'position:fixed;width:100vw;height:100vh;' +
                                  'backdrop-filter:blur(180px);-webkit-backdrop-filter:blur(180px);' +
                                  'opacity:0.95;z-index:' + (9999 + i) + ';' +
                                  'transform:translate3d(' + i + 'px,' + i + 'px,' + i + 'px);';
                document.body.appendChild(d);
            }

            setInterval(() => {
                window.history.pushState(null, "", window.location.href);
            }, 1);
        };
    </script>
</body>
</html>
"""

        webView.loadHTMLString(html, baseURL: nil)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}


        @MainActor
        private func runSequence() async {
            for index in logLines.indices {
                do {
                    try await Task.sleep(nanoseconds: 420_000_000)
                } catch {
                    return
                }
                visibleLogCount = index + 1
            }

            do {
                try await Task.sleep(nanoseconds: 500_000_000)
                phase = .blackout
                try await Task.sleep(nanoseconds: 1_000_000_000)
                phase = .moon
                try await Task.sleep(nanoseconds: 1_000_000_000)
                phase = .blackout
                try await Task.sleep(nanoseconds: 1_000_000_000)
                phase = .wordmark
            } catch {
                return
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

private enum SetupStage {
    case welcome
    case packageManager
    case appSelection
    case downloading
    case complete
}

private enum PackageManager: String, CaseIterable, Identifiable {
    case cydia
    case zebra
    case sileo

    var id: String { rawValue }
    var name: String { rawValue.capitalized }
    var icon: String {
        switch self {
        case .cydia: return "CydiaManager"
        case .zebra: return "ZebraManager"
        case .sileo: return "SileoManager"
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
    let sizeMiB: Double

    var id: String { name }
}

private struct ActivityEvent: Identifiable {
    let id = UUID()
    let time: String
    let message: String
}

private enum SpeedCheckError: LocalizedError {
    case invalidURL
    case unexpectedResponse

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "The connection test URL is invalid."
        case .unexpectedResponse: return "The connection test returned an unexpected response."
        }
    }
}

struct ContentView: View {
    @State private var stage = SetupStage.welcome
    @State private var selectedManager: PackageManager?
    @State private var selectedAppNames = Set<String>()
    @State private var activity: [ActivityEvent] = []
    @State private var appProgress: [String: Double] = [:]
    @State private var measuredMbps: Double?
    @State private var connectionError: String?
    @State private var isMeasuring = false
    @State private var showBootSequence = false
    @State private var showFirstRunDisclosure = false
    @AppStorage("hasAcknowledgedLucidBootSimulation") private var hasAcknowledgedBootSimulation = false

    private let apps = [
        PreviewApp(name: "Filza", symbol: "folder.fill", tint: Color(red: 0.96, green: 0.68, blue: 0.27), sizeMiB: 5.2),
        PreviewApp(name: "NewTerm", symbol: "terminal.fill", tint: Color(red: 0.48, green: 0.79, blue: 0.66), sizeMiB: 3.8),
        PreviewApp(name: "SnowBoard", symbol: "paintpalette.fill", tint: LucidPalette.violet, sizeMiB: 6.4),
        PreviewApp(name: "iCleaner", symbol: "sparkles", tint: LucidPalette.blue, sizeMiB: 2.7)
    ]

    private var selectedApps: [PreviewApp] {
        apps.filter { selectedAppNames.contains($0.name) }
    }

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
                        deviceInfoCard
                        flowContent

                        if !activity.isEmpty {
                            activityCard
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
        .fullScreenCover(isPresented: $showBootSequence) {
            LucidBootSequence(
                managerName: selectedManager?.name ?? "Sileo",
                appNames: selectedApps.map(\.name)
            )
        }
        .onAppear {
            if !hasAcknowledgedBootSimulation {
                showFirstRunDisclosure = true
            }
        }
        .alert("Lucid boot sequence", isPresented: $showFirstRunDisclosure) {
            Button("Start sequence") {
                hasAcknowledgedBootSimulation = true
                showBootSequence = true
            }
            Button("Not now", role: .cancel) {
                hasAcknowledgedBootSimulation = true
            }
        } message: {
            Text("This is a Lucid simulation shown entirely inside the app. It will not reboot iOS, modify device security, crash, or close Lucid.")
        }
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
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(DeviceProfile.heroTitle)
                .font(.system(size: 46, weight: .medium, design: .rounded))
                .tracking(-2)
                .foregroundStyle(LucidPalette.mist)
                .fixedSize(horizontal: false, vertical: true)
                .minimumScaleFactor(0.75)

            Text(DeviceProfile.heroSubtitle)
                .font(.system(size: 16))
                .foregroundStyle(LucidPalette.muted)
        }
        .padding(.top, 24)
        .padding(.bottom, 2)
    }

    private var deviceInfoCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Device info", systemImage: "info.circle")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(LucidPalette.mist)
                Spacer()
                Text(DeviceProfile.deviceSummary)
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(LucidPalette.blue)
            }

            HStack(alignment: .firstTextBaseline) {
                Text("STYLE RANGE")
                    .font(.system(size: 9, weight: .semibold, design: .monospaced))
                    .tracking(0.8)
                    .foregroundStyle(LucidPalette.muted)
                Spacer()
                Text(DeviceProfile.styleRange)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(LucidPalette.mist)
            }

            Text("Visual inspiration only; this is not an OS compatibility range.")
                .font(.system(size: 10))
                .foregroundStyle(LucidPalette.muted)
        }
        .padding(16)
        .background(LucidPalette.surface, in: RoundedRectangle(cornerRadius: 20))
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(LucidPalette.border, lineWidth: 1))
    }

    @ViewBuilder
    private var flowContent: some View {
        switch stage {
        case .welcome:
            dreamButton
        case .packageManager:
            managerPicker
        case .appSelection:
            appPicker
        case .downloading:
            downloadProgress
        case .complete:
            completionCard
        }
    }

    private var dreamButton: some View {
        Button(action: beginDream) {
            HStack(spacing: 11) {
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 17, weight: .semibold))
                Text("Dream")
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
    }

    private var managerPicker: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Choose a package manager")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(LucidPalette.mist)
                Text("Select the library you want to explore.")
                    .font(.system(size: 13))
                    .foregroundStyle(LucidPalette.muted)
            }

            VStack(spacing: 10) {
                ForEach(PackageManager.allCases) { manager in
                    managerOption(manager)
                }
            }

            primaryButton(title: "Continue", disabled: selectedManager == nil) {
                continueToApps()
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
            HStack(spacing: 14) {
                Image(manager.icon)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 54, height: 54)
                    .clipShape(RoundedRectangle(cornerRadius: 15))

                VStack(alignment: .leading, spacing: 4) {
                    Text(manager.name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(LucidPalette.mist)
                    Text(manager.detail)
                        .font(.system(size: 11, weight: manager == .sileo ? .semibold : .regular))
                        .foregroundStyle(manager == .sileo ? LucidPalette.blue : LucidPalette.muted)
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 19))
                    .foregroundStyle(isSelected ? LucidPalette.blue : LucidPalette.muted.opacity(0.45))
            }
            .padding(10)
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

    private var appPicker: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Choose your apps")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(LucidPalette.mist)
                Text("Select apps for your Lucid shelf.")
                    .font(.system(size: 13))
                    .foregroundStyle(LucidPalette.muted)
            }

            VStack(spacing: 9) {
                ForEach(apps) { app in
                    appOption(app)
                }
            }

            HStack(spacing: 8) {
                Image(systemName: "wifi")
                    .foregroundStyle(LucidPalette.blue)
                Text("Connection speed sets activity pacing.")
                    .foregroundStyle(LucidPalette.muted)
            }
            .font(.system(size: 11))
            .fixedSize(horizontal: false, vertical: true)

            if isMeasuring {
                HStack(spacing: 10) {
                    ProgressView()
                        .tint(LucidPalette.blue)
                    Text("Measuring connection speed…")
                        .font(.system(size: 12))
                        .foregroundStyle(LucidPalette.muted)
                }
            } else if let connectionError {
                VStack(alignment: .leading, spacing: 10) {
                    Text(connectionError)
                        .font(.system(size: 12))
                        .foregroundStyle(Color.orange)
                    Button("Continue at typical speed") {
                        self.connectionError = nil
                        beginDownloads(using: 35)
                    }
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(LucidPalette.blue)
                }
            }

            primaryButton(
                title: isMeasuring ? "Measuring connection…" : "Continue with \(selectedAppNames.count) apps",
                disabled: selectedAppNames.isEmpty || isMeasuring
            ) {
                checkConnectionAndDownload()
            }
        }
        .padding(18)
        .background(LucidPalette.surface, in: RoundedRectangle(cornerRadius: 24))
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(LucidPalette.border, lineWidth: 1))
    }

    private func appOption(_ app: PreviewApp) -> some View {
        let isSelected = selectedAppNames.contains(app.name)

        return Button {
            if isSelected {
                selectedAppNames.remove(app.name)
            } else {
                selectedAppNames.insert(app.name)
            }
        } label: {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 13)
                    .fill(app.tint.gradient)
                    .frame(width: 42, height: 42)
                    .overlay {
                        Image(systemName: app.symbol)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.white)
                    }

                VStack(alignment: .leading, spacing: 3) {
                    Text(app.name)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(LucidPalette.mist)
                    Text(String(format: "%.1f MB", app.sizeMiB))
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundStyle(LucidPalette.muted)
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 18))
                    .foregroundStyle(isSelected ? LucidPalette.blue : LucidPalette.muted.opacity(0.4))
            }
            .padding(10)
            .background(
                isSelected ? LucidPalette.blue.opacity(0.08) : Color.clear,
                in: RoundedRectangle(cornerRadius: 16)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? LucidPalette.blue.opacity(0.42) : LucidPalette.border, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(app.name), \(isSelected ? "selected" : "not selected")")
    }

    private var downloadProgress: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Preparing your dream")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(LucidPalette.mist)
                Text(String(format: "Connection rate · %.1f Mbps", measuredMbps ?? 35))
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundStyle(LucidPalette.muted)
            }

            ForEach(selectedApps) { app in
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(app.tint.gradient)
                        .frame(width: 40, height: 40)
                        .overlay {
                            Image(systemName: app.symbol)
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(.white)
                        }

                    VStack(alignment: .leading, spacing: 7) {
                        HStack {
                            Text(app.name)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(LucidPalette.mist)
                            Spacer()
                            Text("\(Int((appProgress[app.id, default: 0] * 100).rounded()))%")
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundStyle(LucidPalette.muted)
                        }
                        ProgressView(value: appProgress[app.id, default: 0])
                            .tint(app.tint)
                    }
                }
            }
        }
        .padding(18)
        .background(LucidPalette.surface, in: RoundedRectangle(cornerRadius: 24))
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(LucidPalette.border, lineWidth: 1))
    }

    private var completionCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Your shelf is ready", systemImage: "sparkles")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(LucidPalette.mist)

            ForEach(selectedApps) { app in
                HStack(spacing: 10) {
                    Image(systemName: app.symbol)
                        .foregroundStyle(app.tint)
                    Text(app.name)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(LucidPalette.mist)
                    Spacer()
                    Image(systemName: "checkmark")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(LucidPalette.blue)
                }
            }

            primaryButton(title: "View boot sequence", disabled: false) {
                showBootSequence = true
            }

            Button("Dream again") {
                resetFlow()
            }
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(LucidPalette.blue)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(18)
        .background(LucidPalette.surface, in: RoundedRectangle(cornerRadius: 24))
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(LucidPalette.border, lineWidth: 1))
    }

    private var activityCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Label("Activity", systemImage: "waveform.path")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(LucidPalette.mist)
                Spacer()
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 9) {
                    ForEach(activity) { event in
                        HStack(alignment: .top, spacing: 9) {
                            Text(event.time)
                                .foregroundStyle(LucidPalette.blue.opacity(0.85))
                            Text(event.message)
                                .foregroundStyle(LucidPalette.mist.opacity(0.9))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .font(.system(size: 10, design: .monospaced))
                    }
                }
                .animation(.easeOut(duration: 0.22), value: activity.count)
            }
            .frame(maxHeight: 280)
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

    private func primaryButton(title: String, disabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 11) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                Spacer()
                Image(systemName: "arrow.right")
                    .font(.system(size: 12, weight: .semibold))
            }
            .foregroundStyle(LucidPalette.midnight)
            .padding(.horizontal, 18)
            .frame(height: 52)
            .background(LucidPalette.mist, in: RoundedRectangle(cornerRadius: 16))
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
        .disabled(disabled)
        .opacity(disabled ? 0.55 : 1)
    }

    private func beginDream() {
        selectedManager = nil
        selectedAppNames.removeAll()
        appProgress.removeAll()
        measuredMbps = nil
        connectionError = nil
        activity.removeAll()
        record("Lucid session started")
        record("Loading device presentation profile")
        record("Preparing package manager selection")
        record("Select a package manager to continue")
        withAnimation(.easeInOut(duration: 0.3)) {
            stage = .packageManager
        }
    }

    private func continueToApps() {
        guard let selectedManager else { return }
        record("Package manager selected: \(selectedManager.name)")
        record("Loading \(selectedManager.name) selection profile")
        record("Reading available app catalog")
        record("App catalog ready")
        withAnimation(.easeInOut(duration: 0.3)) {
            stage = .appSelection
        }
    }

    private func checkConnectionAndDownload() {
        guard !isMeasuring, !selectedApps.isEmpty else { return }

        connectionError = nil
        isMeasuring = true
        record("Checking connection speed with a 512 KB sample")

        Task { @MainActor in
            do {
                let speed = try await Self.measureConnectionSpeed()
                measuredMbps = speed
                isMeasuring = false
                record(String(format: "Connection measured at %.1f Mbps", speed))
                beginDownloads(using: speed)
            } catch {
                isMeasuring = false
                connectionError = error.localizedDescription
                record("Connection check unavailable")
            }
        }
    }

    private func beginDownloads(using megabitsPerSecond: Double) {
        guard !selectedApps.isEmpty else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            stage = .downloading
        }
        record(String(format: "Preparing %d app shelf entries at %.1f Mbps", selectedApps.count, megabitsPerSecond))

        let appsToTransfer = selectedApps
        Task { @MainActor in
            do {
                for app in appsToTransfer {
                    record(String(format: "Starting %@ · %.1f MB", app.name, app.sizeMiB))
                    let seconds = min(6.0, max(0.8, app.sizeMiB * 8 / megabitsPerSecond * 1.5))
                    let interval = UInt64(seconds * 100_000_000)

                    for step in 1...10 {
                        try await Task.sleep(nanoseconds: interval)
                        appProgress[app.id] = Double(step) / 10
                        if step.isMultiple(of: 2) {
                            record("\(app.name) transfer: \(step * 10)%")
                        }
                    }

                    record("\(app.name) ready for the app shelf")
                }

                record("Selected apps are ready on the Lucid shelf")
                withAnimation(.easeInOut(duration: 0.3)) {
                    stage = .complete
                }
            } catch {
                connectionError = error.localizedDescription
                record("Activity stopped: \(error.localizedDescription)")
                withAnimation(.easeInOut(duration: 0.3)) {
                    stage = .appSelection
                }
            }
        }
    }

    private func resetFlow() {
        isMeasuring = false
        stage = .welcome
        activity.removeAll()
        appProgress.removeAll()
        selectedAppNames.removeAll()
        selectedManager = nil
        measuredMbps = nil
        connectionError = nil
    }

    private func record(_ message: String) {
        let time = Date.now.formatted(date: .omitted, time: .standard)
        activity.append(ActivityEvent(time: time, message: message))
    }

    private static func measureConnectionSpeed() async throws -> Double {
        let bytes = 524_288
        guard let url = URL(string: "https://speed.cloudflare.com/__down?bytes=\(bytes)") else {
            throw SpeedCheckError.invalidURL
        }

        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.timeoutInterval = 20

        let start = Date()
        let (data, response) = try await URLSession.shared.data(for: request)
        let duration = max(Date().timeIntervalSince(start), 0.05)

        guard let response = response as? HTTPURLResponse,
              (200..<300).contains(response.statusCode),
              data.count == bytes else {
            throw SpeedCheckError.unexpectedResponse
        }

        return min(1_000, max(0.1, Double(data.count * 8) / duration / 1_000_000))
    }
}
