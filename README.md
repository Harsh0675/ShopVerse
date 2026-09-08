# 🛍️ ShopVerse

> A modern cross-platform e-commerce application built with Flutter and Dart, backed by a Node.js API and PostgreSQL.

![Flutter](https://img.shields.io/badge/Flutter-3.35.0-02569B?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart)
![Node.js](https://img.shields.io/badge/Node.js-22-339933?style=for-the-badge&logo=node.js)
![Platforms](https://img.shields.io/badge/Platforms-Android%20%7C%20Windows%20%7C%20Linux%20%7C%20macOS-3DDC84?style=for-the-badge&logo=android)

## ✨ Overview

ShopVerse is a full-stack e-commerce project designed as a single Flutter codebase for Android and desktop platforms. The repository includes the client application, backend API, database resources, administration features, and automated build/release workflows.

## 🚀 Features

- 🛒 Product catalog and shopping experience
- 🧺 Cart management with local persistence
- 🔌 REST API integration
- 🗄️ PostgreSQL database resources
- 🖥️ Admin dashboard/backend resources
- ⚙️ Automated CI checks
- 📦 Automated release builds
- 🔐 Configurable API endpoint through environment variables
- 💻 Native builds for Android, Windows, Linux, and macOS

## 🧰 Tech Stack

| Layer | Technology |
|---|---|
| Client | Flutter + Dart |
| State management | Provider |
| Networking | HTTP |
| Local storage | SharedPreferences |
| Backend | Node.js |
| Database | PostgreSQL |
| CI/CD | GitHub Actions |

## 📁 Project Structure

```text
ShopVerse/
├── mobile/                 # Flutter application
│   ├── lib/                # Dart source code
│   ├── android/            # Android platform project
│   ├── windows/            # Windows platform project
│   ├── linux/              # Linux platform project
│   └── macos/              # macOS platform project
├── backend/                # Node.js backend/API
├── .github/workflows/      # CI and release automation
└── README.md
```

## ▶️ Run Locally

### Prerequisites

- Flutter SDK
- Dart SDK compatible with the project
- Node.js 22+
- PostgreSQL, if running the backend/database locally

### Flutter app

```bash
cd mobile
flutter pub get
flutter run
```

### Backend

```bash
cd backend
npm install
node src/server.js
```

The Flutter client uses `API_BASE_URL` when supplied; otherwise the project uses its configured development API endpoint.

## 📦 Releases

Prebuilt releases are available on the GitHub Releases page.

Current release targets:

- Android — APK and AAB
- Windows — ZIP
- Linux — TAR.GZ
- macOS — ZIP

> iOS is intentionally excluded from the release pipeline because deployable iOS builds require Apple signing/provisioning. This does not affect the Android, Windows, Linux, or macOS releases.

## 🔄 CI/CD

Every push and pull request runs automated checks for the backend and Flutter application. Release workflows build and package the supported release targets automatically.

## 🧪 Quality Checks

The Flutter CI pipeline runs:

```bash
flutter pub get
flutter analyze
flutter test
```

The backend CI pipeline validates the Node.js server source before release.

## 🛠️ Configuration

The client API base URL can be overridden at build/run time:

```bash
flutter run --dart-define=API_BASE_URL=http://your-server:4000/api
```

## 📌 Current Release

**ShopVerse v8.0.0** is the current published release, with downloadable Android, Windows, Linux, and macOS packages.

## 🤝 Contributing

Contributions, bug reports, and improvements are welcome. Open an issue or pull request with a clear description of the change.

## 📄 License

See the repository license file for the applicable terms.

---

Built with Flutter, Dart, Node.js, PostgreSQL, and GitHub Actions.