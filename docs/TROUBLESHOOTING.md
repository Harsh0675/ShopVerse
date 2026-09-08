# ShopVerse Troubleshooting

## Backend health check fails

Make sure PostgreSQL is running and the Node.js API is started from `backend`:

```bash
npm install
node src/server.js
```

Then verify the API:

```bash
curl http://localhost:4000/api/health
```

## Flutter cannot reach the API on Android

Android emulators use `10.0.2.2` to reach the host machine. Start the app with:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:4000/api
```

For a physical Android device, use the host computer's LAN IP address instead.

## Flutter dependencies are outdated

Run:

```bash
flutter pub get
flutter analyze
flutter test
```

If the project reports SDK compatibility errors, use a Flutter version compatible with the project's declared SDK constraints.

## Database connection problems

Check that PostgreSQL is running and that the backend environment variables contain the correct database host, port, database name, username, and password.

## Release build issues

Check the latest GitHub Actions run for the failing platform. Reproduce the relevant Flutter analysis/tests locally before changing the release workflow.
