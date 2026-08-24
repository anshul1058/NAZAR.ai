# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| 1.x     | ✅        |
| < 1.0   | ❌        |

## Reporting a Vulnerability

PERISAI processes sensitive data (kid's phone screenshots, content detections). If you find a security issue, **don't open a public issue**.

### How to Report

1. **Preferred**: use [GitHub Security Advisories](https://github.com/anshul1058/periai_app/security/advisories/new) — private report, tracked, can discuss directly
2. Or email the maintainer: (to be added)

### What to Include

- Vulnerability description
- Reproduction steps
- Potential impact (data leak, RCE, etc.)
- Suggested fix (if any)

### What to Expect

- **Acknowledge** within 48 hours
- **Initial assessment** within 7 days
- **Fix timeline** communicated depending on severity
- **Credit** in release notes (unless you request anonymity)

## Scope

### In Scope

- Bugs in the Flutter app (`lib/`)
- Bugs in native Android (`android/app/src/main/kotlin/`)
- Credential / secret leaks in the repo
- RLS bypass / data leakage via Supabase
- Permission abuse (MediaProjection, Accessibility)

### Out of Scope

- Social engineering
- Physical access attacks
- Third-party services (Supabase infra, Firebase infra) — report directly to the vendor
- DoS via spamming public endpoints

## Best Practices for Users

- Don't share the pairing QR with strangers
- Make sure your kid's phone is passcode-protected
- Update the app regularly
