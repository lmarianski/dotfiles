#!/bin/sh

#
# ESO-Database.com Data Upload Script
# Version 1.0.0
#
# Feel free to change this script to your needs!
# 
# 
# Website: https://www.eso-database.com
#
# Package dependencies: jq curl
# Install on Debian, Ubuntu: sudo apt-get install jq curl
# 
# jq - http://stedolan.github.io/jq/
# curl - http://curl.haxx.se/
#


# Change these values
USERNAME="lukas2005" # or email address
PASSWORD="lukasz2005"
EU_SAVEDVARIABLES='/home/lukas2005/Dokumenty/Elder Scrolls Online/live/SavedVariables/ESODBExport.lua' # leave empty if version not installed
NA_SAVEDVARIABLES="/home/lukas2005/esodir/livena/SavedVariables/ESODBExport.lua" # leave empty if version not installed

# Keep this untouched
UA="ESODBClient/API-LINUX"
URL_API="https://api.eso-database.com/api.php"
URL_DATA="https://data.eso-database.com/upload/lua.php"
USER_TOKEN=""

echo "\033[1;34mESO-Datbase.com\033[0m Data Upload Script started"

# Login and get the result
RESP=$(curl --silent --user-agent ${UA} --data "call=login&lang=en&username=${USERNAME}&password=${PASSWORD}" ${URL_API})

# Fetch results
RESP_STATUS=$(echo ${RESP} | jq --raw-output '.status')
RESP_STATUS_TEXT=$(echo ${RESP} | jq --raw-output '.result.user_token')

# Got OK from server, lets upload the files
if [ ${RESP_STATUS} = "OK" ]; then
	
	# The user token is required for data upload
	USER_TOKEN=${RESP_STATUS_TEXT}

	# Upload the EU file to the ESODB, check if file exists
	if [ -f "${EU_SAVEDVARIABLES}" ]; then
		
		STATUS=$(curl --user-agent ${UA} --cookie "user_token=${USER_TOKEN}" --form file="@${EU_SAVEDVARIABLES}" ${URL_DATA})
		echo $STATUS
		if [ "${STATUS}" = "1" ]; then
			echo "\033[1;32mUpload of EU data completed\033[0m"
		else
			echo "\033[1;31mUpload of EU data failed\033[0m"
		fi
	fi

	# Upload the NA file to the ESODB, check if file exists
	if [ -f ${NA_SAVEDVARIABLES} ]; then
		
		STATUS=$(curl --silent --user-agent ${UA} --cookie "user_token=${USER_TOKEN}" --form file=@${NA_SAVEDVARIABLES} ${URL_DATA})
		
		if [ ${STATUS} = "1" ]; then
			echo "\033[1;32mUpload of NA data completed\033[0m"
		else
			echo "\033[1;31mUpload of NA data failed\033[0m"
		fi
	fi
else
	echo "\033[1;31mAPI error: ${RESP_STATUS_TEXT}\033[0m"
fi

echo "\033[1;34mESO-Datbase.com\033[0m Data Upload Script finished"

exit 0
