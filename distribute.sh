#!/bin/bash
set -e

set $(git ls-tree -r master --name-only | fgrep -v git) ip.map.{gz,bz2} *.h

echo "$@"

scp -i ~/.ssh/beanstock-sandbox.pem -vr "$@" ubuntu@geo-http-server.beanstock.net:src/. &

for f in "$@"; do
	aws s3 cp "$f" s3://databus-dev/geo/$f;
done &

wait
