
#boards := $(shell arduino-cli board list)
boardcount := $(shell arduino-cli --format json board list | jq ".|length")
#boardcount = $(shell arduino-cli --format json)
port := $(shell arduino-cli board list | awk 'NR>1 {print $$1}')

clean:
	git clean -Xf -e '**/*.hex' -e '**/*.elf'

build-uno:
	arduino-cli compile --fqbn arduino:avr:uno blink-sketch

upload-uno: build-uno board-attached
	arduino-cli upload --fqbn arduino:avr:uno --port $(port) blink-sketch

board-attached:
	if [ $(boardcount) -le 0 ]; then echo "board count: $(boardcount)"; false; fi

board-info:
	arduino-cli board list

.PHONY: clean build-uno upload-uno board-attached board-info

