.PHONY: help
.SILENT:

SUDO=sudo
SHELL=/bin/bash
RIOTKIT_UTILS_VER=v2.0.0
PUSH=true

help:
	@grep -E '^[a-zA-Z\-\_0-9\.@]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build_recent: _download_tools ## Build recent version
	BUILD_PARAMS="--dont-rebuild "; \
	if [[ "$$TRAVIS_COMMIT_MESSAGE" == *"@force-rebuild"* ]]; then \
		BUILD_PARAMS=" "; \
	fi; \
	./.helpers/current/for-each-github-release --exec "make build PUSH=${PUSH} VERSION=RELEASE%MATCH_0% ARCH=${ARCH}" --repo-name minio/minio --dest-docker-repo quay.io/riotkit/minio $${BUILD_PARAMS}--allowed-tags-regexp="RELEASE(.*)$$" --release-tag-template="RELEASE%MATCH_0%-${ARCH}" --max-versions=1 --verbose; \


build: ## Build (args: VERSION, ARCH)
	${SUDO} docker build . -f ./${ARCH}.Dockerfile -t quay.io/riotkit/minio:${VERSION}-${ARCH} --build-arg MINIO_VERSION=${VERSION}
	${SUDO} docker tag quay.io/riotkit/minio:${VERSION}-${ARCH} quay.io/riotkit/minio:${VERSION}-${ARCH}-$$(date '+%Y-%m-%d')

	if [[ "${PUSH}" == "true" ]]; then \
		${SUDO} docker push quay.io/riotkit/minio:${VERSION}-${ARCH}-$$(date '+%Y-%m-%d'); \
		${SUDO} docker push quay.io/riotkit/minio:${VERSION}-${ARCH}; \
	fi

_download_tools:
	if [[ ! -d ".helpers/${RIOTKIT_UTILS_VER}" ]]; then \
		mkdir -p .helpers/${RIOTKIT_UTILS_VER}; \
		curl -s https://raw.githubusercontent.com/riotkit-org/ci-utils/${RIOTKIT_UTILS_VER}/bin/for-each-github-release      > .helpers/${RIOTKIT_UTILS_VER}/for-each-github-release; \
		curl -s https://raw.githubusercontent.com/riotkit-org/ci-utils/${RIOTKIT_UTILS_VER}/bin/inject-qemu-bin-into-container > .helpers/${RIOTKIT_UTILS_VER}/inject-qemu-bin-into-container; \
	fi

	rm -f .helpers/current
	ln -s $$(pwd)/.helpers/${RIOTKIT_UTILS_VER} $$(pwd)/.helpers/current
	chmod +x .helpers/*/*

_inject_qemu:
	${SUDO} ./.helpers/inject-qemu-bin-into-container ${IMAGE}
