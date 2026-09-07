# API production notes

The Express service exposes health, catalog, authentication, and order endpoints.
Before production:
1. Set a strong JWT_SECRET.
2. Use a managed PostgreSQL instance.
3. Add rate limiting and request validation.
4. Configure HTTPS and restrictive CORS.
5. Integrate a PCI-compliant payment provider; never store raw card data.
6. Add object storage/CDN for product images.
7. Add email/push notifications.
8. Add observability, backups, migrations and CI/CD.
