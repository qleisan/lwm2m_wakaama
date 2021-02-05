my_arm-none-eabi-g++ = /home/pi/.arduino15/packages/arduino/tools/arm-none-eabi-gcc/7-2017q4/bin/arm-none-eabi-g++
my_arm-none-eabi-objcopy = /home/pi/.arduino15/packages/arduino/tools/arm-none-eabi-gcc/7-2017q4/bin/arm-none-eabi-objcopy
my_arm-none-eabi-size = /home/pi/.arduino15/packages/arduino/tools/arm-none-eabi-gcc/7-2017q4/bin/arm-none-eabi-size

my_flags = -mcpu=cortex-m0plus -mthumb -c -g -Os -w -std=gnu++11 -ffunction-sections -fdata-sections -fno-threadsafe-statics \
-nostdlib --param max-inline-insns-single=500 -fno-rtti -fno-exceptions -MMD -DF_CPU=48000000L -DARDUINO=10607 -DARDUINO_SAMD_MKRWIFI1010 -DARDUINO_ARCH_SAMD \
-DUSE_ARDUINO_MKR_PIN_LAYOUT -D__SAMD21G18A__ -DUSB_VID=0x2341 -DUSB_PID=0x8054 -DUSBCON "-DUSB_MANUFACTURER=\"Arduino LLC\"" "-DUSB_PRODUCT=\"Arduino MKR WiFi 1010\"" \
-DUSE_BQ24195L_PMIC \
-DLWM2M_CLIENT_MODE \
-DLWM2M_SUPPORT_SENML_JSON \
-I/home/pi/.arduino15/packages/arduino/tools/CMSIS/4.5.0/CMSIS/Include/ \
-I/home/pi/.arduino15/packages/arduino/tools/CMSIS-Atmel/1.2.0/CMSIS/Device/ATMEL/ \
-I/home/pi/.arduino15/packages/arduino/hardware/samd/1.8.11/cores/arduino/api/deprecated \
-I/home/pi/.arduino15/packages/arduino/hardware/samd/1.8.11/cores/arduino/api/deprecated-avr-comp \
-I/home/pi/.arduino15/packages/arduino/hardware/samd/1.8.11/cores/arduino \
-I/home/pi/.arduino15/packages/arduino/hardware/samd/1.8.11/variants/mkrwifi1010 \
-I/home/pi/qleisan_wakaama/core \
-I/home/pi/qleisan_wakaama/examples/shared \
-I/home/pi/Arduino/libraries/WiFiNINA/src

my_objs = $(bdir)/arduino_main.o $(bdir)/lightclient.o $(bdir)/object_security.o $(bdir)/data.o $(bdir)/list.o $(bdir)/platform.o $(bdir)/liblwm2m.o $(bdir)/utils.o \
		  $(bdir)/object_server.o $(bdir)/object_device.o $(bdir)/test_object.o $(bdir)/block1.o $(bdir)/objects.o $(bdir)/registration.o $(bdir)/transaction.o \
		  $(bdir)/er-coap-13.o $(bdir)/observe.o $(bdir)/connection.o $(bdir)/discover.o $(bdir)/packet.o $(bdir)/uri.o $(bdir)/senml_json.o $(bdir)/json_common.o
bdir = build-arduino

.PHONY: build builddir

