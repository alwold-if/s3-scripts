#!/bin/bash

source sync.config
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY

if [ "$#" -lt "1" ]; then
  echo "Usage: $0 {upload|download}"
  exit 1
fi
action=$1

function download () {
  file=$1
  aws s3 cp s3://${host}/$file $file
}

function upload () {
  file=$1
  echo -n "Upload ${file}? [y/n] "
  read choice
  if [ "$choice" == "y" ]; then
    # update timestamp
    cp $file /tmp/${file}.$$
    # TODO make it so this can fail and it will still upload, if you are uploading something other than a config file
    if [[ $file != carousel* && $file == *.json ]]; then
      jq '.configDate = now | .configDate |= todate' /tmp/${file}.$$ > $file
    fi
    if [[ $file == *.xml ]]; then
      content_type="application/xml"
    else
      content_type="application/json"
    fi
    aws s3 cp $file s3://${host}/$file --acl public-read --content-type "application/json" --cache-control "max-age=0"
  fi
}

for file in $files; do
  if [ "$action" = "download" ]; then
    download $file
  fi
  if [ "$action" = "upload" ]; then
    upload $file
  fi
done

