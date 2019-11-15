#!/bin/bash

while read f; do
	src=${f#"usrsctplib/"}
	echo cp usrsctp/kernel/$f kernel_src/sys/$src
	cp usrsctp/kernel/$f kernel_src/sys/$src
done < files_to_sync
