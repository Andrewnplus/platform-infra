SHELL := /bin/bash
ENV_FILE := .env

help:
	@echo "make up         - 啟動所有服務"
	@echo "make down       - 停止並移除容器"
	@echo "make logs       - 追蹤所有容器日誌"
	@echo "make ps         - 查看容器狀態"
	@echo "make mysql-cli  - 進入 MySQL CLI"
	@echo "make wipe       - 危險！清空所有持久卷"

up:
	@export $$(grep -v '^#' $(ENV_FILE) | xargs) && docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f --tail=200

ps:
	docker compose ps

mysql-cli:
	docker exec -it infra-mysql mysql -uroot -p$$(grep MYSQL_ROOT_PASSWORD .env | cut -d'=' -f2)

wipe:
	docker compose down -v