build: builddir $(my_objs)
	$(my_arm-none-eabi-g++) -Os -Wl,--gc-sections -save-temps \
	-T/home/pi/.arduino15/packages/arduino/hardware/samd/1.8.11/variants/mkrwifi1010/linker_scripts/gcc/flash_with_bootloader.ld \
	-Wl,-Map,$(bdir)/arduino.ino.map --specs=nano.specs --specs=nosys.specs -mcpu=cortex-m0plus -mthumb -Wl,--cref -Wl,--check-sections -Wl,--gc-sections -Wl,--unresolved-symbols=report-all \
	-Wl,--warn-common -Wl,--warn-section-align \
	-o $(bdir)/arduino.ino.elf \
	$(my_objs) \
	/tmp/arduino-sketch-D9925E377E8AE82872000ED11A1E68B4/libraries/SPI/SPI.cpp.o \
	/tmp/arduino-sketch-D9925E377E8AE82872000ED11A1E68B4/libraries/WiFiNINA/WiFi.cpp.o \
	/tmp/arduino-sketch-D9925E377E8AE82872000ED11A1E68B4/libraries/WiFiNINA/WiFiClient.cpp.o \
	/tmp/arduino-sketch-D9925E377E8AE82872000ED11A1E68B4/libraries/WiFiNINA/WiFiSSLClient.cpp.o \
	/tmp/arduino-sketch-D9925E377E8AE82872000ED11A1E68B4/libraries/WiFiNINA/WiFiServer.cpp.o \
	/tmp/arduino-sketch-D9925E377E8AE82872000ED11A1E68B4/libraries/WiFiNINA/WiFiStorage.cpp.o \
	/tmp/arduino-sketch-D9925E377E8AE82872000ED11A1E68B4/libraries/WiFiNINA/WiFiUdp.cpp.o \
	/tmp/arduino-sketch-D9925E377E8AE82872000ED11A1E68B4/libraries/WiFiNINA/utility/WiFiSocketBuffer.cpp.o \
	/tmp/arduino-sketch-D9925E377E8AE82872000ED11A1E68B4/libraries/WiFiNINA/utility/server_drv.cpp.o \
	/tmp/arduino-sketch-D9925E377E8AE82872000ED11A1E68B4/libraries/WiFiNINA/utility/spi_drv.cpp.o \
	/tmp/arduino-sketch-D9925E377E8AE82872000ED11A1E68B4/libraries/WiFiNINA/utility/wifi_drv.cpp.o \
	/tmp/arduino-sketch-75CE618D00BEB233D33D292BF7CC43A3/core/variant.cpp.o -Wl,--start-group \
	-L/home/pi/.arduino15/packages/arduino/tools/CMSIS/4.5.0/CMSIS/Lib/GCC/ \
	-larm_cortexM0l_math \
	-lm /tmp/arduino-sketch-75CE618D00BEB233D33D292BF7CC43A3/../arduino-core-cache/core_arduino_samd_mkrwifi1010_8fba5eabeb8d6dde8dc4179818d7f308.a \
	-Wl,--end-group
	$(my_arm-none-eabi-objcopy) -O binary $(bdir)/arduino.ino.elf $(bdir)/arduino.ino.bin
	$(my_arm-none-eabi-objcopy) -O ihex -R .eeprom $(bdir)/arduino.ino.elf $(bdir)/arduino.ino.hex
	$(my_arm-none-eabi-size) -A $(bdir)/arduino.ino.elf

builddir:
	# use $(bdir)
	mkdir -p build-arduino	
$(bdir)/arduino_main.o:	arduino_main.cpp
	$(my_arm-none-eabi-g++) $(my_flags) arduino_main.cpp -o $(bdir)/arduino_main.o
$(bdir)/lightclient.o: examples/lightclient/lightclient.c
	$(my_arm-none-eabi-g++) $(my_flags) examples/lightclient/lightclient.c -o $(bdir)/lightclient.o
$(bdir)/object_security.o: examples/lightclient/object_security.c
	$(my_arm-none-eabi-g++) $(my_flags) examples/lightclient/object_security.c -o $(bdir)/object_security.o
$(bdir)/data.o: core/data.c
	$(my_arm-none-eabi-g++) $(my_flags) core/data.c -o $(bdir)/data.o
$(bdir)/list.o: core/list.c
	$(my_arm-none-eabi-g++) $(my_flags) core/list.c -o $(bdir)/list.o
