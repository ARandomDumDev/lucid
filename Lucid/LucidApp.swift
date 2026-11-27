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

struct ContentView: View {
    @State private var isDreaming = false
    @State private var showAbout = false

    private var deviceDescription: String {
        let device = UIDevice.current
        return "\(device.model) · iOS \(device.systemVersion)"
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LucidPalette.midnight.ignoresSafeArea()

                Circle()
                    .fill(LucidPalette.blue.opacity(0.12))
                    .frame(width: 300, height: 300)
                    .blur(radius: 90)
                    .offset(x: geometry.size.width * 0.38, y: -geometry.size.height * 0.34)
                    .accessibilityHidden(true)

                ScrollView {
                    VStack(alignment: .leading, spacing: 28) {
                        header
                        hero

                        Button {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                isDreaming.toggle()
                            }
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: isDreaming ? "sun.max.fill" : "moon.stars.fill")
                                    .font(.system(size: 17, weight: .semibold))
                                Text(isDreaming ? "Return to stillness" : "Enter dream state")
                                    .font(.system(size: 16, weight: .semibold))
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 13, weight: .semibold))
                                    .opacity(0.75)
                            }
                            .foregroundStyle(LucidPalette.midnight)
                            .padding(.horizontal, 20)
                            .frame(height: 58)
                            .background(LucidPalette.mist, in: RoundedRectangle(cornerRadius: 18))
                        }
                        .buttonStyle(.plain)

                        if geometry.size.width > 700 {
                            HStack(alignment: .top, spacing: 16) {
                                deviceCard
                                previewCard
                            }
                        } else {
                            deviceCard
                            previewCard
                        }

                        footer
                    }
                    .frame(maxWidth: 900)
                    .padding(.horizontal, geometry.size.width > 700 ? 40 : 24)
                    .padding(.top, 20)
                    .padding(.bottom, 36)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .preferredColorScheme(.dark)
        .alert("A visual concept", isPresented: $showAbout) {
            Button("Got it", role: .cancel) {}
        } message: {
            Text("Lucid is a UI prototype. Its controls are illustrative and do not jailbreak, modify, or change your device.")
        }
    }

    private var header: some View {
        HStack {
            HStack(spacing: 9) {
                ZStack {
                    Circle()
                        .fill(LucidPalette.blue)
                        .frame(width: 24, height: 24)
                    Circle()
                        .fill(LucidPalette.midnight)
                        .frame(width: 19, height: 19)
                        .offset(x: 7, y: -5)
                }
                .frame(width: 26, height: 26)
                .accessibilityHidden(true)

                Text("lucid")
                    .font(.system(size: 21, weight: .semibold, design: .rounded))
                    .tracking(-0.7)
                    .foregroundStyle(LucidPalette.mist)
            }

            Spacer()

            Button {
                showAbout = true
            } label: {
                Image(systemName: "info")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(LucidPalette.mist)
                    .frame(width: 38, height: 38)
                    .background(LucidPalette.surface, in: Circle())
                    .overlay(Circle().stroke(LucidPalette.border, lineWidth: 1))
            }
            .accessibilityLabel("About this preview")
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 7) {
                Circle()
                    .fill(LucidPalette.blue)
                    .frame(width: 6, height: 6)
                Text("INTERFACE PREVIEW")
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                    .tracking(1.3)
                    .foregroundStyle(LucidPalette.blue)
            }
            .padding(.horizontal, 11)
            .padding(.vertical, 8)
            .background(LucidPalette.blue.opacity(0.11), in: Capsule())

            Text("Your phone\nis dreaming.")
                .font(.system(size: 48, weight: .medium, design: .rounded))
                .tracking(-2.2)
                .foregroundStyle(LucidPalette.mist)
                .fixedSize(horizontal: false, vertical: true)
                .minimumScaleFactor(0.75)

            Text(isDreaming
                 ? "A quiet preview of a different state of mind."
                 : "A familiar iPhone, seen in a different state.")
                .font(.system(size: 16))
                .foregroundStyle(LucidPalette.muted)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.top, 30)
        .padding(.bottom, 6)
    }

    private var deviceCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Label("Your device", systemImage: "iphone")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(LucidPalette.mist)
                Spacer()
                Text("PREVIEW")
                    .font(.system(size: 9, weight: .semibold, design: .monospaced))
                    .tracking(0.8)
                    .foregroundStyle(LucidPalette.muted)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(deviceDescription)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(LucidPalette.mist)
                Text("Device details shown for reference")
                    .font(.system(size: 12))
                    .foregroundStyle(LucidPalette.muted)
            }

            Rectangle()
                .fill(LucidPalette.border)
                .frame(height: 1)

            HStack(spacing: 10) {
                Image(systemName: "sparkles")
                    .foregroundStyle(LucidPalette.violet)
                Text(isDreaming ? "Dream state preview is on" : "Ready to explore")
                    .foregroundStyle(LucidPalette.mist)
                Spacer(minLength: 0)
            }
            .font(.system(size: 13, weight: .medium))
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(LucidPalette.surface, in: RoundedRectangle(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(LucidPalette.border, lineWidth: 1))
    }

    private var previewCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("A different state of mind", systemImage: "moon")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(LucidPalette.mist)

            Text("Explore the idea behind Lucid.")
                .font(.system(size: 13))
                .foregroundStyle(LucidPalette.muted)

            HStack(spacing: 8) {
                Image(systemName: "checkmark.shield")
                    .foregroundStyle(LucidPalette.blue)
                Text("No system changes are made")
                    .foregroundStyle(LucidPalette.mist.opacity(0.9))
            }
            .font(.system(size: 12, weight: .medium))
        }
        .padding(20)
        .frame(maxWidth: .infinity, minHeight: 150, alignment: .leading)
        .background(LucidPalette.surface, in: RoundedRectangle(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(LucidPalette.border, lineWidth: 1))
    }

    private var footer: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "info.circle")
                .padding(.top, 1)
            Text("Lucid is an interface concept only. It does not jailbreak or modify iOS.")
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
        }
        .font(.system(size: 11))
        .foregroundStyle(LucidPalette.muted.opacity(0.85))
        .padding(.top, 2)
    }
}
