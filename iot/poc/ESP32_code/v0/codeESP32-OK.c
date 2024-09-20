#include <NimBLEDevice.h>
#include <NimBLEScan.h>
#include <NimBLEAdvertisedDevice.h>
#include <ArduinoJson.h>
#include <PubSubClient.h>
#include "WiFi.h"

const char *ssid = "Binks";
const char *password = "fredalves3";
const char *mqtt_server = "172.20.10.3";
const char ledPin = 2;
const char outgoingTopic[30] = "EN3250/ESP32";
const char incomingTopic[30] = "test_in";
bool sent = LOW;
char msg[1000];
int scanTime = 3; // In seconds

BLEScan *pBLEScan;
WiFiClient espClient;
PubSubClient client(espClient);

// Setup wifi connecttion with the access point
void setup_wifi()
{
    delay(100);
    Serial.println();
    Serial.print("Connecting to ");
    Serial.println(ssid);

    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED)
    {
        delay(500);
        Serial.print(".");
    }
    randomSeed(micros());

    Serial.println();
    Serial.println("WiFi connected - IP address: ");
    Serial.println(WiFi.localIP());
}

// reconnect if connection failure
void reconnectWifi()
{
    while (!client.connected())
    {
        Serial.print("Attempting MQTT connection...");
        String clientId = "ESP32Client-25";
        clientId += String(random(0xffff), HEX);

        if (client.connect(clientId.c_str()))
        {
            Serial.println("Connected");
            // client.publish(outgoingTopic, "Reconnection Succeeded!");
            client.subscribe(incomingTopic);
        }
        else
        {
            Serial.print("failed, rc=");
            Serial.print(client.state());
            Serial.println(" trying again in 5 seconds");
            // Wait 5 seconds before retrying
            delay(5000);
        }
    }
}

// Connection with MQTT server(Messege arriving)
void callback(char *topic, byte *payload, unsigned int length)
{
    Serial.print("Message arrived [");
    Serial.print(topic);
    Serial.print("] ");
    for (int i = 0; i < length; i++)
    {
        Serial.print((char)payload[i]);
    }
    Serial.println();
}

// BLE beacon Scanning function
void scan_ble()
{
    String dump = "{\"id\":11,";
    StaticJsonDocument<1000> jsonBuffer;

    NimBLEScan *pNimBLEScan = NimBLEDevice::getScan();
    pNimBLEScan->setActiveScan(true);
    NimBLEScanResults foundDevices = pNimBLEScan->start(5); // less or equal setInterval value

    int count = foundDevices.getCount();
    Serial.print("Devices found: ");
    Serial.println(count);
    for (int i = 0; i < count; i++)
    {
        NimBLEAdvertisedDevice d = foundDevices.getDevice(i);
        if (i != 0)
        {
            dump += ",";
        }
        dump += "\"";
        dump += d.getAddress().toString().c_str();
        dump += "\"";
        dump += ":";
        dump += d.getRSSI();

        if (i % 10 == 0)
        {
            dump += "}";
            dump.toCharArray(msg, sizeof(msg));
            Serial.print("Attempting to publish: ");
            Serial.println(msg);
            delay(200);

            Serial.print("Message size: ");
            Serial.println(strlen(msg));

            sent = client.publish("test", msg);
            dump = "{" if (sent)
            {
                Serial.println("Published successfully.");
            }
            else
            {
                Serial.println("Publish failed.");
                Serial.print("Message size: ");
                Serial.println(strlen(msg));
                Serial.print("MQTT state: ");
                Serial.println(client.state());
            }
        }
    }
}

void setup()
{
    pinMode(ledPin, OUTPUT);
    digitalWrite(ledPin, HIGH);
    setup_wifi();

    client.setCallback(callback);
    Serial.begin(115200);
    Serial.println("Scanning...");

    NimBLEDevice::init("");
    Serial.println("BLE Initialiser");
    client.setServer(mqtt_server, 1883);
}

void loop()
{
    digitalWrite(ledPin, LOW);
    delay(100);
    digitalWrite(ledPin, HIGH);

    if (!client.connected())
    {
        reconnectWifi();
    }
    client.loop();
    scan_ble();
    delay(5000);
}