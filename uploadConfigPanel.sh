#!/bin/bash
SOURCE_FILE="$1"
ENVIRONMENT="$2"

case $# in
  2)
    ENVIRONMENT="$2"
    ;;
  1)
    ENVIRONMENT="local"
    ;;
  *)
    echo "not enough arguments supplied.  You must supply the flowName to this command."
    return 1
    ;;
esac    

source setEnvForUpload.sh $ENVIRONMENT

if [ -z $FLOW_TOKEN ] ;
then
	return 1
else
	http_response=$(curl $CURL_ARGS -s -o uploadConfigPanelResponse.txt -w "%{http_code}" -X POST -H "flow-token: $FLOW_TOKEN" -H "Content-Type: application/json" "$HOST/repository/configPanels" --data-binary "@src/main/configPanels/$SOURCE_FILE.json")
fi

if [ $http_response != "200" ];
then
  if [ $http_response == "302" ];
  then
    echo "Got unexpected HTTP response ${http_response}. This is likely due to your token being incorrect."
  else
    echo "Got unexpected HTTP response ${http_response}. This is likely an error."
  fi
else
  cat uploadConfigPanelResponse.txt
fi

[ -e uploadConfigPanelResponse.txt ] && rm uploadConfigPanelResponse.txt
