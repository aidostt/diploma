SERVICES := main-api-gateway authentication-service notification-service qrcode-service reservation-service

.PHONY: up down build rebuild ps logs restart test lint tidy help

help: ## Show available targets
	@grep -hE '^[a-zA-Z_-]+:.*## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

up: ## Build (if needed) and start the full stack in the background
	docker compose up -d --build

down: ## Stop the stack (keeps volumes/data)
	docker compose down

build: ## Build all service images without starting them
	docker compose build

rebuild: ## Rebuild images from scratch (no cache) and restart
	docker compose build --no-cache
	docker compose up -d

ps: ## Show container status
	docker compose ps

logs: ## Tail logs of every service (Ctrl+C to stop); make logs S=api-gateway for one
	docker compose logs -f $(S)

restart: ## Restart one service: make restart S=reservation-service
	docker compose restart $(S)

test: ## Run every service's tests (integration tests need Docker)
	@for s in $(SERVICES); do \
		echo "==== $$s ===="; \
		(cd $$s && go test ./...) || exit 1; \
	done

lint: ## Run golangci-lint in every service
	@for s in $(SERVICES); do \
		echo "==== $$s ===="; \
		(cd $$s && golangci-lint run ./...) || exit 1; \
	done

tidy: ## go mod tidy in every service
	@for s in $(SERVICES); do (cd $$s && go mod tidy); done
