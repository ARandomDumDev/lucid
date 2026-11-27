### DOES NOT WORK YET ITLL WORK WHEN THIS MESSAGE IS REMOVED

# lucid

Your phone is dreaming.

# what is it
A new all in one iDevice tool, it can jailbreak your device, it can semi-jailbreak, it can change MobileGestalt, it just depends on the software and hardware supported, you just need to make sure your phone isn't too caffeinated! It’s like lucid dreaming, but for your iPhone
 
  # boring legal stuff
App-selection tiles use SF Symbols
because redistribution permission for those apps' artwork was not
clear. Package-manager icon attributions and licenses are in
[THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) and in [LICENSES](LICENSES).

## Build an IPA

The **Build iOS preview** GitHub Actions workflow runs on pull requests
to `main`, pushes to `main`, and can also be started manually. It uses
the macOS 26 runner's default Xcode 26 toolchain, builds for iOS 26, and
publishes `Lucid-unsigned.ipa` as the `lucid-unsigned-ipa` workflow
artifact.

The IPA is unsigned and is not ready to install on a device without
appropriate signing.
