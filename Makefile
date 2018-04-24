# Binary name
BINARY=eve
GOBUILD=go build -ldflags "-s -w -X main.Version=${VERSION}" -o ${BINARY} && upx ./${BINARY}
GOCLEAN=go clean
RMTARGZ=rm -rf *.gz

# Builds the project
build:
	$(GOBUILD)
	go test -v
# Installs our project: copies binaries
install:
	go install
release:
	# Clean
	$(GOCLEAN)
	$(RMTARGZ)
	# Build for mac
	CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 $(GOBUILD)
	tar czvf ${BINARY}-mac64-${VERSION}.tar.gz ./${BINARY}
	# Build for arm
	$(GOCLEAN)
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 $(GOBUILD)
	tar czvf ${BINARY}-arm64-${VERSION}.tar.gz ./${BINARY}
	# Build for linux
	$(GOCLEAN)
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 $(GOBUILD)
	tar czvf ${BINARY}-linux64-${VERSION}.tar.gz ./${BINARY}
	# Build for win
	$(GOCLEAN)
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 $(GOBUILD)
	tar czvf ${BINARY}-win64-${VERSION}.tar.gz ./${BINARY}.exe
	$(GOCLEAN)
	$(GOBUILD)
# Cleans our projects: deletes binaries
clean:
	$(GOCLEAN)
	$(RMTARGZ)
test:
	go test -v
.PHONY: clean build