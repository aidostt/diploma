# Reservista

Table-reservation platform built as Go microservices: an HTTP API gateway in front of four gRPC services, PostgreSQL as the source of truth, and a full observability stack (structured logs, Prometheus metrics, OpenTelemetry tracing).

## Services

| Service | Role | Port |
|---|---|---|
| `main-api-gateway` | Public HTTP API (gin), auth middleware, rate limiting | 8000 |
| `authentication-service` | Identity: users, sessions, JWT | gRPC |
| `reservation-service` | Restaurants, tables, reservations (interval model, overlap prevention in PostgreSQL) | gRPC |
| `qrcode-service` | Reservation QR generation/scanning | gRPC |
| `notification-service` | Transactional email | gRPC |

Shared gRPC contracts live in the versioned [`protos`](https://github.com/aidostt/protos) module. Each service follows the same clean-architecture layout: `cmd/api` → `internal/{app,config,domain,service,repository,delivery,server}` → `pkg/`.

## Prerequisites

- Docker Desktop (Compose v2)
- GNU Make (optional but convenient)
- Go 1.25+ and [golangci-lint](https://golangci-lint.run) — only for local development/tests

## Configuration

Environment files are not committed. Create them once:

1. **Root `.env`** (used by compose to provision PostgreSQL):

   ```env
   POSTGRES_USER=postgres
   POSTGRES_PASSWORD=<password>
   POSTGRES_HOST=localhost
   POSTGRES_DB=reservista
   ```

2. **Per-service `.env`** — copy each service's `.env.example` to `.env` inside the service directory and fill it in. Notes:
   - `authentication-service` and `reservation-service` talk to the compose database: `POSTGRES_HOST=postgres`, `POSTGRES_PORT=5432`, and the same user/password/db as the root `.env`.
   - `JWT_SIGNING_KEY` must be identical in the gateway and the authentication service.
   - `notification-service` needs SMTP credentials; the gateway needs S3 credentials for photo upload.

## Run

```bash
make up        # build images and start everything in the background
make ps        # container status
make logs      # tail all logs (make logs S=api-gateway for one service)
make down      # stop (data is kept in the postgres volume)
```

Without make: `docker compose up -d --build`.

Migrations run automatically: `authentication-service` and `reservation-service` wait for PostgreSQL, apply their `migrations/`, then start.

### Endpoints once it's up

| What | URL |
|---|---|
| API | http://localhost:8000 (health: `/livez`, `/readyz`, metrics: `/metrics`) |
| Jaeger UI (traces) | http://localhost:16686 |
| Prometheus | http://localhost:9090 |

## Development

```bash
make test      # all tests; repository integration tests spin up disposable PostgreSQL via testcontainers
make lint      # golangci-lint across all services
```

Each service also has its own CI (vet, build, lint, race tests) in its repository.

## Repository layout

This is a multi-repo project stitched together with git submodules — clone with:

```bash
git clone --recurse-submodules git@github.com:aidostt/diploma.git
```
