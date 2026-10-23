# 🎮 Game Ops Platform - Infrastructure

Production Docker Compose configuration for the GameOps Platform.

---

## 🏗 System Components

| Service | Technology | Port | Purpose |
| :--- | :--- | :--- | :--- |
| **API Gateway** | Spring Cloud Gateway | **8081** | OAuth2 login, Redis sessions and routing |
| **Main Service** | Spring Boot 3 | 8082 | Core Business Logic |
| **Identity** | Keycloak 23 | 8080 | OIDC Provider, Auth & RBAC |
| **Database** | Postgres 16 | 5432 | Storage for Platform & Identity |
| **Gateway Sessions** | Redis 7.4 | internal | SecurityContext and OAuth2 authorized clients |

---

## 🚀 Deployment preparation

### 1. Prepare Environment
Create the production `.env` file from `.env.example`. At minimum, provide strong unique values for:
```bash
GAME_GATEWAY_CLIENT_SECRET=replace_with_gateway_client_secret
GATEWAY_SESSION_REDIS_PASSWORD=replace_with_gateway_session_redis_password
GATEWAY_SESSION_TTL=7d
GATEWAY_SESSION_COOKIE_MAX_AGE=7d
```

The Gateway client secret in `.env` must exactly match the secret of the confidential `game-gateway` client in the live Keycloak realm.

### 2. Pull images and launch
```bash
docker compose pull
docker compose up -d
```

### Verify
API Gateway (server-local): http://127.0.0.1:8081/actuator/health

Keycloak (server-local): http://127.0.0.1:8080

Public access must go through the HTTPS reverse proxy.

## 🔐 Authentication

The browser receives only the secure `__Host-GAME_SESSION` cookie. Access and refresh tokens are stored in the dedicated `gateway-session-redis` instance and are never exposed to frontend JavaScript.

The `game-gateway` Keycloak client must be confidential, use the authorization code flow and allow these callback URLs:

- `https://api.gameops-platform.dev/login/oauth2/code/keycloak`
- `https://ru-api.gameops-platform.dev/login/oauth2/code/keycloak`

The Gateway maps the trusted API host to its matching frontend for login, login errors and logout:

- `api.gameops-platform.dev` → `gameops-platform.dev`
- `ru-api.gameops-platform.dev` → `ru.gameops-platform.dev`

Keep `SERVER_FORWARD_HEADERS_STRATEGY=framework` enabled so Spring uses the HTTPS host and protocol supplied by nginx.

Realm imports are applied only when the realm does not already exist. Update the existing production realm through the Keycloak Admin Console or Admin API; do not delete the realm to re-run the import.

Keep business services and both Redis instances inaccessible from the public network. Only nginx should expose the frontend, Gateway and Keycloak hostnames.

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
- `keycloak-import/`: Bootstrap realm configuration for new installations. The template is mounted read-only and rendered inside the Keycloak container so secrets are not written into the checkout.
- `pg-data/`: Local directory for persistent DB storage (ignored by Git).
- `gateway_session_redis_data`: Persistent Gateway sessions and OAuth2 authorized clients.

---

## 🛑 Security Notice

- **Production:** Keycloak runs in production mode behind an HTTPS reverse proxy. Preserve forwarded host and protocol headers in nginx.
- **Secrets:** Never commit your actual `.env` file to version control.
- **Existing servers:** Back up `.env`, the Compose file and Keycloak/Postgres data before rollout. Update local operational files selectively.

---

## 📄 License

MIT
