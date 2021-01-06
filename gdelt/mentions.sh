#!/bin/bash
#
# mon=201911


mon=`date "+%Y%m"`

curl http://data.gdeltproject.org/gdeltv2/masterfilelist.txt | awk -F ' ' '{print $3}' | grep http://data.gdeltproject.org/gdeltv2/$mon[01-31] >$mon
wget -c -i $mon -P gdeltv2/$mon
