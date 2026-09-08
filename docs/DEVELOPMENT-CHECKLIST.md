# ShopVerse Development Checklist

Before opening a pull request:

- [ ] Run `flutter pub get` in `mobile`.
- [ ] Run `flutter analyze`.
- [ ] Run `flutter test`.
- [ ] Install backend dependencies with `npm install`.
- [ ] Verify `GET /api/health` responds successfully.
- [ ] Confirm secrets and database credentials are not committed.
- [ ] Describe the change and testing performed in the pull request.