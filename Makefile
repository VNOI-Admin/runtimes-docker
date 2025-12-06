TAG ?= latest

.PHONY: all image-tiericpc image-tier1 image-tier2 image-tier3 test-tiericpc test-tier1 test-tier2 test-tier3

all: image-tiericpc image-tier1 image-tier2 image-tier3

image-tiericpc:
	cd tiericpc && docker build -t vnoj/runtimes-tiericpc -t vnoj/runtimes-tiericpc:$(TAG) -t ghcr.io/vnoj/runtimes-tiericpc:$(TAG) .

image-tier1:
	cd tier1 && docker build -t vnoj/runtimes-tier1 -t vnoj/runtimes-tier1:$(TAG) -t ghcr.io/vnoj/runtimes-tier1:$(TAG) .

image-tier2: image-tier1
	cd tier2 && docker build -t vnoj/runtimes-tier2 -t vnoj/runtimes-tier2:$(TAG) -t ghcr.io/vnoj/runtimes-tier2:$(TAG) .

image-tier3: image-tier2
	cd tier3 && docker build -t vnoj/runtimes-tier3 -t vnoj/runtimes-tier3:$(TAG) -t ghcr.io/vnoj/runtimes-tier3:$(TAG) .

test: test-tiericpc test-tier1 test-tier2 test-tier3

test-tiericpc:
	docker run --rm -v "`pwd`/test":/code --cap-add=SYS_PTRACE vnoj/runtimes-tiericpc

test-tier1:
	docker run --rm -v "`pwd`/test":/code --cap-add=SYS_PTRACE vnoj/runtimes-tier1

test-tier2:
	docker run --rm -v "`pwd`/test":/code --cap-add=SYS_PTRACE vnoj/runtimes-tier2

test-tier3:
	docker run --rm -v "`pwd`/test-tier3":/code --cap-add=SYS_PTRACE vnoj/runtimes-tier3
