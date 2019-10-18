#!/bin/bash

#set -e
FOLDER=$1
DEFINITIONS=$( cat $2 | tr '\n' ' ')
HFILES=$FOLDER/*.h
CFILES=$FOLDER/*.c

OUTDIR=./out/
echo "Stripping .c and .h files in $FOLDER"



for f in $HFILES $CFILES
do
	filename=$(basename -- "$f")
	dir="$(dirname $f)"
	dir="$(basename $dir)"
	targetdir=$OUTDIR/$dir
	mkdir -p $targetdir
 	unifdef $DEFINITIONS -o $targetdir/$filename $f
done	
