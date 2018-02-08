#SHELL := /bin/bash
# Usage:
# make -k theme=<theme-name> all

# User arguments to make
# ======================

# theme: default  | readtheorg | labtheme
theme=default

BUILD_DIR=build

VER_BRANCH=build-release
VER_FILE=VERSION

ORG_MODE_DIR=~/emacs/lisp
LITERATE_TOOLS="https://github.com/vlead/literate-tools.git"
LITERATE_DIR=literate-tools
DEFAULT=default
LABTHEME=labtheme
ELISP_DIR=elisp
ORG_TEMPLATES_DIR=org-templates
STYLE_DIR=style
CODE_DIR=build/code
DOC_DIR=build/docs
SRC_DIR=src
PWD=$(shell pwd)
STATUS=0
all:  check-org build

check-org:
ifeq ($(wildcard ${ORG_MODE_DIR}/org-8.2.10/*),)
	mkdir -p ${ORG_MODE_DIR}
	wget http://orgmode.org/org-8.2.10.tar.gz
	tar zxvf org-8.2.10.tar.gz
	rm -rf org-8.2.10.tar.gz
	mv org-8.2.10 ${ORG_MODE_DIR}
else
	@echo "org-mode org-8.2.10 already present"
endif


build: init write-version
	emacs  --script elisp/publish.el

init: mk-symlinks
	rm -rf ${BUILD_DIR}
	mkdir -p ${BUILD_DIR} ${CODE_DIR}

mk-symlinks:  pull-literate-tools
	(ln -sf ${LITERATE_DIR}/${ELISP_DIR}; \
	 rsync -a ${LITERATE_DIR}/${ORG_TEMPLATES_DIR}/${theme}/ ${ORG_TEMPLATES_DIR}; \
	 rsync -a ${LITERATE_DIR}/${STYLE_DIR} .; \
	 rsync -a ${LITERATE_DIR}/${ORG_TEMPLATES_DIR}/tex-macros.org ${ORG_TEMPLATES_DIR}; \
	 cd ${SRC_DIR}; \
	 ln -sf ../${ORG_TEMPLATES_DIR}; \
	 ln -sf ../${STYLE_DIR}; \
	 cd ..; )


pull-literate-tools:
	@echo "checking for literate support ..."
	echo "pwd=..."
	echo ${PWD}
ifeq ($(wildcard ${LITERATE_DIR}),)
	@echo "proxy is..."
	echo $$http_proxy
	(git clone ${LITERATE_TOOLS})
else
	@echo "Literate support code already present"
endif

# variable that will exist of git command exists
# solution from: http://stackoverflow.com/questions/5618615/check-if-a-program-exists-from-a-makefile
GIT_EXISTS := $(shell command -v git 2> /dev/null)

# get the latest commit hash and its subject line
# and write that to the VERSION file
write-version:
ifdef GIT_EXISTS
	 # allow these to fail since the parent folder may not have a git repo.
	echo -n "Built from commit: " > ${CODE_DIR}/${VER_FILE}
	- echo `git rev-parse HEAD` >> ${CODE_DIR}/${VER_FILE}
	- echo `git log --pretty=format:'%s' -n 1` >> ${CODE_DIR}/${VER_FILE}
endif
clean-literate:
	rm -rf ${ELISP_DIR}
	rm -rf src/${ORG_TEMPLATES_DIR}
	rm -rf src/${STYLE_DIR}
	rm -rf ${LITERATE_DIR}
	rm -rf src/sitemap.org


clean:	clean-literate
	rm -rf ${BUILD_DIR}
