# ShopVerse API Quickstart

The backend exposes a REST API on port `4000` by default.

## Start the API

```bash
cd backend
npm install
node src/server.js
```

## Verify it is running

```bash
curl http://localhost:4000/api/health
```

## Useful endpoints

| Method | Endpoint | Purpose |
|---|---|---|
| GET | `/api/health` | Health check |
| GET | `/api/categories` | List categories |
| GET | `/api/products` | List products |
| POST | `/api/auth/register` | Register a user |
| POST | `/api/auth/login` | Authenticate a user |
| POST | `/api/ai/recommend` | Get product recommendations |

For authenticated endpoints, use the JWT returned by the authentication flow as a bearer token.