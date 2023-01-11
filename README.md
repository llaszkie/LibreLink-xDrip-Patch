## Basics:

When a FSL-2 sensor is started using Librelink, the app is paired to the sensor and begins to receive continuous data via Bluetooth.
Librelink calculates and displays the current blood sugar value and, if necessary, triggers alarms.
The data is displayed in Librelink when the FSL-2 sensor is scanned using NFC.
This patch allows Xdrip to collect the values from Librelink and display them continuously.
Scanning using Librelink via NFC is still possible.
The “Online Functionality” version will transfer data from Librelink to a Libreview account each time the sensor is scanned.
Xdrip is able to upload the FSL-2 data to Nightscout every 5 minutes.
Results displayed in Librelink and Xdrip are very closely correlated.

This patch version is that of wbrettw, which is forked from Tino Kossmann’s build with some German to English translation and manual how to use Docker to assemble it (Mac users :-))

It allows the user to decide whether to maintain the connection to Abbott or not.
For this, the patch.sh script asks which parts of the patch to apply.

IF YOU WANT TO USE THIS, YOU NEED TO ACTIVATE A NEW SENSOR, IT WILL NOT WORK WITH A SENSOR WHICH IS ALREADY RUNNING.

## Get patched version on macOS Terminal using Docker:

1. Install [Docker](https://www.docker.com/products/docker-desktop)

2. Open Terminal

3. Make dir for result

```
mkdir librelink
cd librelink
```

4. Enter to docker debian image

```
docker run -it --entrypoint bash -v "$(pwd):/apk"  debian:bullseye
```

5. Execute following commands inside docker-image

```
apt-get update
apt-get install -y sudo git
git clone https://github.com/llaszkie/LibreLink-xDrip-Patch.git
cd LibreLink-xDrip-Patch
yes | ./install-apt-dependencies.sh
./download.sh
./patch.sh
cp APK/com.freestylelibre.app.de_2019-04-22_patched.apk ../apk
exit
```

6. While asked "Deactivate online Functionality? [y/n]" decide

`n` will allow Librelink to send data to a Libreview account.
`y` will block the functionality.

7. You will find in current directory file `com.freestylelibre.app.de_2019-04-22_patched.apk`
