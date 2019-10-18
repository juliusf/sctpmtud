#!/bin/bash

#set -e
BASE_FOLDER=$1
DEFINITIONS=$( cat $2 | tr '\n' ' ')
FILES=$3

OUTDIR=./out/
echo "Stripping .c and .h files in $FOLDER"



while read f; do
	f=$BASE_FOLDER$f
	filename=$(basename -- "$f")
	dir="$(dirname $f)"
	dir="$(basename $dir)"
	targetdir=$OUTDIR/$dir
	mkdir -p $targetdir
 	unifdef $DEFINITIONS -o $targetdir/$filename $f
done < $FILES	
