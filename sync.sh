#!/bin/sh

source sync.config

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
  # update timestamp
  cp $file /tmp/${file}.$$
  jq '.configDate = now | .configDate |= todate' /tmp/${file}.$$ > $file
  aws s3 cp $file s3://${host}/$file --acl public-read --content-type "application/json" --cache-control "max-age=0"
}

for file in $files; do
  if [ "$action" = "download" ]; then
    download $file
  fi
  if [ "$action" = "upload" ]; then
    upload $file
  fi
done

