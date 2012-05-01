#!/bin/bash --

# Check for bluecloth

if [ "$(which bluecloth)" == "" ]; then
	echo "This script requires bluecloth"
	exit 1
fi

# Define builder function

build () {

if [ "$#" != 2 ]
then
  echo "Need 2 parameters, had $#! - 1 = Directory, 2 = File name"
else
  MARKDOWN=$1$2$EXT_MD
  HTML=$1$2$EXT_HTML
  if [ -e $MARKDOWN ]
  then
    if [ -e $HTML ]
    then
      rm $HTML
    fi
    bluecloth $MARKDOWN >> $HTML
  else
    error $MARKDOWN
  fi
fi

}

error () {

  if [ "$#" != 1 ]
  then
    echo "Need 1 parameter, had $#! - 1 = File name"
  else
    echo $1$ERROR
  fi

}

# Variables

## Working directory
DIR=$( cd "$( dirname "$0" )" && pwd )

## File extensions
EXT_MD=".md"
EXT_HTML=".html"

## Error message
ERROR=" not found - not built!"

## Path to readme
DIR_README=$DIR"/readme/"
FILE_README="README"

## Path to instructions
DIR_INSTRUCTIONS=$DIR"/instructions/"
FILE_INSTRUCTIONS="done"

## Path to HTML/CSS examples
DIR_HTMLCSS=$DIR"/html_css/"
FILE_HTMLCSS_1="add_css"
FILE_HTMLCSS_2="link_anchors"

# Build 

## Readme
build "$DIR_README" "$FILE_README"

## Instructions
build "$DIR_INSTRUCTIONS" "$FILE_INSTRUCTIONS"

## HTML/CSS examples
build "$DIR_HTMLCSS" "$FILE_HTMLCSS_1"
build "$DIR_HTMLCSS" "$FILE_HTMLCSS_2"
