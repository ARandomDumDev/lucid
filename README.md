# Lucid

Your phone is dreaming.

Lucid is a native iPhone and iPad interface concept inspired by a
different state of iOS. Choose Cydia, Zebra, or recommended Sileo and
watch a simulated setup flow with a sample app shelf. The activity and
apps are part of the interface preview; they do not jailbreak or modify
the device.

## Build an IPA

The **Build iOS preview** GitHub Actions workflow runs on pull requests
to `main`, pushes to `main`, and can also be started manually. It uses
the macOS 26 runner's default Xcode 26 toolchain, builds for iOS 26, and
publishes `Lucid-unsigned.ipa` as the `lucid-unsigned-ipa` workflow
artifact.

The IPA is unsigned and is not ready to install on a device without
appropriate signing.
