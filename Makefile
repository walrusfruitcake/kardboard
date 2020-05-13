
port := $(shell arduino-cli board list | awk 'NR>1 {print $$1}')

clean:
	git clean -Xf -e '**/*.hex' -e '**/*.elf'

build-uno:
	arduino-cli compile --fqbn arduino:avr:uno blink-sketch

upload-uno: build-uno
	arduino-cli upload --fqbn arduino:avr:uno --port $(port) blink-sketch

board-info:
	arduino-cli board list

.PHONY: clean build-uno upload-uno board-info

