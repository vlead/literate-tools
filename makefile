#SHELL := /bin/bash
BUILD_DIR=build

VER_BRANCH=build-release
VER_FILE=VERSION

ORG_MODE_DIR=~/emacs/lisp
LITERATE_TOOLS="https://github.com/vlead/literate-tools.git"
LITERATE_DIR=literate-tools
ELISP_DIR=elisp
ORG_DIR=org-templates
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
	wget http://orgmode.org/org-9.0.2.tar.gz
	tar zxvf org-9.0.2.tar.gz
	rm -rf org-9.0.2.tar.gz
	mv org-9.0.2 ${ORG_MODE_DIR}
	ln -s ${ORG_MODE_DIR}/org-9.0.2/ ${ORG_MODE_DIR}/org-8.2.10
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
	ln -sf ../${LITERATE_DIR}/${ORG_DIR} ${SRC_DIR}; \
	ln -sf ../${LITERATE_DIR}/${STYLE_DIR} ${SRC_DIR})

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


# get the latest commit hash and its subject line
# and write that to the VERSION file
write-version:
	echo -n "Built from commit: " > ${CODE_DIR}/${VER_FILE}
	echo `git rev-parse HEAD` >> ${CODE_DIR}/${VER_FILE}
	echo `git log --pretty=format:'%s' -n 1` >> ${CODE_DIR}/${VER_FILE}

clean-literate:
	rm -rf ${ELISP_DIR}
	rm -rf src/${ORG_DIR}
	rm -rf src/${STYLE_DIR}
	rm -rf ${LITERATE_DIR}


clean:	clean-literate
	rm -rf ${BUILD_DIR}

