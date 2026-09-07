# ShopVerse v7 Multi-Platform Release

Supported targets:
- Android: APK + Android App Bundle
- iOS: release build workflow (unsigned by default)
- Windows: desktop release
- Linux: desktop release
- macOS: desktop release

## GitHub release
Create a tag such as `v7.0.0`. The release workflow builds each target and uploads artifacts. It also creates a GitHub Release for version tags.

## Required for store distribution
Android signing keystore and Play Console credentials must be stored as GitHub Actions secrets.
iOS requires Apple certificates/provisioning/App Store Connect credentials for a signed IPA.
Windows/macOS/Linux installers and signing/notarization are deployment-specific.

Set repository variable:
`API_BASE_URL=https://your-api.example.com/api`

Do not put secrets or payment/LLM keys in Flutter source.
