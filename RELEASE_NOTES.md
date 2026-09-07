# v6.0.0

- Production API hardening headers/rate limits retained.
- Request validation for order creation.
- Idempotency support for order creation using `Idempotency-Key`.
- Provider-neutral payment intent interface.
- Coupon validation endpoint and database table.
- Configurable Flutter API URL with `--dart-define=API_BASE_URL=...`.
- Admin operations dashboard refresh.
- CI foundation retained.

## Example release build
flutter build apk --release --dart-define=API_BASE_URL=https://api.example.com/api
