#suffix=c
suffix=cpp

rmlib:
	rm -rf /home/pi/Arduino/libraries/lwm2m_wakaama/src
	rm -rf /tmp/arduino-*
	rm -rf src_deref
createlib:
	# NEED TO FLATTEN DIR STRUCTURE FROM WAKAAMA SINCE ARDUINO DON'T USE THE CMAKE FILES AND WILL NOT FIND INCLUDE FILES OTHERWISE
	# TODO: remove absolute path
	mkdir -p /home/pi/Arduino/libraries/lwm2m_wakaama/src/er-coap-13

	# this is the library "main" file. C++
	 ln -s ../lwm2m_wakaama.cpp src/lwm2m_wakaama.cpp
	 ln -s ../lwm2m_wakaama.h src/lwm2m_wakaama.h

 	#ln -s ../wakaama/examples/lightclient/lightclient.c src/lightclient.$(suffix)
	ln -s ../wakaama/examples/lightclient/object_device.c src/object_device.$(suffix)
	ln -s ../wakaama/examples/lightclient/object_security.c src/object_security.$(suffix)
	ln -s ../wakaama/examples/lightclient/object_server.c src/object_server.$(suffix)
	ln -s ../wakaama/examples/lightclient/object_test.c src/object_test.$(suffix)

	#ln -s ../wakaama/examples/shared/platform.c src/platform.$(suffix)
	@echo "COPY AND MODIFY platform.c"
	cp wakaama/examples/shared/platform.c src/platform.$(suffix)
	sed  -i '1i #include <Arduino.h>' src/platform.$(suffix)
	sed -i 's/return time(NULL);/long int mytime=0;mytime=millis()\/1000;Serial.print("QLEISAN - time: ");Serial.println(mytime);/' src/platform.$(suffix)

	#ln -s ../wakaama/examples/shared/connection.c src/connection.$(suffix)
	#ln -s ../wakaama/examples/shared/connection.h src/connection.h
	ln -s ../wakaama/examples/shared/commandline.h src/commandline.h


	ln -s ../wakaama/data/data.c src/data.$(suffix)
	ln -s ../wakaama/data/json_common.c src/json_common.$(suffix)
	ln -s ../wakaama/data/senml_json.c src/senml_json.$(suffix)

	ln -s ../wakaama/core/liblwm2m.c src/liblwm2m.$(suffix)
	ln -s ../wakaama/core/list.c src/list.$(suffix)
	ln -s ../wakaama/core/objects.c src/objects.$(suffix)
	ln -s ../wakaama/core/observe.c src/observe.$(suffix)
	ln -s ../wakaama/core/discover.c src/discover.$(suffix)
	ln -s ../wakaama/core/packet.c src/packet.$(suffix)
	ln -s ../wakaama/core/registration.c src/registration.$(suffix)
	ln -s ../wakaama/core/uri.c src/uri.$(suffix)
	ln -s ../wakaama/core/utils.c src/utils.$(suffix)
	ln -s ../wakaama/core/management.c src/management.$(suffix)

	ln -s ../wakaama/core/internals.h src/internals.h

	ln -s ../wakaama/coap/block.c src/block.$(suffix)
	ln -s ../wakaama/coap/transaction.c src/transaction.$(suffix)
	
	#ln -s ../wakaama/core/liblwm2m.h src/liblwm2m.h
	@echo "COPY AND MODIFY liblwm2m.h"
	cp wakaama/include/liblwm2m.h src/liblwm2m.h
	sed  -i '1i #define LWM2M_SUPPORT_SENML_JSON' src/liblwm2m.h
	sed  -i '2i #define LWM2M_CLIENT_MODE' src/liblwm2m.h

	ln -s ../../wakaama/coap/er-coap-13/er-coap-13.c src/er-coap-13/er-coap-13.$(suffix)
	ln -s ../../wakaama/coap/er-coap-13/er-coap-13.h src/er-coap-13/er-coap-13.h


buildsketch:
	# arduino-cli compile --fqbn arduino:samd:mkrwifi1010 arduinoclient --verbose
	# arduino-cli compile --build-property build.extra_flags=-DAPABEPA=2 --fqbn arduino:samd:mkrwifi1010 arduinoclient --verbose
	## TODO: need to pass more flags, at least "LWM2M_SUPPORT_SENML_JSON"
	#arduino-cli compile --build-property compiler.cpp.extra_flags=-DLWM2M_CLIENT_MODE
	arduino-cli compile \
	--fqbn arduino:samd:nano_33_iot \
	examples/arduinoclient \
	--verbose
	
uploadsketch:
	# some magic involved that require ".ino" in the filename
	@echo "To connect use: sudo minicom -D /dev/ttyACM0\n"
	#arduino-cli upload -p /dev/ttyACM0 --fqbn arduino:samd:mkrwifi1010 examples/arduinoclient && sleep 2 && sudo minicom -D /dev/ttyACM0
	arduino-cli upload -p /dev/ttyACM0 --fqbn arduino:samd:nano_33_iot examples/arduinoclient && sleep 2 && sudo minicom -D /dev/ttyACM0

release:
	git stash
	git checkout master
	rm -rf src
	mv src_deref src
	git checkout dev -- Readme.txt library.properties
	git add Readme.txt library.properties
	git add -A src
	git add examples/arduinoclient/arduinoclient.ino
	git commit -m "Automated commit"
	git checkout dev
	git stash pop

dereference:
	rm -rf src_deref
	cp -r -L src src_deref
	rm -rf src

### BUILD & RUN
# make rmlib createlib
# make buildsketch
# make uploadsketch

### COMMIT TO MASTER
# make rmlib createlib
# make dereference
# make release