**Basics:** 

When Librelink is the first "device" to be paired with a Freestyle Libre 2, it permanently receives Bluetooth data to calculate the current tissue sugar value and, if necessary, to give an alarm. 
However, this data is only displayed when "classic" is scanned (the sensor is read out via NFC). This patch now allows [xDrip+](https://github.com/jamorham/xDrip-plus) to read the calculated values of Librelink and display them permanently - scanning via NFC is no longer necessary. 

In order to install the patched app on an Android smartphone, the same in the settings must allow "install from unknown sources" or, under newer Android versions, a corresponding app must be allowed to "install unknown apps". 
The original Librelink app must be uninstalled before installation. **The pairing to the currently running sensor is lost!  
It makes sense therefore that the change of app is carried out when changing a sensor. 
Once the patched app has been installed, it must still be granted rights to "Location" (for Bluetooth use) and "Storage" (in newer Android versions under "Settings - Apps & Notifications - Librelink - Permissions", otherwise open the menu item "Alarms" in the app and check if you are asked for rights there). 
After that, a new sensor can be paired and the app can be used as usual. In the newer versions of xDrip+ (from ["Nightly Build" from July 15, 2019 or (https://github.com/NightscoutFoundation/xDrip/releases) (click on the top "Assets" and download the APK file download)) there is the data source "Libre2 (patched app)" in the settings. This must be selected to select the values without being shown in classic scanning. It may take some time for the first values to appear in xDrip+. • Notes on this version and how to connect to LibreView 
The original version of the patched app (https://github.com/user987654321resu/Libre2-patched-App) removes any Communication of the app with Abbott and thus also with LibreView. 
Another GitHub user added a German guide and a few scripts to the original version, which Automate the patched app: https://github.com/TinoKossmann/LibreLink-xDrip-Patch. This patch version builds on it and lets the user decide whether to maintain the connection to Abbott should or is capped. For this, the patch.sh script asks which parts of the patch to apply. 



# How to patch the Librelink app to provide xDrip with Value received by bluetooth directly from sensor


**IF YOU WANT TO USE THIS, YOU NEED TO ACTIVATE A NEW SENSOR AFTER THE INSTALLATION PROCEDURE IS COMPLETED, IT DOES NOT WORK WITH ALLREADY ACTIVATED SENSORS!!**

**Already activated sensors will also stop sending alarms to the handset device if they had been activated with the unpatched phone app.**

How to build the LL_Patched_v2 apk (With coptional connection to Libreview account)

sudo apt-get update [sudo] password for *******:
sudo apt-get install git 
Do you want to continue? [Y/n] y
git clone https://github.com/wbrettw/LibreLink-xdrip-patch
cd LibreLink-xdrip-patch
./install-apt-dependencies.sh 
Do you want to continue? [Y/n] y
./download.sh
./patch.sh 
(Deactivate online Functionality ? [Y/n] N


Finished! The patched and signed APK file can be found at APK/"com.freestylelibre.app.de_2019-04-22_patched.apk" in your home folder. You can rename it to "Librelink_patched_v2.apk"

