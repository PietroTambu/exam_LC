.DEFAULT_GOAL := help
ROOT:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
SHELL := /bin/zsh

# Args
FILE?=simple
SIMPLE?=default
ROOT:=$(dir $(realpath $(firstword $(MAKEFILE_LIST))))
YACC=/opt/byaccj_arm64/byaccj
JFLEX=/opt/jflex-1.9.1/bin/jflex
STACKMACHINE=$(ROOT)stackMachine
JAVAC=$(shell command -v javac)

# Colors
GRAY="\033[1;30m"
RED="\033[1;31m"
GREEN="\033[32m"
HGREEN="\033[1;32m"
YELLOW="\033[1;33m"
LYELLOW="\033[33m"
BLUE="\033[1;34m"
LBLUE="\033[34m"
PINK="\033[35m"
CYAN="\033[1;36m"
WHITE="\033[0;37m"
NOCOLOR="\033[0m\033[K"

# Utils
define logInfo
	@printf $(GREEN)"${1}"$(NOCOLOR)"\n"
endef

define logValue
	@printf $(LYELLOW)"${1}: "$(WHITE)"${2}"$(NOCOLOR)"\n"
endef


help: ## Display this help message
	@echo
	@printf $(HGREEN)=$(BLUE)-------------------------------------------------$(HGREEN)=$(NOCOLOR)"\n"
	@printf $(HGREEN)="                BYACCJ / JFlex                   "=$(NOCOLOR)"\n"
	@printf $(HGREEN)=$(BLUE)-------------------------------------------------$(HGREEN)=$(NOCOLOR)"\n"
	@echo
	@printf $(LYELLOW)"Please use \`make <target>\` where <target> is one of\n\n"$(NOCOLOR)
	@grep -E '(^[0-9a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf $(GREEN)"%-25s"$(NOCOLOR)"%s\n", $$1, $$2}' | sed -e "s/\[32m##/[36m/"

.PHONY: help


##
##ByaccJ Lex command:
##


verify: ## Verify if FILE.y and FILE.l exists
	@if [ ! -f "./${FILE}.l" ] || [ ! -f "./${FILE}.y" ]; then \
		echo "Cannot find ./${FILE}.l and/or ./${FILE}.y. Exit...\n"; \
		exit 1; \
	fi

.PHONY: verify

build: BUILD_DIR=${ROOT}build/${FILE}/
build: verify ## Build Parser.class executable
	@mkdir -p ${BUILD_DIR}
	@if [ -n "$(wildcard $(BUILD_DIR)*)" ]; then rm -f $(BUILD_DIR)*; fi
	@cp ${FILE}.y ${FILE}.l ${BUILD_DIR}
	@$(YACC) -Jclass=Parser ${BUILD_DIR}${FILE}.y || exit 1
	@mv *.java ${BUILD_DIR}
	@$(JFLEX) ${BUILD_DIR}${FILE}.l || exit 1
	@$(JAVAC) $(ROOT)/build/${FILE}/*.java || exit 1
	@rm -f $(BUILD_DIR)${FILE}.y $(BUILD_DIR)${FILE}.l || exit 1

.PHONY: build

execute: ## Execute java Parser
execute: build
	@cp ${SIMPLE}.s ${ROOT}build/${FILE}/${SIMPLE}.s
	@cd ${ROOT}build/${FILE}/; java Parser < ${SIMPLE}.s > ${SIMPLE}.txt
	@$(STACKMACHINE) ${ROOT}build/${FILE}/$(SIMPLE).txt

.PHONY: execute



##
##