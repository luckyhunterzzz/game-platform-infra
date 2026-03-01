# 🎮 Game Ops Platform - Infrastructure

**Stage 1** — Core infrastructure skeleton for the GameOps Platform.

This repository provides a pre-configured environment to manage identity and data, ensuring a "single-button" startup for the entire development ecosystem.

---

## 🏗 System Components

| Service | Technology | Port | Purpose |
| :--- | :--- | :--- | :--- |
| **API Gateway** | Spring Cloud Gateway | **8081** | Entry point, JWT Validation & Routing |
| **Main Service** | Spring Boot 3 | 8082 | Core Business Logic |
| **Identity** | Keycloak 23 | 8080 | OIDC Provider, Auth & RBAC |
| **Database** | Postgres 16 | 5432 | Storage for Platform & Identity |

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

# Keycloak DB Connection
KC_DB_USERNAME=admin
KC_DB_PASSWORD=password

# Spring Profiles
# 'dev' disables JWT issuer validation for local development
SPRING_PROFILES_ACTIVE=dev,docker
```

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

Note: To access /api/v1/admin/** endpoints, you must obtain a JWT from Keycloak and use it as a Bearer token.
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

---

## 🛑 Security Notice

- **Production:** This setup uses `start-dev` mode. For production, SSL/TLS and a proper reverse proxy (Nginx/Traefik) are mandatory.
- **Secrets:** Never commit your actual `.env` file to version control.

---

## 📄 License

MIT
