# 🎮 Game Ops Platform - Infrastructure

**Stage 1** — Core infrastructure skeleton for the GameOps Platform.

This repository provides a pre-configured environment to manage identity and data, ensuring a "single-button" startup for the entire development ecosystem.

---

## 🏗 System Components

| Service | Technology | Port | Purpose |
| :--- | :--- | :--- | :--- |
| **API Gateway** | Spring Cloud Gateway | **8081** | Entry point, OAuth2 login, sessions & routing |
| **Main Service** | Spring Boot 3 | 8082 (internal) | Core Business Logic |
| **Identity** | Keycloak 23 | 8080 | OIDC Provider, Auth & RBAC |
| **Database** | Postgres 16 | 5432 | Storage for Platform & Identity |
| **Gateway Sessions** | Redis 7.4 | internal | SecurityContext and OAuth2 authorized clients |

---

## 🚀 Quick Start

### 1. Prepare Environment
Create a `.env` file in the root directory:
```bash
# Postgres
POSTGRES_USER=admin
POSTGRES_PASSWORD=password

# Keycloak Admin Console
KEYCLOAK_ADMIN=admin
KEYCLOAK_ADMIN_PASSWORD=admin
GAME_GATEWAY_CLIENT_SECRET=replace_with_gateway_client_secret

# Keycloak DB Connection
KC_DB_USERNAME=admin
KC_DB_PASSWORD=password

# Gateway sessions
GATEWAY_SESSION_REDIS_PASSWORD=replace_with_gateway_session_redis_password
GATEWAY_SESSION_TTL=7d
GATEWAY_SESSION_COOKIE_MAX_AGE=7d

# Spring Profiles
# 'dev' disables JWT issuer validation for local development
SPRING_PROFILES_ACTIVE=dev,docker

# Sentry (optional for local development)
SENTRY_DSN=https://test.sentry.io
SENTRY_ENVIRONMENT=local
SENTRY_RELEASE=main-service-local
```

Replace both `replace_with_...` values before starting Docker Compose. Startup fails deliberately when either Gateway secret is missing.

### 2. Launch
```bash
docker compose up -d --build
```

### Verify
API Gateway (Entry): http://localhost:8081/actuator/health

Keycloak Console: http://localhost:8080

Realm: game-realm (auto-imported)

## 🔐 Development Access

> ⚠️ **IMPORTANT:** These credentials are pre-configured in `game-realm.json` for development purposes.

| Username | Password | Roles |
| :--- | :--- | :--- |
| **admin_user** | `admin` | `admin`, `superadmin` |
| **test_user** | `test` | `user` |

Authentication is started by the API Gateway. The browser receives only the `GAME_SESSION` cookie; Keycloak tokens are stored in the dedicated Gateway Redis instance.

The Redis/WebSession TTL and browser cookie lifetime are both seven days by default. Closing the browser therefore keeps the user signed in until the session expires, is revoked, or the user logs out.

The `game-frontend` public Keycloak client is intentionally not created. The frontend must use Gateway login and session endpoints.

The business services do not publish HTTP ports to the host. Browser traffic must enter through port `8081`, where the Gateway removes untrusted `X-User-*` headers and injects the verified user context. Do not add host `ports` mappings for `main-service`, `player-profile-service`, `joint-purchase-service`, `notification-service`, or `trust-score-service`.

> Keycloak imports a realm only when it does not already exist. After changing the realm template, update the existing development realm manually or recreate the local development data before testing the new client.

---

## 📦 Database Management

We use a **Database-per-Service** pattern:
- `main_db`: Primary DB for content services (auto-created by Docker env).
- `keycloak_db`: Dedicated DB for Keycloak (created via `postgres-init/01-init.sql`).

**To reset databases and re-run init scripts:**
```bash
docker compose down -v
docker compose up -d
```

## 🛠 Project Structure

- `postgres-init/`: SQL scripts executed ONLY on first container startup.
- `keycloak-import/`: Realm configuration (roles, clients, and dev users).
- `pg-data/`: Local directory for persistent DB storage (ignored by Git).
- `gateway_session_redis_data`: Dedicated persistent storage for Gateway sessions and OAuth2 authorized clients.

---

## 🛑 Security Notice

- **Production:** This setup uses `start-dev` mode. For production, SSL/TLS and a proper reverse proxy (Nginx/Traefik) are mandatory.
- **Secrets:** Never commit your actual `.env` file to version control.

---

## 📄 License

MIT
