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
	arduino-cli compile --fqbn $(boardname) $(sketch)

upload: clean build firmware-state/16u2 board-attached
	arduino-cli upload --fqbn $(boardname) --port $(boardport) $(sketch)

firmware-state/16u2:
	echo "please hard-reset the 16u2 chip"
	read wait
	rm -f firmware-state/*
	sudo dfu-programmer atmega16u2 erase
	sudo dfu-programmer atmega16u2 flash --debug 1 $(dfuhex)
	sudo dfu-programmer atmega16u2 reset
	touch firmware-state/16u2
	echo "please unplug and re-plug the board"
	read wait

firmware-state/kbd:
	echo "please hard-reset the 16u2 chip"
	read wait
	rm -f firmware-state/*
	sudo dfu-programmer atmega16u2 erase
	sudo dfu-programmer atmega16u2 flash --debug 1 $(kbdhex)
	sudo dfu-programmer atmega16u2 reset
	touch firmware-state/kbd
	echo "please unplug and re-plug the board"
	read wait

program-keyboard: firmware-state/16u2
	sketch=hello-keyboard make upload
	make firmware-state/kbd

.PHONY: clean build-uno upload upload-uno board-attached board-info

