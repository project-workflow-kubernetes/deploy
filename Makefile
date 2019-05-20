.PHONY: bootstrap


help:
	@echo "make is-ready"
	@echo "make up"
	@echo "make down"
	@echo "make expose-minios"


is-ready:
	@bash scripts/check.sh check-dependencies
	@bash scripts/check.sh check-cluster
	@bash scripts/check.sh check-ports

up:
	@bash scripts/check.sh check-ports
	@bash scripts/namespaces.sh up
	@bash scripts/minios.sh up
	@bash scripts/argo.sh up
	@bash scripts/workflow.sh up

down:
	-@bash scripts/minios.sh down
	-@bash scripts/argo.sh down
	-@bash scripts/workflow.sh down
	@bash scripts/namespaces.sh down


expose-minios:
	@bash scripts/minios.sh expose