$(bdir)/platform.o: examples/shared/platform.c
	$(my_arm-none-eabi-g++) $(my_flags) examples/shared/platform.c -o $(bdir)/platform.o
$(bdir)/liblwm2m.o: core/liblwm2m.c
	$(my_arm-none-eabi-g++) $(my_flags) core/liblwm2m.c -o $(bdir)/liblwm2m.o
$(bdir)/utils.o: core/utils.c
	$(my_arm-none-eabi-g++) $(my_flags) core/utils.c -o $(bdir)/utils.o
$(bdir)/object_server.o: examples/lightclient/object_server.c
	$(my_arm-none-eabi-g++) $(my_flags) examples/lightclient/object_server.c -o $(bdir)/object_server.o
$(bdir)/object_device.o: examples/lightclient/object_device.c
	$(my_arm-none-eabi-g++) $(my_flags) examples/lightclient/object_device.c -o $(bdir)/object_device.o
$(bdir)/test_object.o: examples/lightclient/test_object.c
	$(my_arm-none-eabi-g++) $(my_flags) examples/lightclient/test_object.c -o $(bdir)/test_object.o
$(bdir)/block1.o: core/block1.c
	$(my_arm-none-eabi-g++) $(my_flags) -fpermissive core/block1.c -o $(bdir)/block1.o
$(bdir)/objects.o: core/objects.c
	$(my_arm-none-eabi-g++) $(my_flags) core/objects.c -o $(bdir)/objects.o
$(bdir)/registration.o: core/registration.c
	$(my_arm-none-eabi-g++) $(my_flags) -fpermissive core/registration.c -o $(bdir)/registration.o
$(bdir)/transaction.o: core/transaction.c
	$(my_arm-none-eabi-g++) $(my_flags) -fpermissive core/transaction.c -o $(bdir)/transaction.o
$(bdir)/er-coap-13.o: core/er-coap-13/er-coap-13.c
	$(my_arm-none-eabi-g++) $(my_flags) -fpermissive core/er-coap-13/er-coap-13.c -o $(bdir)/er-coap-13.o
$(bdir)/observe.o: core/observe.c
	$(my_arm-none-eabi-g++) $(my_flags) core/observe.c -o $(bdir)/observe.o
$(bdir)/connection.o: examples/shared/connection.c
	$(my_arm-none-eabi-g++) $(my_flags) examples/shared/connection.c -o $(bdir)/connection.o
$(bdir)/discover.o: core/discover.c
	$(my_arm-none-eabi-g++) $(my_flags) core/discover.c -o $(bdir)/discover.o
$(bdir)/packet.o: core/packet.c
	$(my_arm-none-eabi-g++) $(my_flags) core/packet.c -o $(bdir)/packet.o
$(bdir)/uri.o: core/uri.c
	$(my_arm-none-eabi-g++) $(my_flags) core/uri.c -o $(bdir)/uri.o
$(bdir)/senml_json.o: core/senml_json.c
	$(my_arm-none-eabi-g++) $(my_flags) -fpermissive core/senml_json.c -o $(bdir)/senml_json.o
$(bdir)/json_common.o: core/json_common.c
	$(my_arm-none-eabi-g++) $(my_flags) core/json_common.c -o $(bdir)/json_common.o

upload:
	# some magic involved that require ".ino" in the filename
	@echo "To connect use: sudo minicom -D /dev/ttyACM0\n"
	arduino-cli upload -p /dev/ttyACM0 --fqbn arduino:samd:mkrwifi1010 --input-dir $(bdir) && sleep 2 && sudo minicom -D /dev/ttyACM0
clean:
	# use RM macro or rm -f
	$(RM) *.bin
	$(RM) *.elf
	$(RM) *.d
	$(RM) *.o
	$(RM) *.hex
	$(RM) *.map
	rm -rf build-arduino
	# only removova of directory is needed now since all output is placed there. Use $(bdir) instead of hardcoded path 
