#!/bin/bash
for i in {1..12..1}
do
	IGMPLOT $i.igm > $i.log &
	wait $!
done
