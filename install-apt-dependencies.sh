#!/bin/bash

# Color codes
NORMAL='\033[0;39m'
GREEN='\033[1;32m'
RED='\033[1;31m'
WHITE='\033[1;37m'
YELLOW='\033[1;33m'

WORKDIR=$(pwd)
FILENAME='com.freestylelibre.app.de_2019-04-22'

echo -e "${WHITE}Install the tools you need ...${NORMAL}"
sudo apt-get install git wget apksigner zipalign android-framework-res
if [ $? = 0 ]; then
  echo -e "${GREEN}  okay.${NORMAL}"
  echo
else
  echo -e "${RED}  not okay.${NORMAL}"
  echo
  echo -e "${YELLOW}=> Please check the above errors.${NORMAL}"
  exit 1
fi
