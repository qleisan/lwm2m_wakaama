#TODO fix issues (see below)
sdir=./src
tdir=../wakaama

#suffix=c
suffix=cpp

rmlib:
	rm -rf /home/pi/Arduino/libraries/lwm2m_wakaama/src
	rm -rf /tmp/arduino-*
	rm -rf src_deref
createlib:
	# mkdir -p /home/pi/Arduino/libraries/lwm2m_wakaama/src/examples/lightclient
	# ln -s ../wakaama/core src/core
	# ln -s ../wakaama/coap src/coap
	# ln -s ../wakaama/data src/data
	# ln -s ../../../wakaama/examples/lightclient/object_device.c src/examples/lightclient/object_device.c
	# ln -s ../../../wakaama/examples/lightclient/object_security.c src/examples/lightclient/object_security.c
	# ln -s ../../../wakaama/examples/lightclient/object_server.c src/examples/lightclient/object_server.c
	# ln -s ../../../wakaama/examples/lightclient/object_test.c src/examples/lightclient/object_test.c
	# ln -s ../wakaama/include src/include

	# NEED TO FLATTEN DIR STRUCTURE FROM WAKAAMA SINCE ARDUINO DON'T USE THE CMAKE FILES AND WILL NOT FIND INCLUDE FILES OTHERWISE
	# TODO: remove absolute path
	mkdir -p /home/pi/Arduino/libraries/lwm2m_wakaama/src/er-coap-13



	# TODO: copy files that need to be modified and modify them using SED ?

	# this is the library "main" file. C++
	 ln -s ../lwm2m_wakaama.cpp $(sdir)/lwm2m_wakaama.cpp
	 ln -s ../lwm2m_wakaama.h $(sdir)/lwm2m_wakaama.h

 	#ln -s $(tdir)/examples/lightclient/lightclient.c $(sdir)/lightclient.$(suffix)
	ln -s $(tdir)/examples/lightclient/object_device.c $(sdir)/object_device.$(suffix)
	ln -s $(tdir)/examples/lightclient/object_security.c $(sdir)/object_security.$(suffix)
	ln -s $(tdir)/examples/lightclient/object_server.c $(sdir)/object_server.$(suffix)
	ln -s $(tdir)/examples/lightclient/object_test.c $(sdir)/object_test.$(suffix)

	#ln -s $(tdir)/examples/shared/connection.c $(sdir)/connection.$(suffix)

	#ln -s $(tdir)/examples/shared/platform.c $(sdir)/platform.$(suffix)
	@echo "COPY AND MODIFY platform.c"
	cp wakaama/examples/shared/platform.c $(sdir)/platform.$(suffix)
	sed  -i '1i #include <Arduino.h>' $(sdir)/platform.$(suffix)
	sed -i 's/return time(NULL);/long int mytime=0;mytime=millis()\/1000;Serial.print("QLEISAN - time: ");Serial.println(mytime);/' $(sdir)/platform.$(suffix)

	#ln -s $(tdir)/examples/shared/connection.h $(sdir)/connection.h
	ln -s $(tdir)/examples/shared/commandline.h $(sdir)/commandline.h

	ln -s $(tdir)/coap/block.c $(sdir)/block.$(suffix)

	ln -s $(tdir)/data/data.c $(sdir)/data.$(suffix)
	ln -s $(tdir)/data/json_common.c $(sdir)/json_common.$(suffix)

	ln -s $(tdir)/core/liblwm2m.c $(sdir)/liblwm2m.$(suffix)
	ln -s $(tdir)/core/list.c $(sdir)/list.$(suffix)
	ln -s $(tdir)/core/objects.c $(sdir)/objects.$(suffix)
	ln -s $(tdir)/core/observe.c $(sdir)/observe.$(suffix)
	ln -s $(tdir)/core/discover.c $(sdir)/discover.$(suffix)


	ln -s $(tdir)/core/packet.c $(sdir)/packet.$(suffix)

	ln -s $(tdir)/core/registration.c $(sdir)/registration.$(suffix)

	ln -s $(tdir)/data/senml_json.c $(sdir)/senml_json.$(suffix)
	ln -s $(tdir)/coap/transaction.c $(sdir)/transaction.$(suffix)

	ln -s $(tdir)/core/uri.c $(sdir)/uri.$(suffix)
	ln -s $(tdir)/core/utils.c $(sdir)/utils.$(suffix)
	ln -s $(tdir)/core/management.c $(sdir)/management.$(suffix)

	ln -s $(tdir)/core/internals.h $(sdir)/internals.h
	
	#ln -s $(tdir)/core/liblwm2m.h $(sdir)/liblwm2m.h
	@echo "COPY AND MODIFY liblwm2m.h"
	cp wakaama/include/liblwm2m.h $(sdir)/liblwm2m.h
	sed  -i '1i #define LWM2M_SUPPORT_SENML_JSON' $(sdir)/liblwm2m.h
	sed  -i '2i #define LWM2M_CLIENT_MODE' $(sdir)/liblwm2m.h

	ln -s ../$(tdir)/coap/er-coap-13/er-coap-13.c $(sdir)/er-coap-13/er-coap-13.$(suffix)

	ln -s ../$(tdir)/coap/er-coap-13/er-coap-13.h $(sdir)/er-coap-13/er-coap-13.h
#	ln -s $(tdir)/core/er-coap-13/er-coap-13.c $(sdir)/er-coap-13.$(suffix)
#	ln -s $(tdir)/core/er-coap-13/er-coap-13.h $(sdir)/er-coap-13.h
#	ln -s library.properties ../library.properties


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