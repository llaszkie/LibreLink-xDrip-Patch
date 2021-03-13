Basics:
When a FSL-2 sensor is started using Librelink, the app is paired to the sensor and begins to receive continuous data via Bluetooth.
Librelink calculates and displays the current blood sugar value and, if necessary, triggers alarms. 
The data is displayed in Librelink when the FSL-2 sensor is scanned using NFC.
This patch allows Xdrip to collect the values from Librelink and display them continuously. 
Scanning using Librelink via NFC is still possible.
The “Online Functionality” version will transfer data from Librelink to a Libreview account each time the sensor is scanned.
Xdrip is able to upload the FSL-2 data to Nightscout every 5 minutes.
Results displayed in Librelink and Xdrip are very closely correlated.

This patch version is that of smos-gh, which is forked from Tino Kossmann’s build with some German to English translation.
It allows the user to decide whether to maintain the connection to Abbott or not.
For this, the patch.sh script asks which parts of the patch to apply.
IF YOU WANT TO USE THIS, YOU NEED TO ACTIVATE A NEW SENSOR, IT WILL NOT WORK WITH A SENSOR WHICH IS ALREADY RUNNING.

**sudo apt-get update 

**[sudo] password for *******:
**sudo apt-get install git
**Do you want to continue? [Y/n] y
**git clone https://github.com/wbrettw/LibreLink-xdrip-patch
**cd LibreLink-xdrip-patch
**./install-apt-dependencies.sh
**Do you want to continue? [Y/n] y
**./download.sh
**./patch.sh
**(Deactivate online Functionality? [Y/n] N

N will allow Librelink to send data to a Libreview account.
Y will block the functionality.
**Finished! The patched and signed APK file can be found at APK/"com.freestylelibre.app.de_2019-04-22_patched.apk" in your home folder. You can rename it to "Librelink_patched_v2.apk"

