# Security

Never commit:
- JWT secrets
- payment provider secrets
- LLM API keys
- database passwords
- signing keys

For production:
- HTTPS everywhere
- managed secrets
- restrictive CORS
- rate limiting at edge and application layers
- schema/request validation
- dependency scanning
- database backups
- audit logs
- least-privilege DB roles
- PCI-compliant hosted/tokenized payment flow
