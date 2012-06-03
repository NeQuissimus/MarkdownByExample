#!/bin/bash

HELP="
$(basename $0) [-chpr] -- build an ebook from Markdown files

Style sheet needs to be located in ./css/
Markdown files need to be located in ./chapters/ 
Chapters will be processed alphabetically

where:
    -c  CSS file name [default: chapters.css]
    -h  show this help text
    -m  Markdown file extension [default: .markdown]
    -p  Paper size (See CUPS documentation) [default: Custom.143x223mm]
    -r  Resulting PDF file name [default: Result.pdf]
    "

while getopts ":c:hm:p:r:" option; do
  case "$option" in
    "c")CSS_FILE=$2
        ;;
    "h")echo "$HELP"
        exit
        ;;
    "m")EXT_CHAPTERS=$OPTARG
        ;;
    "p")PAPER_SIZE=$OPTARG
        ;;
    "r")PDF_FILE=$OPTARG
        ;;
    *)  echo "Unknown parameter $1"
  esac
done

# Check for scripts

## Check for markdown_py
if [ "$(which markdown_py)" == "" ]; then
    echo "This script requires markdown_py"
    exit 1
fi

## Check for wkhtmltopdf
if [ "$(which wkhtmltopdf)" == "" ]; then
    echo "This script requires wkhtmltopdf"
    exit 1
fi

## Check for join.py
if [ ! -e "/System/Library/Automator/Combine PDF Pages.action/Contents/Resources/join.py" ]; then
    echo "This script requires join.py"
    exit 1
fi

# Variables

## Paper size
DEF_PAPER_SIZE="Custom.143x223mm"

## File extensions
DEF_EXT_CHAPTERS=".markdown"
EXT_HTML=".html"
EXT_PDF=".pdf"

## Files

### Default style sheet
DEF_CSS_FILE="chapters.css"

### Default result PDF
DEF_PDF_FILE="Result.pdf"

### Set variables to parameters or default
: ${CSS_FILE:=$DEF_CSS_FILE}
: ${PDF_FILE:=$DEF_PDF_FILE}
: ${EXT_CHAPTERS:=$DEF_EXT_CHAPTERS}
: ${PAPER_SIZE:=$DEF_PAPER_SIZE}

## All files of extension
ALL="*"
ALL_CHAPTERS=$ALL$EXT_CHAPTERS
ALL_HTML=$ALL$EXT_HTML
ALL_PDF=$ALL$EXT_PDF

## Directories

### Working directory
DIR=$( cd "$( dirname "$0" )" && pwd )

### Input directories
IN_CHAPTERS=$DIR"/chapters/"
IN_CSS=$DIR"/css/"

### Output directories
OUT_HTML=$DIR"/_html/"
OUT_PDF=$DIR"/_pdf/"

## Style sheet relative to HTML folder
CSS=$CSS_FILE
## Same style sheet absolute path
CSS_ABS=$IN_CSS$CSS_FILE

## Result PDF
PDF=$DIR"/"$PDF_FILE

# Functions

md2html() {

  if [ "$#" != 1 ]
  then
    echo "Need 1 parameter, had $#! - 1 = Input Markdown"
  else
    filename=$(basename $1)
    filename_noext=$(echo $filename | sed -e 's/\..*//')

    echo '<!DOCTYPE HTML><html><head><title>'$(basename $DIR)'</title>' >> $OUT_HTML$filename_noext$EXT_HTML

    # Inject CSS into output
    if [ -e $CSS_ABS ]; then
        echo '<link rel="stylesheet" type="text/css" href="'$CSS'" />' >> $OUT_HTML$filename_noext$EXT_HTML
    fi

    echo '</head><body>' >> $OUT_HTML$filename_noext$EXT_HTML

    markdown_py -x headerid $1 >> $OUT_HTML$filename_noext$EXT_HTML

    echo '</body></html>' >> $OUT_HTML$filename_noext$EXT_HTML

  fi

}

html2pdf() {

  if [ "$#" != 1 ]
  then
    echo "Need 1 parameter, had $#! - 1 = Input HTML"
  else
    filename=$(basename $1)
    filename_noext=$(echo $filename | sed -e 's/\..*//')
    /System/Library/Printers/Libraries/convert -a 'media='$PAPER_SIZE'' -a 'page-left=48' -a 'page-top=48' -a 'page-right=48' -a 'page-bottom=48' -f $1 -o $OUT_PDF$filename_noext$EXT_PDF
  fi

}

cleanOutput() {

    ## Make sure, output folders exist and are empty
    if [ ! -e $OUT_HTML ]; then
        mkdir $OUT_HTML
    else
        if [ `find $OUT_HTML | wc -l` != 0 ]; then
            rm -R $OUT_HTML
            mkdir $OUT_HTML
        fi
    fi

    if [ ! -e $OUT_PDF ]; then
        mkdir $OUT_PDF
    else
        if [ `find $OUT_PDF | wc -l` != 0 ]; then
            rm $OUT_PDF$ALL_PDF
        fi
    fi

    if [ -e $DIR"/merged.md" ]; then
        rm $DIR"/merged.md"
    fi

}

removeResultPdf() {

    ## Remove result PDF
    if [ -e $PDF ]; then
        rm $PDF
    fi

}

createHtml() {

    ## Create HTML files
    FILES=$(find $IN_CHAPTERS -name $ALL_CHAPTERS)
    for f in $FILES
    do
        ## Merge Markdown files
        cat $f >> merged.md
        echo -e "\n\n" >> merged.md
    done
    md2html merged.md
    rm merged.md

}

copyAssets() {

    if [ -e $IN_CSS ]; then
        cp -R $IN_CSS $OUT_HTML
    fi

    if [ -e $DIR"/img" ]; then
        cp -R $DIR"/img" $OUT_HTML
    fi

}

createPdf() {

    ## Create PDF files
    FILES=$(find $OUT_HTML -name $ALL_HTML)
    for f in $FILES
    do
        html2pdf "$f"
    done

}

mergePdfs() {

    ## Merge PDF files into one
    FILES=$OUT_PDF$ALL_PDF
    "/System/Library/Automator/Combine PDF Pages.action/Contents/Resources/join.py" -o "$PDF" $FILES

}

checkForChapters() {

    if [ `find "$IN_CHAPTERS" -name "$ALL_CHAPTERS" | wc -l` == "0" ]; then
        echo "Did not find any Markdown files with extension $EXT_CHAPTERS in folder $IN_CHAPTERS"
        exit
    fi

}

# Action!

checkForChapters
cleanOutput
removeResultPdf
createHtml
copyAssets
createPdf
mergePdfs
