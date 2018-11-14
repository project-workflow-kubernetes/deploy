help:
	@echo "make up"
	@echo "make down"

up:
	@bash scripts/check.sh
	-@bash scripts/minios.sh up
	-@bash scripts/argo.sh up


down:
	-@bash scripts/minios.sh down
	-@bash scripts/argo.sh down
