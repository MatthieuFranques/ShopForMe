# IoT - The POC

This package sets up the various IoT objects to be used within the project.

It must contain scripts for the tags and the anchor that enable localisation from the mobile application.

## Getting Started

### Arduino

To begin with, it is important to download each library used in the various scripts.

To download into the ESP32, choose the Board entitled `ESP32 Dev Module` and select the correct USB port.

> **Note** Be sure to press the _**‘Flash’**_ button throughout the upload when you see ‘Write’ in the logs, along with the percentage. At the end of the upload, briefly press the _**‘Reset’**_ button.

When each tag is active, the anchor must be connected in order to receive the positions. Connected to Arduino, you can open the Serial Monitor to view them.

> **Note** You need to set the baud rate to 115 200.

### Lib required

Use Library Manager: Sketch > Include Library > Manage Libraries...

<Arduino.h>	            Core Arduino functions and macros (Serial, millis(), delay()).
<map>	                C++ Standard Library container to store key-value pairs (address -> distance).
<BLEDevice.h>	        Initializes and manages BLE functions on the ESP32 (device name, scanning).
<BLEServer.h>	        Enables the ESP32 to act as a BLE server that the mobile app can connect to.
<BLEUtils.h>	        BLE utility functions, including UUID handling and internal helpers.
<BLE2902.h>	            Handles BLE descriptors (enabling notification for a characteristic).
<BLECharacteristic.h>	Defines the characteristics (data payloads) used in BLE communication.
<DW1000.h>	            Control the DW1000 UWB chip. Required for antenna delay calibration.
<DW1000Ranging.h>	    Simplifies UWB ranging between the tag and anchors.


### Documentation

To generate the documentation, managed by Doxygen, you first need to install it in order to use it.

- Download and install : [here](https://www.doxygen.nl/download.html)
- Be sure to add the path to the Doxygen bin to the **PATH** environment variables.

Once this is done, open a terminal, move to the folder containing the `Doxyfile` and run : 

```bash
cd app
doxygen Doxyfile
```

A `doc` folder has been created and can now be viewed via the `index.html` file.

To regenerate the doc after few modifications, you can execute this : 

```bash
rm -rf doc
```

and rerun the previous commands.