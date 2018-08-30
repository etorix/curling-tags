#!/usr/bin/env bash

if [[ $1 ]]
then
repo="$1"
else
repo="${repo}"
fi

token="$(curl -sSL "https://auth.docker.io/token?service=registry.docker.io&scope=repository:circleci/"${repo}":pull" | jq --raw-output .token)" 
list="$(wget -q https://registry.hub.docker.com/v1/repositories/circleci/"${repo}"/tags -O -  | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'  | awk -F: '{print $3}')"
lines="$(wc -l <<< "$list")"
echo LINES=$lines
start=1
for ((i=1 ; i<=$lines ; i++))
do
tag="$(head -n$i <<< "$list" | tail -1)"
echo trying tag $tag
response="$(curl -siI -H "Authorization: Bearer $token" "https://registry-1.docker.io/v2/circleci/php/manifests/"${tag}"")"
response_stripped="$(echo "$response" | tr '\r' ' ' | tr '\n' ' ' | sed 's/ \{3,\}/ /g' | sed 's/   / /g')"
missing="$(grep -o "404" <<< "$response_stripped")"
if [ "$missing" == 404 ]
then
echo -e ""$tag" is missing!" | tee -a /tmp/missing.txt
else
echo "lcd soundsystem - we still got it"
fi  
done
