help:
	@echo "make up"
	@echo "make down"

up:
	@bash scripts/check.sh
	@bash scripts/namespaces.sh up
	@bash scripts/minios.sh up
	@bash scripts/argo.sh up
	@bash scripts/workflow.sh up


bootstrap:
	cd bootstrap && make install && make run


down:
	-@bash scripts/minios.sh down
	-@bash scripts/argo.sh down
	-@bash scripts/workflow.sh down
	@bash scripts/namespaces.sh down
