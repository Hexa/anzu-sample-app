.PHONY: all clean

FLAGS = --link-flags '-L/usr/local/lib'

all:
	shards install
	mkdir -p public/js
	git clone https://github.com/shiguredo/anzu-js-sdk.git anzu-js-sdk
	ln -s ../../anzu-js-sdk/dist/anzu.js public/js/anzu.js
	crystal build --release $(FLAGS) src/anzu-sample-app.cr

clean:
	rm -rf public/js
	rm -rf anzu-js-sdk
