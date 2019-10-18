#!/bin/bash

while read f; do
	src=${f#"usrsctplib/"}
	echo kernel_src/sys/$src usrsctp/$f
	cp kernel_src/sys/$src usrsctp/jf/$f
done < files_to_sync
