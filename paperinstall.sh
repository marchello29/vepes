#!/bin/bash
export MAIN_DIR=$PWD

if [ ! -f $MAIN_DIR/server/server.jar ]; then
	mkdir server > /dev/null 2>&1
	cd server
else
	echo "Do you really make new server? Folder /server already exits"
	read -p "Make new Server? (yes/no): " newserver
	if [[ $newserver == "yes" ]]; then
	clear
	elif [[ $newserver == "no" ]]; then
		echo "Aborted Installasion"
		exit
	fi
	rm -rf server
	mkdir server
	cd server
fi

MINECRAFT_VERSION=latest
read -p "> Enter minecraft version for server: " MINECRAFT_VERSION

# -- EDIT HERE | DO NOT EDIT ABOVE -- #
BUILD_NUMBER=latest # https://papermc.io/downloads
PROJECT=paper # PROJECT: https://papermc.io/api/v2/projects/
SERVER_JARFILE=server.jar # LEAVE THIS PART ALONE
DL_PATH=https://papermc.io/api/v2/projects
# -- EDIT HERE | DO NOT EDIT BELOW -- # 

if [ -n $DL_PATH ]; then
	# echo -e "Using supplied download url: ${DL_PATH}"
	DOWNLOAD_URL=`eval echo $(echo ${DL_PATH} | sed -e 's/{{/${/g' -e 's/}}/}/g')`

	VER_EXISTS=`curl -s https://papermc.io/api/v2/projects/paper | jq -r --arg VERSION ${MINECRAFT_VERSION} '.versions[] | contains($VERSION)' | grep true`
	LATEST_VERSION=`curl -s https://papermc.io/api/v2/projects/${PROJECT} | jq -r '.versions' | jq -r '.[-1]'`
  if [[ $VER_EXISTS == true ]]; then
		echo -e "Version is valid. Using version ${MINECRAFT_VERSION}"
	else
		# echo -e "Using the latest ${PROJECT} version"
		MINECRAFT_VERSION=${LATEST_VERSION}
	fi
	
	BUILD_EXISTS=`curl -s https://papermc.io/api/v2/projects/${PROJECT}/versions/${MINECRAFT_VERSION} | jq -r --arg BUILD ${BUILD_NUMBER} '.builds[] | tostring | contains($BUILD)' | grep true`
	LATEST_BUILD=`curl -s https://papermc.io/api/v2/projects/${PROJECT}/versions/${MINECRAFT_VERSION} | jq -r '.builds' | jq -r '.[-1]'`
	if [[ $BUILD_EXISTS == true ]]; then
		echo -e "Build is valid for version ${MINECRAFT_VERSION}. Using build ${BUILD_NUMBER}"
	else
		# echo -e "Using the latest ${PROJECT} build for version ${MINECRAFT_VERSION}"
		BUILD_NUMBER=${LATEST_BUILD}
	fi
	
	JAR_NAME=${PROJECT}-${MINECRAFT_VERSION}-${BUILD_NUMBER}.jar
	
	echo "Version being downloaded"
	echo -e "MC Version: ${MINECRAFT_VERSION}"
	echo -e "Build: ${BUILD_NUMBER}"
	echo -e "JAR Name of Build: ${JAR_NAME}"
	DOWNLOAD_URL=https://papermc.io/api/v2/projects/${PROJECT}/versions/${MINECRAFT_VERSION}/builds/${BUILD_NUMBER}/downloads/${JAR_NAME}
fi

# echo -e "Running curl -o ${SERVER_JARFILE} ${DOWNLOAD_URL}"

curl -o ${SERVER_JARFILE} ${DOWNLOAD_URL} > /dev/null 2>&1

if [ ! -f server.properties ]; then
    echo -e "Downloading MC server.properties"
    curl -o server.properties https://raw.githubusercontent.com/parkervcp/eggs/master/minecraft/java/server.properties > /dev/null 2>&1
fi
