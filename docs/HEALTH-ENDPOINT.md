# API Health Endpoint

The backend exposes `GET /api/health` as a lightweight readiness check.

## Response

A healthy API returns JSON with:

```json
{
  "ok": true,
  "service": "shopverse-api",
  "version": "6.0.0"
}
```

The `version` field is sourced from `backend/package.json`, so it stays aligned with the backend package version when releases are updated.

## Local check

Start the backend, then run:

```bash
curl http://localhost:4000/api/health
```
