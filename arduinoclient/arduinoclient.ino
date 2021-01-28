#include <lwm2m_wakaama.h>
#include "arduino_secrets.h"
#include <WiFiNINA.h>
#include <WiFiUdp.h>


// Settings. ---------------------------------------------------------------------

IPAddress address(192, 168, 0, 23);     // !!! Must be updated to server IP !!!
const unsigned int remote_port = 5683;
const unsigned int local_port = 56830;
const unsigned int timeout_ms = 10000;

//should be included in "arduino_secrets.h"
//char ssid[] = "";   // your network SSID (name)
//char pass[] = "";   // your network password (use for WPA, or use as key for WEP)

// -------------------------------------------------------------------------------

WiFiUDP Udp;
int status = WL_IDLE_STATUS;


void send_packet_callback(uint8_t * buffer, size_t length) 
{
    Serial.print("Send packet using WiFiNINA, length = ");
    Serial.println(length);
    Udp.beginPacket(address, remote_port);
    Udp.write(buffer, length);
    Udp.endPacket();
}


void setup() {
    pinMode(LED_BUILTIN, OUTPUT);
}


void loop() {
    Serial.print("Boot delay...");
    delay(3000);
    Serial.print("Arduino lwm2m wakaama client initializing\r\n");

    WakaamaClient client(&send_packet_callback); //problem if outside loop()

    // check for the WiFi module:
    if (WiFi.status() == WL_NO_MODULE) {
        Serial.println("Communication with WiFi module failed!");
        // don't continue
        while (true);
    }

    // attempt to connect to Wifi network:
    while (status != WL_CONNECTED) {
        Serial.print("Attempting to connect to SSID: ");
        Serial.println(ssid);
        // Connect to WPA/WPA2 network. Change this line if using open or WEP network:
        status = WiFi.begin(ssid, pass);

        // wait 10 seconds for connection:
        delay(10000);
    }
    Serial.println("Connected to wifi");

    Udp.begin(local_port);  
    for(;;) {
        unsigned long starttime;
        int size = 0;
        uint8_t buffer[MAX_PACKET_SIZE];
        int numBytes;    

        client.step();
        
        // simulate a blocking wait for packet with timeout
        starttime = millis();
        while ((millis() - starttime) < timeout_ms && size == 0)
        {
            size = Udp.parsePacket();
            // blink LED, introduces processing latency (improve this)
            digitalWrite(LED_BUILTIN, HIGH); delay(500);
            digitalWrite(LED_BUILTIN, LOW);  delay(500);
        }

        if (size > 0) {
            size = 0;
            numBytes = Udp.read(buffer, MAX_PACKET_SIZE);
            Serial.print("packet received, numbytes = ");
            Serial.println(numBytes);
            client.handle_packet(numBytes, buffer);
        }
    }
}
