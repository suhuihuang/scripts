#!/bin/bash
#
# mon=201912


#mon=`date "+%Y%m"`
for mon in 2020{01..12}

do
curl http://data.gdeltproject.org/events/ | awk -F "[<>]" '{print $5}' | grep $mon[01-31] >$mon
wget -B http://data.gdeltproject.org/events/ -c -i $mon  -P events/$mon
done

gdeltv1 () {

for mon in 2020{01..12}

do
curl http://data.gdeltproject.org/events/ | awk -F "[<>]" '{print $5}' | grep $mon[01-31] >$mon
wget -B http://data.gdeltproject.org/events/ -c -i $mon  -P events/$mon
done

}

gdeltv2 () {


}





