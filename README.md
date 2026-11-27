# Lucid

Your phone is dreaming.

Lucid is a native iPhone and iPad interface prototype inspired by a
different state of iOS. This repository builds a **visual simulation
only**: its controls do not jailbreak, exploit, or modify the device.

## Build an IPA

The **Build iOS preview** GitHub Actions workflow runs on pushes to
`main` and can also be started manually. It builds an unsigned iOS app
and publishes `Lucid-unsigned.ipa` as the `lucid-unsigned-ipa` workflow
artifact.

The IPA is unsigned and is not ready to install on a device without
appropriate signing.
