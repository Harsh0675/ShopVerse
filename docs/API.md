# ShopVerse API

Base URL: `http://localhost:4000`

## Health

`GET /api/health`

Returns a small JSON payload confirming that the API is running.

## Catalog

- `GET /api/products` — list products. Optional `q` query parameter searches by name or category.
- `GET /api/products/:id` — fetch one product.
- `GET /api/categories` — list categories with product counts.
- `POST /api/ai/recommend` — return catalog recommendations from a natural-language prompt.

## Authentication

- `POST /api/auth/register` — create an account. Requires `email` and a password of at least 8 characters.
- `POST /api/auth/login` — authenticate with `email` and `password`.

Authenticated endpoints use:

```text
Authorization: Bearer <token>
```

## Orders

- `POST /api/orders` — create an order. Requires authentication and `items`, `address`, and `total`.
- `GET /api/orders` — list the signed-in user's orders.
- `GET /api/orders/:id` — fetch one of the signed-in user's orders and its items.

For safe retries, `POST /api/orders` accepts an optional `Idempotency-Key` header.

## Coupons

`POST /api/coupons/validate` — validate an active coupon code and return its discount details.

## Payments

`POST /api/payments/create-intent` — validates payment-intent input. The current implementation returns `501` until a payment provider is configured.

## Error responses

Errors are returned as JSON with an `error` field. Common status codes include `400` for invalid input, `401` for missing/invalid authentication, `404` for missing resources, `409` for registration conflicts, `429` for rate limiting, and `500` for server/database failures.
