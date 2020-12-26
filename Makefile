build:
	docker build . -t adrianhesketh/home

run:
	docker run --rm -it adrianhesketh/home sh
