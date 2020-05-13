
#boards := $(shell arduino-cli board list)
boardcount := $(shell arduino-cli --format json board list | jq ".|length")
boardname := $(shell arduino-cli --format json board list | jq ".[0].boards[0].FQBN")
boardport := $(shell arduino-cli --format json board list | jq ".[0].address")
#boardcount = $(shell arduino-cli --format json)

clean:
	git clean -Xf -e '**/*.hex' -e '**/*.elf'

build-uno:
	arduino-cli compile --fqbn arduino:avr:uno blink-sketch

build:
	arduino-cli compile --fqbn $(boardname) blink-sketch

upload: build board-attached
	arduino-cli upload --fqbn $(boardport) --port $(boardport) blink-sketch

board-attached:
	if [ $(boardcount) -le 0 ]; then echo "board count: $(boardcount)"; false; fi

board-info:
	arduino-cli board list

.PHONY: clean build-uno upload-uno board-attached board-info

