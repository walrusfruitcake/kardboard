boardinfo := $(shell arduino-cli --format json board list)
boardcount = $(shell echo '$(boardinfo)' | jq '.|length')
boardname = $(shell echo '$(boardinfo)' | jq '.[0].boards[0].FQBN')
boardport = $(shell echo '$(boardinfo)' | jq '.[0].address')
dfuhex := ArduinoCore-avr/firmwares/atmegaxxu2/arduino-usbserial/Arduino-usbserial-atmega16u2-Uno-Rev3.hex
kbdhex := vendor/Arduino-keyboard-0.3.hex

clean:
	git clean -fx

ensure-environment:
	echo "make sure '$$sketch' is set"
	[ ! -z $(sketch) ]

board-info:
	arduino-cli board list

board-attached:
	if [ $(boardcount) -le 0 ]; then echo "\nNo board connected.\ntry: make board info\nor:  make build-uno\n"; false; fi

build-uno: ensure-environment
	arduino-cli compile --fqbn arduino:avr:uno $(sketch)

build: board-attached
	arduino-cli compile --fqbn $(boardname) blink-sketch

upload: clean build board-attached
	arduino-cli upload --fqbn $(boardname) --port $(boardport) blink-sketch

flash-16u2:
	sudo dfu-programmer atmega16u2 erase
	sudo dfu-programmer atmega16u2 flash --debug 1 $(dfuhex)
	sudo dfu-programmer atmega16u2 reset

flash-kbd:
	sudo dfu-programmer atmega16u2 erase
	sudo dfu-programmer atmega16u2 flash --debug 1 $(kbdhex)
	sudo dfu-programmer atmega16u2 reset

.PHONY: clean build-uno upload-uno board-attached board-info

