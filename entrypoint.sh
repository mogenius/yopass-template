#!/bin/sh
set -e

exec $(which memcached) -u memcache -vp 11211 &

#exec /yopass-server
/yopass-server
