base_dir :=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

build-get-quote:
	@docker build \
	--target get-quote \
	-t docker-shrek:get-quote \
	-f Dockerfile \
	app

build-quote-bot:
	@docker build \
	--build-arg quote_bot_ttl=5 \
	--target quote-bot \
	-t docker-shrek:quote-bot \
	-f Dockerfile \
	app

build-quote-webserver:
	@docker build \
	--build-arg quote_bot_ttl=5 \
	--target quote-webserver \
	-t docker-shrek:quote-webserver \
	-f Dockerfile \
	app

get-quote: % : build-%
	@docker run \
	--rm -it \
	docker-shrek:get-quote

quote-bot: % : build-%
	@docker run \
	--rm -it \
	-v $(base_dir):/history	 \
	docker-shrek:quote-bot

quote-webserver: % : build-%
	@docker run \
	--rm -it \
	-p "8000:8000" \
	docker-shrek:quote-webserver
