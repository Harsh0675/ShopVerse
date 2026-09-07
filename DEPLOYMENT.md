# ShopVerse production deployment

## Local full stack
```bash
cd backend
docker compose up --build
```
API: http://localhost:4000/api/health
Admin: open `admin/index.html`.

## Production checklist
- Replace database password and JWT secret with managed secrets.
- Set a restrictive CORS origin.
- Put API behind HTTPS/reverse proxy.
- Use managed PostgreSQL with backups.
- Configure a real payment provider (Razorpay/Stripe/etc.) without storing raw card data.
- Configure app signing and store credentials in the CI secret store.
- Set the mobile API base URL to the deployed HTTPS API.
- Add rate limiting, validation, audit logs and monitoring.
- Configure an LLM provider only through server-side secrets; never ship an API key inside the Flutter binary.
