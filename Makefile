TAG ?= latest

.PHONY: all image-tiericpc image-tier1 image-tier2 image-tier3 clean test-tiericpc test-tier1 test-tier2 test-tier3

all: image-tiericpc image-tier1 image-tier2 image-tier3

image-tiericpc:
	cd tiericpc && docker build -t vnoj/runtimes-tiericpc -t vnoj/runtimes-tiericpc:$(TAG) -t ghcr.io/vnoj/runtimes-tiericpc:$(TAG) .

image-tier1:
	cd tier1 && docker build -t vnoj/runtimes-tier1 -t vnoj/runtimes-tier1:$(TAG) -t ghcr.io/vnoj/runtimes-tier1:$(TAG) .

image-tier2: image-tier1
	cd tier2 && docker build -t vnoj/runtimes-tier2 -t vnoj/runtimes-tier2:$(TAG) -t ghcr.io/vnoj/runtimes-tier2:$(TAG) \
			--build-arg SCALA_ZIP_URL="$(shell ./github-curl https://api.github.com/repos/scala/scala3/releases | jq -r "[.[] | select(.prerelease | not) | .assets | flatten | .[] | select((.name | startswith(\"scala3-\")) and (.name | endswith(\"$(shell arch)-pc-linux.tar.gz\"))) | .browser_download_url][0]")" \
			.

image-tier3: image-tier2
	cd tier3 && docker build -t vnoj/runtimes-tier3 -t vnoj/runtimes-tier3:$(TAG) -t ghcr.io/vnoj/runtimes-tier3:$(TAG) \
			--build-arg KOTLIN_ZIP_URL="$(shell ./github-curl https://api.github.com/repos/JetBrains/kotlin/releases | jq -r '[.[] | select(.prerelease | not) | .assets | flatten | .[] | select((.name | startswith("kotlin-compiler")) and (.name | endswith(".zip"))) | .browser_download_url][0]')" \
			--build-arg LEAN4_ZIP_URL="$(shell ./github-curl https://api.github.com/repos/leanprover/lean4/releases | jq -r '[.[] | select(.prerelease | not) | .assets | flatten | .[] | select((.name | startswith("lean-")) and (.name | endswith("-linux.zip"))) | .browser_download_url][0]')" \
			.

clean:
	-docker rmi vnoj/runtimes-tier3 vnoj/runtimes-tier3:$(TAG) ghcr.io/vnoj/runtimes-tier3:$(TAG)
	-docker rmi vnoj/runtimes-tier2 vnoj/runtimes-tier2:$(TAG) ghcr.io/vnoj/runtimes-tier2:$(TAG)
	-docker rmi vnoj/runtimes-tier1 vnoj/runtimes-tier1:$(TAG) ghcr.io/vnoj/runtimes-tier1:$(TAG)
	docker builder prune -a -f

test: test-tiericpc test-tier1 test-tier2 test-tier3

test-tiericpc:
	docker run --rm -v "`pwd`/test":/code --cap-add=SYS_PTRACE vnoj/runtimes-tiericpc

test-tier1:
	docker run --rm -v "`pwd`/test":/code --cap-add=SYS_PTRACE vnoj/runtimes-tier1

test-tier2:
	docker run --rm -v "`pwd`/test":/code --cap-add=SYS_PTRACE vnoj/runtimes-tier2

test-tier3:
	docker run --rm -v "`pwd`/test-tier3":/code --cap-add=SYS_PTRACE vnoj/runtimes-tier3
