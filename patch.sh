#!/bin/bash

# Color codes
NORMAL='\033[0;39m'
GREEN='\033[1;32m'
RED='\033[1;31m'
WHITE='\033[1;37m'
YELLOW='\033[1;33m'

WORKDIR=$(pwd)
FILENAME='com.freestylelibre.app.de_2019-04-22'

echo -e "${WHITE}Check required tools ...${NORMAL}"
MISSINGTOOL=0
echo -en "${WHITE}  apksigner ... ${NORMAL}"
which apksigner > /dev/null
if [ $? = 0 ]; then
  echo -e "${GREEN}found.${NORMAL}"
else
  echo -e "${RED}not found.${NORMAL}"
  MISSINGTOOL=1
fi
echo -en "${WHITE}  apktool ... ${NORMAL}"
if [ -x tools/apktool ]; then
  echo -e "${GREEN}found.${NORMAL}"
  APKTOOL=$(pwd)/tools/apktool
else
  which apktool > /dev/null
  if [ $? = 0 ]; then
    echo -e "${GREEN}found.${NORMAL} Origin and compatibility unknown
."
    APKTOOL=$(which apktool)
  else
    echo -e "${RED}nicht found.${NORMAL}"
    MISSINGTOOL=1
  fi
fi
echo -en "${WHITE}  git ... ${NORMAL}"
which git > /dev/null
if [ $? = 0 ]; then
  echo -e "${GREEN}found.${NORMAL}"
else
  echo -e "${RED}not found.${NORMAL}"
  MISSINGTOOL=1
fi
echo -en "${WHITE}  keytool ... ${NORMAL}"
which keytool > /dev/null
if [ $? = 0 ]; then
  echo -e "${GREEN}found.${NORMAL}"
else
  echo -e "${RED}not found.${NORMAL}"
  MISSINGTOOL=1
fi
echo -en "${WHITE}  zipalign ... ${NORMAL}"
which zipalign > /dev/null
if [ $? = 0 ]; then
  echo -e "${GREEN}found.${NORMAL}"
else
  echo -e "${RED}not found.${NORMAL}"
  MISSINGTOOL=1
fi
echo
if [ ${MISSINGTOOL} = 1 ]; then
  echo -e "${YELLOW}=> Please install the necessary tools.${NORMAL}"
  exit 1
fi

echo -e "${WHITE} APK File '${FILENAME}.apk' ...${NORMAL}"
if [ -e APK/${FILENAME}.apk ]; then
  echo -e "${GREEN}  found.${NORMAL}"
  echo
else
  echo -e "${RED}  Not found.${NORMAL}"
  echo
  echo -e "${YELLOW}=> Please download the original file from https://www.apkmonk.com/download-app/com.freestylelibre.app.de/5_com.freestylelibre.app.de_2019-04-22.apk/ herunter und legen Sie sie im Verzeichnis APK/ ab.${NORMAL}"
  exit 1
fi

echo -e "${WHITE}MD5 checksum ...${NORMAL}"
md5sum -c APK/${FILENAME}.apk.md5 > /dev/null 2>&1
if [ $? = 0 ]; then
  echo -e "${GREEN}  Done.${NORMAL}"
  echo
else
  echo -e "${RED}  Not done.${NORMAL}"
  echo
  echo -e "${YELLOW}=> Please download the correct, genuine original APK.${NORMAL}"
  exit 1
fi

echo -e "${WHITE}Unpack original APK file ...${NORMAL}"
${APKTOOL} d -o /tmp/librelink APK/${FILENAME}.apk
if [ $? = 0 ]; then
  echo -e "${GREEN}  Done.${NORMAL}"
  echo
else
  echo -e "${RED}  Not done.${NORMAL}"
  echo
  echo -e "${YELLOW}=> Please check O.A. errors.${NORMAL}"
  exit 1
fi

echo -e "${WHITE}Patch original App ...${NORMAL}"

cat <<EOF

With online functionality deactivated, the license check and cloud messaging in the app. 
It is no longer necessary to connect to the app with username password, and the app no longer transmits data to the manufacturer. 
WARNING: Without online features, no more data can be sent to LibreView! 
If you use LibreView to create reports, you must use the Leave online features enabled! 
In addition, only values are exceeded available in the app itself, i.e. those that are available via NFC. (scanning on the sensor). 
To get a complete profile, you must therefore be at least once every 8 hours scan the sensor with the mobile phone via NFC.


EOF

patches=0001-Add-forwarding-of-Bluetooth-readings-to-other-apps.patch
while true ; do
    read -p "Deactivate Online Functionality? [y/n] " result
    case ${result} in
        Y | y | Yes | yes | "" )
            patches+=" 0002-Disable-uplink-features.patch"
            appmode=Offline
            break;;
        n | N | no | No )
            appmode=Online
            break;;
        * )
            echo "${RED}Please answer with yes or no!${NORMAL}";;
    esac
done

cd /tmp/librelink/
for patch in ${patches} ; do
    echo -e "${WHITE}Patch : ${patch}${NORMAL}"
    git apply --whitespace=nowarn --verbose "${WORKDIR}/${patch}"
    if [ $? = 0 ]; then
        echo -e "${GREEN}  Done.${NORMAL}"
        echo
    else
        echo -e "${RED}  Not done.${NORMAL}"
        echo
        echo -e "${YELLOW}=> Please check O.A. errors.${NORMAL}"
        exit 1
    fi
done

