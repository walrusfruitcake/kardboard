
boardinfo := $(shell arduino-cli --format json board list)
boardcount = $(shell echo '$(boardinfo)' | jq '.|length')
boardname = $(shell echo '$(boardinfo)' | jq '.[0].boards[0].FQBN')
boardport = $(shell echo '$(boardinfo)' | jq '.[0].address')

clean:
	git clean -fx

build-uno:
	arduino-cli compile --fqbn arduino:avr:uno blink-sketch

build: board-attached
	arduino-cli compile --fqbn $(boardname) blink-sketch

upload: clean build board-attached
	arduino-cli upload --fqbn $(boardname) --port $(boardport) blink-sketch

board-attached:
	if [ $(boardcount) -le 0 ]; then echo "\nNo board connected.\ntry: make board info\nor:  make build-uno\n"; false; fi

board-info:
	arduino-cli board list

.PHONY: clean build-uno upload-uno board-attached board-info

