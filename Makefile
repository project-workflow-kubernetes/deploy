# improve it to split in up minio and up argo
help:
	@echo "make up"
	@echo "make down"

up:
	@bash scripts/bootstrap.sh up


down:
	@bash scripts/bootstrap.sh down
