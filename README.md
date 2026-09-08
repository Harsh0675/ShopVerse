# 🛍️ ShopVerse

> A modern full-stack e-commerce application built with Flutter and Dart, powered by a Node.js + PostgreSQL backend and automated GitHub Actions CI/CD.

![Flutter](https://img.shields.io/badge/Flutter-3.35.0-02569B?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart)
![Node.js](https://img.shields.io/badge/Node.js-22-339933?style=for-the-badge&logo=node.js)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Database-4169E1?style=for-the-badge&logo=postgresql)
![Platforms](https://img.shields.io/badge/Platforms-Android%20%7C%20Windows%20%7C%20Linux%20%7C%20macOS-3DDC84?style=for-the-badge&logo=flutter)

## ✨ Overview

ShopVerse is a cross-platform e-commerce project built around a single Flutter application and a Node.js REST API. It combines product discovery, search, smart recommendations, cart management, checkout, authentication, orders, coupons, and PostgreSQL persistence with automated testing and multi-platform release builds.

## 🚀 Latest Features

### 🛍️ Shopping Experience

- Product catalog with Electronics, Fashion, and Home categories
- Product cards with price and ratings
- Product detail sheets with descriptions and category information
- Product search with live suggestions/results
- Smart shopping landing experience
- AI-style product recommendations through the backend
- System light/dark theme with Material 3 UI
- Responsive Flutter UI across supported platforms

### 🛒 Cart & Checkout

- Add products directly from the catalog
- Persistent local cart storage
- Increase/decrease item quantities
- Automatic cart totals
- Checkout form for delivery address
- Payment method selection UI
- Order placement flow

### 👤 Accounts & Orders

- User registration and login
- JWT-based authentication
- Profile area
- Addresses and wishlist UI
- Authenticated order creation
- Order history and order details through the API
- Idempotency-key support for order creation

### 🤖 Smart Recommendations

The backend provides a recommendation endpoint that can filter catalog products by natural-language-style requests, including supported categories and budget limits.

### 🔌 Backend API

The Node.js API includes:

- Health check endpoint
- Product listing and product detail endpoints
- Category aggregation
- Authentication endpoints
- AI recommendation endpoint
- Authenticated order creation
- Order history and order details
- Coupon validation
- Payment-intent foundation
- PostgreSQL integration

### 🔐 Security & Reliability

- Password hashing with bcrypt
- JWT authentication with configurable secret
- API rate limiting
- CORS configuration
- Security response headers
- Request payload size limit
- Parameterized PostgreSQL queries
- Order idempotency support

## 🧰 Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter + Dart |
| UI | Material 3 |
| State management | Provider |
| Networking | HTTP |
| Local storage | SharedPreferences |
| Backend | Node.js + Express |
| Authentication | JWT + bcryptjs |
| Database | PostgreSQL |
| API | REST |
| CI/CD | GitHub Actions |

## 📁 Project Structure

```text
ShopVerse/
├── mobile/                    # Flutter application
│   ├── lib/
│   │   ├── core/              # Shared application models/config
│   │   ├── features/          # Feature modules such as cart
│   │   ├── catalog.dart        # Product catalog
│   │   └── main.dart           # Application UI and navigation
│   ├── android/                # Android platform project
│   ├── windows/                # Windows platform project
│   ├── linux/                  # Linux platform project
│   └── macos/                  # macOS platform project
├── backend/                    # Node.js REST API
│   └── src/server.js           # API server
├── .github/workflows/          # CI/CD workflows
└── README.md
```

## ▶️ Run Locally

### Prerequisites

- Flutter SDK 3.35.0 or compatible stable version
- Dart SDK compatible with the project
- Node.js 22+
- PostgreSQL

### 1. Start the backend

```bash
cd backend
npm install
node src/server.js
```

The API listens on port `4000` by default.

### 2. Run the Flutter application

```bash
cd mobile
flutter pub get
flutter run
```

For an Android emulator, the default API endpoint is configured for `10.0.2.2:4000`.

### 3. Configure the API endpoint

Override the backend URL with:

```bash
flutter run --dart-define=API_BASE_URL=http://your-server:4000/api
```

### 4. Verify the backend

Once the API is running, confirm that the health endpoint responds before launching the client:

```bash
curl http://localhost:4000/api/health
```

A successful response confirms that the backend is reachable and ready for the Flutter application.

## 🧪 Quality & CI

Every push and pull request runs automated checks.

### Flutter

```bash
flutter pub get
flutter analyze
flutter test
```

### Backend

The CI pipeline installs backend dependencies and validates the Node.js server source before release.

## 📦 Releases

The automated release pipeline produces native packages for:

| Platform | Package |
|---|---|
| Android | APK + AAB |
| Windows | ZIP |
| Linux | TAR.GZ |
| macOS | ZIP |

### Current release

**ShopVerse v8.0.0** is the latest published GitHub release, with Android, Windows, Linux, and macOS packages plus SHA-256 checksums.

View ShopVerse releases: https://github.com/Harsh0675/ShopVerse/releases

> iOS is not included in automated release packages because deployable iOS builds require Apple signing and provisioning. The other four release targets are unaffected.

## 🔄 CI/CD

GitHub Actions automatically:

1. Validates Flutter dependencies, analysis, and tests.
2. Validates the Node.js backend.
3. Generates missing Flutter platform projects when required by the release workflow.
4. Builds Android, Windows, Linux, and macOS packages.
5. Packages release artifacts.
6. Publishes the release and SHA-256 checksums.

## 🗄️ Backend API Overview

Representative endpoints include:

```text
GET  /api/health
GET  /api/categories
GET  /api/products
GET  /api/products/:id
POST /api/ai/recommend
POST /api/auth/register
POST /api/auth/login
POST /api/orders
GET  /api/orders
GET  /api/orders/:id
POST /api/payments/create-intent
POST /api/coupons/validate
```

The payment endpoint currently provides a provider configuration foundation and does not process real payments until a payment provider is configured.

## 🛠️ Development Notes

- The Flutter client can run from the same codebase on Android, Windows, Linux, and macOS.
- Backend persistence uses PostgreSQL through the `pg` package.
- The API base URL is configurable without changing Dart source code.
- Release builds are generated independently for each target platform.

## 🤝 Contributing

Contributions, bug reports, and improvements are welcome.

1. Fork the repository.
2. Create a feature branch.
3. Make and test your changes.
4. Run `flutter analyze` and `flutter test` for Flutter changes.
5. Open a pull request with a clear description.

## 📄 License

See the repository license file for the applicable terms.

---

Built with ❤️ using Flutter, Dart, Node.js, PostgreSQL, and GitHub Actions.
