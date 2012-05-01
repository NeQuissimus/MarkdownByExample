#!/bin/bash --

# Check for bluecloth

if [ "$(which bluecloth)" == "" ]; then
	echo "This script requires bluecloth"
	exit 1
fi

# Define builder function

build () {

if [ "$#" != 3 ]
then
  echo "Need 3 parameters, had $#! - $1 = Markdown file, $2 = HTML file, $3 = Error message"
else
  if [ -e $1 ]
  then
    if [ -e $2 ]
    then
      rm $2
    fi
    bluecloth $1 >> $2
  else
    echo $3
  fi
fi

}

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

## Path to HTML/CSS examples
DIR_HTMLCSS=$DIR"/html_css/"
INPUT_HTMLCSS_1=$DIR_HTMLCSS"add_css.md"
OUTPUT_HTMLCSS_1=$DIR_HTMLCSS"add_css.html"
INPUT_HTMLCSS_2=$DIR_HTMLCSS"link_anchors.md"
OUTPUT_HTMLCSS_2=$DIR_HTMLCSS"link_anchors.html"
ERROR_HTMLCSS="HTML/CSS example not found - not built!"

# Build 

## Readme
build "$INPUT_README" "$OUTPUT_README" "$ERROR_README"

## Instructions
build "$INPUT_INSTRUCTIONS" "$OUTPUT_INSTRUCTIONS" "$ERROR_INSTRUCTIONS"

## HTML/CSS examples
build "$INPUT_HTMLCSS_1" "$OUTPUT_HTMLCSS_1" "$ERROR_HTMLCSS"
build "$INPUT_HTMLCSS_2" "$OUTPUT_HTMLCSS_2" "$ERROR_HTMLCSS"
