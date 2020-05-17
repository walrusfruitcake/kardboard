
port := $(shell arduino-cli board list | awk 'NR>1 {print $$1}')
dfuhex := ArduinoCore-avr/firmwares/atmegaxxu2/arduino-usbserial/Arduino-usbserial-atmega16u2-Uno-Rev3.hex
kbdhex := vendor/Arduino-keyboard-0.3.hex

clean:
	git clean -Xf -e '**/*.hex' -e '**/*.elf'

build-uno: ensure-environment
	arduino-cli compile --fqbn arduino:avr:uno $(sketch)

ensure-environment:
	echo "make sure '$$sketch' is set"
	[ ! -z $(sketch) ]

upload-uno: build-uno
	arduino-cli upload --fqbn arduino:avr:uno --port $(port) $(sketch)

board-info:
	arduino-cli board list

flash-16u2:
	sudo dfu-programmer atmega16u2 erase
	sudo dfu-programmer atmega16u2 flash --debug 1 $(dfuhex)
	sudo dfu-programmer atmega16u2 reset

flash-kbd:
	sudo dfu-programmer atmega16u2 erase
	sudo dfu-programmer atmega16u2 flash --debug 1 $(kbdhex)
	sudo dfu-programmer atmega16u2 reset

.PHONY: clean build-uno upload-uno board-info

