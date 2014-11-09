#!/usr/bin/env bash
echo " " > outfile.txt
curl http://multiproxy.org/txt_all/proxy.txt > $PWD/hosts.txt
for i in $(for j in $(cat < hosts.txt | cut -d':' -f1) ; do echo $j ; done)
	do (ping -c 2 $i >> outfile.txt &)  
done