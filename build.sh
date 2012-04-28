#!/bin/bash --

# Check for bluecloth

if [ "$(which bluecloth)" == "" ]; then
	echo "This script requires bluecloth"
	exit 1
fi

# Variables

## Working directory
DIR=$( cd "$( dirname "$0" )" && pwd )

## Path to readme
DIR_README=$DIR"/readme/"
INPUT_README=$DIR_README"README.md"
OUTPUT_README=$DIR_README"README.html"
ERROR_README="Readme example not found - not build!"

# Build 

## Readme
if [ -e $INPUT_README ]
then
  rm $OUTPUT_README && bluecloth $INPUT_README >> $OUTPUT_README
else
  echo $ERROR_README
fi
