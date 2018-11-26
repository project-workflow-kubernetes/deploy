REMOTE_REPO=liabifano
DOCKER_NAME=bootstrap
DOCKER_LABEL=latest
GIT_MASTER_HEAD_SHA:=$(shell git rev-parse --short=7 --verify HEAD)
TEST_PATH=./
PROJECT_NAME=bootstrap


help:
	@echo "install"
	@echo "run"


clean-build:
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs/
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -f {} +


clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +


test: clean-pyc
	@echo "\n--- If the env $(PROJECT_NAME) doesn't exist, run 'make install' before ---\n"n
	@echo "\n--- Running tests at $(PROJECT_NAME) ---\n"
	bash -c "source activate $(PROJECT_NAME) &&  py.test --verbose --color=yes $(TEST_PATH)"


clean: clean-build clean-pyc


install: clean
	-@conda env remove -yq -n $(PROJECT_NAME) # ignore if fails
	@conda create -y --name $(PROJECT_NAME) --file conda.txt
	@echo "\n --- Creating env: $(PROJECT_NAME) in $(shell which conda) ---\n"
	@echo "\n--- Installing dependencies ---\n"
	bash -c "source activate $(PROJECT_NAME) && pip install -e . && pip install -U -r requirements.txt && source deactivate"


run:
	# @if [ $(conda env list | grep $(PROJECT_NAME) | wc -l) = 0 ]; then\
	#	@make install;\
	# fi;
	@bash -c "source activate $(PROJECT_NAME)"
	@python src/$(PROJECT_NAME)/main.py job-python src/job data https://github.com/project-workflow-kubernetes/job-python.git
