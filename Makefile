all: build

build:
	sudo docker build . -t wolnosciowiec/arm-minio

