#!/bin/bash

# Color codes
NORMAL='\033[0;39m'
GREEN='\033[1;32m'
RED='\033[1;31m'
WHITE='\033[1;37m'
YELLOW='\033[1;33m'

WORKDIR=$(pwd)
FILENAME='com.freestylelibre.app.de_2019-04-22'

# wget HSTS-bugfix for debian as subsystem in Windows
touch ~/.wget-hsts
chmod 644 ~/.wget-hsts

echo -e "${WHITE}Download the original APK ...${NORMAL}"
wget -O APK/apkpure.html --keep-session-cookies --save-cookies cookies.txt -U chrome https://apkpure.com/de/freestyle-librelink-de/com.freestylelibre.app.de/download/4751-APK
URL=$(grep "hier klicken" APK/apkpure.html | sed 's#^.*https://##' | sed 's/">.*//')
wget -O APK/${FILENAME}.apk --load-cookies cookies.txt -U chrome https://${URL}
if [ $? = 0 ]; then
  echo -e "${GREEN}  Done.${NORMAL}"
  echo
else
  echo -e "${RED}  Error.${NORMAL}"
  echo
  echo -e "${YELLOW}=> Please check the above errors.${NORMAL}"
  exit 1
fi
rm cookies.txt
rm APK/apkpure.html

echo -e "${WHITE}Download 'apktool' ...${NORMAL}"
echo "Info: Debian provides a 'dirty' version that does not work. Hence the external download."
mkdir -p tools
wget -q -O tools/apktool https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool
chmod 755 tools/apktool
wget -q -O tools/apktool.jar https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.4.0.jar
if [ $? = 0 ]; then
  echo -e "${GREEN}  Done.${NORMAL}"
  echo
else
  echo -e "${RED}  Error.${NORMAL}"
  echo
  echo -e "${YELLOW}=> Please check the above errors.${NORMAL}"
  exit 1
fi
