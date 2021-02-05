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
	mkdir -p /home/pi/Arduino/libraries/lwm2m_wakaama/src

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

	#ln -s $(tdir)/core/block.c $(sdir)/block.$(suffix)
	@echo "COPY AND MODIFY block.c"
	cp wakaama/core/block.c $(sdir)/block.$(suffix)
	sed -i 's/lwm2m_block_data_t \* blockData = lwm2m_malloc(sizeof(lwm2m_block_data_t));/lwm2m_block_data_t * blockData = (lwm2m_block_data_t *) lwm2m_malloc(sizeof(lwm2m_block_data_t));/' $(sdir)/block.$(suffix)
	sed -i 's/uint8_t \* buf = lwm2m_malloc(length);/uint8_t * buf = (uint8_t *) lwm2m_malloc(length);/' $(sdir)/block.$(suffix)
	sed -i 's/blockData->blockBuffer = lwm2m_malloc(blockData->blockBufferSize);/blockData->blockBuffer = (uint8_t *) lwm2m_malloc(blockData->blockBufferSize);/' $(sdir)/block.$(suffix)

	ln -s $(tdir)/core/data.c $(sdir)/data.$(suffix)
	ln -s $(tdir)/core/discover.c $(sdir)/discover.$(suffix)
	ln -s $(tdir)/core/json_common.c $(sdir)/json_common.$(suffix)
	ln -s $(tdir)/core/liblwm2m.c $(sdir)/liblwm2m.$(suffix)
	ln -s $(tdir)/core/list.c $(sdir)/list.$(suffix)
	ln -s $(tdir)/core/objects.c $(sdir)/objects.$(suffix)
	ln -s $(tdir)/core/observe.c $(sdir)/observe.$(suffix)

	#ln -s $(tdir)/core/packet.c $(sdir)/packet.$(suffix)
	@echo "COPY AND MODIFY packet.c"
	cp wakaama/core/packet.c $(sdir)/packet.$(suffix)
	sed -i 's/lwm2m_transaction_t \* clone = transaction_new(transaction->peerH, message->code, NULL, NULL, nextMID, message->token_len, message->token);/lwm2m_transaction_t * clone = transaction_new(transaction->peerH, (coap_method_t) message->code, NULL, NULL, nextMID, message->token_len, message->token);/' $(sdir)/packet.$(suffix)
	sed -i 's/message = transaction->message;/message = (coap_packet_t *) transaction->message;/g' $(sdir)/packet.$(suffix)

	#ln -s $(tdir)/core/registration.c $(sdir)/registration.$(suffix)
	@echo "COPY AND MODIFY registration.c"
	cp wakaama/core/registration.c $(sdir)/registration.$(suffix)
	sed -i 's/registration_data_t \* dataP = lwm2m_malloc(sizeof(registration_data_t));/registration_data_t * dataP = (registration_data_t *) lwm2m_malloc(sizeof(registration_data_t));/g' $(sdir)/registration.$(suffix)
	#sed -i 's///' $(sdir)/packet.$(suffix)

	ln -s $(tdir)/core/senml_json.c $(sdir)/senml_json.$(suffix)
	ln -s $(tdir)/core/transaction.c $(sdir)/transaction.$(suffix)
	ln -s $(tdir)/core/uri.c $(sdir)/uri.$(suffix)
	ln -s $(tdir)/core/utils.c $(sdir)/utils.$(suffix)
	ln -s $(tdir)/core/management.c $(sdir)/management.$(suffix)

	ln -s $(tdir)/core/internals.h $(sdir)/internals.h
	
	#ln -s $(tdir)/core/liblwm2m.h $(sdir)/liblwm2m.h
	@echo "COPY AND MODIFY liblwm2m.h"
	cp wakaama/core/liblwm2m.h $(sdir)/liblwm2m.h
	sed  -i '1i #define LWM2M_SUPPORT_SENML_JSON' $(sdir)/liblwm2m.h
	sed  -i '2i #define LWM2M_CLIENT_MODE' $(sdir)/liblwm2m.h

	mkdir $(sdir)/er-coap-13
	#ln -s ../$(tdir)/core/er-coap-13/er-coap-13.c $(sdir)/er-coap-13/er-coap-13.$(suffix)
	@echo "COPY AND MODIFY er-coap-13.c"
	cp wakaama/core/er-coap-13/er-coap-13.c $(sdir)/er-coap-13/er-coap-13.$(suffix)
	sed -i 's/output = lwm2m_malloc(len + 1);/output = (char *) lwm2m_malloc(len + 1);/' $(sdir)/er-coap-13/er-coap-13.$(suffix)

	ln -s ../$(tdir)/core/er-coap-13/er-coap-13.h $(sdir)/er-coap-13/er-coap-13.h
#	ln -s $(tdir)/core/er-coap-13/er-coap-13.c $(sdir)/er-coap-13.$(suffix)
#	ln -s $(tdir)/core/er-coap-13/er-coap-13.h $(sdir)/er-coap-13.h

# 	ln -s $(tdir)/library.properties $(sdir)/../library.properties

buildsketch:
	# arduino-cli compile --fqbn arduino:samd:mkrwifi1010 arduinoclient --verbose
	# arduino-cli compile --build-property build.extra_flags=-DAPABEPA=2 --fqbn arduino:samd:mkrwifi1010 arduinoclient --verbose
	## TODO: need to pass more flags, at least "LWM2M_SUPPORT_SENML_JSON"
	#arduino-cli compile --build-property compiler.cpp.extra_flags=-DLWM2M_CLIENT_MODE
	arduino-cli compile \
	--fqbn arduino:samd:mkrwifi1010 \
	examples/arduinoclient \
	--verbose
	
uploadsketch:
	# some magic involved that require ".ino" in the filename
	@echo "To connect use: sudo minicom -D /dev/ttyACM0\n"
	arduino-cli upload -p /dev/ttyACM0 --fqbn arduino:samd:mkrwifi1010 examples/arduinoclient && sleep 2 && sudo minicom -D /dev/ttyACM0



release:
	git stash
	git checkout master
	git status -s
	mv src_deref src
	git checkout dev -- Readme.txt library.properties
	git add Readme.txt library.properties
	git add -A src examples
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