#!/bin/bash
export MAIN_DIR=$PWD

echo "Which Server do you want to install?"
echo "Type [1] Java Server"
echo "Type [2] Bedrock Server"

choiseForServer=1
read -p "Select One: " choiseForServer

if [[ $choiseForServer == "" ]]; then
  echo "Cancelled Installasion. Aborted Installasion"
elif [[ $choiseForServer == "1" ]]; then
install_server () {
  choice=$1
	if [[ $choice == "1" ]]; then
		clear
    echo "> Installing Paper..."
    wget -O paperinstall.sh https://github.com/marchello29/vepes/raw/main/paperinstall.sh > /dev/null 2>&1
		bash paperinstall.sh
		rm -rf paperinstall.sh
	fi
}

software() {
clear
echo "-- Pick the following Server type: --"
echo "1. Paper"
echo "2. Vanilla"
echo "3. Forge"
echo "4. Sponge"
echo "5. Fabric"
echo "6. Spigot"
echo "7. BungeeCord"
read -p "Select: " software
if [[ $software == "" ]]; then
software
else
	install_server $software
fi
}

software
fi
