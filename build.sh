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
ERROR_README="Readme example not found - not built!"

## Path to instructions
DIR_INSTRUCTIONS=$DIR"/instructions/"
INPUT_INSTRUCTIONS=$DIR_INSTRUCTIONS"done.md"
OUTPUT_INSTRUCTIONS=$DIR_INSTRUCTIONS"done.html"
ERROR_INSTRUCTIONS="Instructions example not found - not built!"

# Build 

## Readme
if [ -e $INPUT_README ]
then
  if [ -e $OUTPUT_README ]
  then
    rm $OUTPUT_README
  fi
  bluecloth $INPUT_README >> $OUTPUT_README
else
  echo $ERROR_README
fi

## Instructions
if [ -e $INPUT_INSTRUCTIONS ]
then
  if [ -e $OUTPUT_INSTRUCTIONS ]
  then
  	rm $OUTPUT_INSTRUCTIONS
  fi
  bluecloth $INPUT_INSTRUCTIONS >> $OUTPUT_INSTRUCTIONS
else
  echo $ERROR_INSTRUCTIONS
fi
