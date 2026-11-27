# Lucid

Your phone is dreaming.

Lucid is a native iPhone and iPad interface concept inspired by a
different state of iOS. Choose Cydia, Zebra, or recommended Sileo and
follow the staged setup simulation with a sample app shelf. The logs and
app transfers are simulated; no jailbreak code runs and no packages
are downloaded or installed, and the boot screen does not reboot iOS.
On first launch, a notice explains the in-app boot animation; it ends
with Lucid branding and does not close the app.
The displayed iOS 7–iOS 27 range describes visual inspiration, not OS
compatibility; the app requires iOS 26 or later.
A 512 KB request to Cloudflare's speed test measures the active
connection and scales the simulated transfer timing; if it fails, a
typical simulated rate is available. Device details show the device
family and iOS version. App-selection tiles use SF Symbols
because redistribution permission for those apps' artwork was not
clear. Package-manager icon attributions and licenses are in
[THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).

## Build an IPA

The **Build iOS preview** GitHub Actions workflow runs on pull requests
to `main`, pushes to `main`, and can also be started manually. It uses
the macOS 26 runner's default Xcode 26 toolchain, builds for iOS 26, and
publishes `Lucid-unsigned.ipa` as the `lucid-unsigned-ipa` workflow
artifact.

The IPA is unsigned and is not ready to install on a device without
appropriate signing.