echo -e "${WHITE}Use new source code for patched app ...${NORMAL}"
cp -Rv ${WORKDIR}/sources/* /tmp/librelink/smali_classes2/com/librelink/app/
if [ $? = 0 ]; then
  echo -e "${GREEN}  okay.${NORMAL}"
  echo
else
  echo -e "${RED}  Not done.${NORMAL}"
  echo
  echo -e "${YELLOW}=> Please check O.A. errors.${NORMAL}"
  exit 1
fi
chmod 644 /tmp/librelink/smali_classes2/com/librelink/app/*.smali

echo -e "${WHITE}Use new graphics for patched app
 ...${NORMAL}"
cp -Rv ${WORKDIR}/graphics/* /tmp/librelink/
if [ $? = 0 ]; then
  echo -e "${GREEN}  Done.${NORMAL}"
  echo
else
  echo -e "${RED}  Not done.${NORMAL}"
  echo
  echo -e "${YELLOW}=> Please check O.A. errors.${NORMAL}"
  exit 1
fi

echo -e "${WHITE}Copy original APK file in patched app...${NORMAL}"
cp ${WORKDIR}/APK/${FILENAME}.apk /tmp/librelink/assets/original.apk
if [ $? = 0 ]; then
  echo -e "${GREEN}  Done.${NORMAL}"
  echo
else
  echo -e "${RED}  Not done.${NORMAL}"
  echo
  echo -e "${YELLOW}=> Please check O.A. errors.${NORMAL}"
  exit 1
fi

echo -e "${WHITE}Build patched app together ...${NORMAL}"
${APKTOOL} b -o ${WORKDIR}/APK/librelink_unaligned.apk
if [ $? = 0 ]; then
  echo -e "${GREEN}  Done.${NORMAL}"
  echo
else
  echo -e "${RED}  Not done.${NORMAL}"
  echo
  echo -e "${YELLOW}=> Please check O.A. errors.${NORMAL}"
  exit 1
fi

echo -e "${WHITE}Räume /tmp/ on ...${NORMAL}"
cd ${WORKDIR}
rm -rf /tmp/librelink/
echo -e "${GREEN}  Done."
echo

echo -e "${WHITE}Optimize alignment of patched APK file ...${NORMAL}"
zipalign -p 4 APK/librelink_unaligned.apk APK/${FILENAME}_patched.apk
if [ $? = 0 ]; then
  echo -e "${GREEN}  Done.${NORMAL}"
  echo
  rm APK/librelink_unaligned.apk
else
  echo -e "${RED}  Not done.${NORMAL}"
  echo
  echo -e "${YELLOW}=> Please check O.A. errors.${NORMAL}"
  exit 1
fi

echo -e "${WHITE}Erstelle Keystore for signing the patched APK file ...${NORMAL}"
keytool -genkey -v -keystore /tmp/libre-keystore.p12 -storetype PKCS12 -alias "Libre Signer" -keyalg RSA -keysize 2048 --validity 10000 --storepass geheim --keypass geheim -dname "cn=Libre Signer, c=de"
if [ $? = 0 ]; then
  echo -e "${GREEN}  Done.${NORMAL}"
  echo
else
  echo -e "${RED}  Not done.${NORMAL}"
  echo
  echo -e "${YELLOW}=> Please check O.A. errors.${NORMAL}"
  exit 1
fi

echo -e "${WHITE} patched APK file ...${NORMAL}"
if [ -x /usr/lib/android-sdk/build-tools/debian/apksigner.jar ]; then
  java -jar /usr/lib/android-sdk/build-tools/debian/apksigner.jar sign --ks-pass pass:geheim --ks /tmp/libre-keystore.p12 APK/${FILENAME}_patched.apk
elif [ -x /usr/share/apksigner/apksigner.jar ]; then
  java -jar /usr/share/apksigner/apksigner.jar sign --ks-pass pass:geheim --ks /tmp/libre-keystore.p12 APK/${FILENAME}_patched.apk
else
  apksigner sign --ks-pass pass:geheim --ks /tmp/libre-keystore.p12 APK/${FILENAME}_patched.apk
fi
if [ $? = 0 ]; then
  echo -e "${GREEN}  Done.${NORMAL}"
  echo
  rm /tmp/libre-keystore.p12
else
  echo -e "${RED}  Not done.${NORMAL}"
  echo
  echo -e "${YELLOW}=> Please check O.A. errors.${NORMAL}"
  exit 1
fi

if [ -d /mnt/c/ ]; then
  echo -e "${WHITE}Windows-system -detected ...${NORMAL}"
  echo -e "${WHITE}Kopiere APK ...${NORMAL}"
  mkdir -p /mnt/c/APK
  cp APK/${FILENAME}_patched.apk /mnt/c/APK/
  if [ $? = 0 ]; then
    echo -e "${GREEN}  Done.${NORMAL}"
    echo
  echo -en "${GREEN}Finished! The patched and signed APK file can be found at Home/Librelink-Xdrip-Patch/APK"
  echo -en "\\"
  echo -e "${FILENAME}_patched.apk${NORMAL}"
  else
    echo -e "${RED}  Not done.${NORMAL}"
    echo
    echo -e "${YELLOW}=> Please check O.A. errors.${NORMAL}"
    exit 1
  fi
else
  echo -e "${GREEN}Finished ! the signed and patched file can be found at Home/Librelink-Xdrip-Patch/APK/${FILENAME}_patched.apk${NORMAL}"
fi

echo -en "${GREEN} The patched app runs in the ${appmode}-Modus"
if [[ ${appmode} == Online ]] ; then
  echo -e " (with LibreView support)${NORMAL}"
else
  echo -e " (without LibreView support)${NORMAL}"
fi
