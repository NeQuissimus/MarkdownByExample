#!/bin/bash --

# Working directory
DIR=$( cd "$( dirname "$0" )" && pwd )

# Logger
logn() {
  echo -n "$1" >&2
}

log() {
  echo "$1" >&2
}

# Converters
## Find converters
find_converter() {
  if [ "$(command -v $1)" == "" ]; then echo false; else echo true; fi
}

## Check availability
BIN_BFDOCS=$(find_converter "bfdocs")
BIN_BLUECLOTH=$(find_converter "bluecloth")
BIN_JEKYLL=$(find_converter "jekyll")
BIN_LANDSLIDE=$(find_converter "landslide")
BIN_MARKDOC=$(find_converter "markdoc")
BIN_MDPRESS=$(find_converter "mdpress")
BIN_SBT=$(find_converter "sbt")
BIN_SHOWOFF=$(find_converter "showoff")

## Converter calls
### $1 = Converter, $2 = Name, $3 = All other parameters
convert() {
  logn "Building $2 .......... "
  case "$1" in
    "bluecloth") if $BIN_BLUECLOTH ; then echo $(convert_bluecloth $3); else log "FAILED - bluecloth not found"; fi ;;
    "landslide") if $BIN_LANDSLIDE ; then echo $(convert_landslide $3); else log "FAILED - landslide not found"; fi ;;
    "bfdocs") if $BIN_BFDOCS ; then echo $(convert_bfdocs $3); else log "FAILED - bfdocs not found"; fi ;;
    "mdpress") if $BIN_MDPRESS ; then echo $(convert_mdpress $3); else log "FAILED - mdpress not found"; fi ;;
    "showoff") if $BIN_SHOWOFF ; then echo $(convert_showoff $3); else log "FAILED - showoff not found"; fi ;;
    "sbt") if $BIN_SBT ; then echo $(convert_sbt $3); else log "FAILED - sbt not found"; fi ;;
    "octopress") if $BIN_JEKYLL; then echo $(convert_octopress $3); else log "FAILED - jekyll not found"; fi ;;
    "jekyll") if $BIN_JEKYLL; then echo $(convert_jekyll $3); else log "FAILED - jekyll not found"; fi ;;
    "markdoc") if $BIN_MARKDOC; then echo $(convert_markdoc $3); else log "FAILED - markdoc not found"; fi ;;
    *) log "FAILED" ;;
  esac
}

## Specific conversions
### $1 = Input Markdown, $2 = Output HTML
convert_bluecloth() {
  log "OK"
  exec 2>/dev/null # Shut up
  bluecloth "$1" > "$2"
  exec 2>/dev/stderr
}

### $1 = Input file, $2 = Output file
convert_landslide() {
  log "OK"
  landslide "$1" -d "$2" 
}

### $1 = Input manifest, $2 = Output folder
convert_bfdocs() {
  if [ ! -e "$2"]; then mkdir -p "$2"; fi
  log "OK"
  bfdocs --base-url="." "$1" "$2"
}

### $1 = Output folder, $2 = Input file (relative to $1)
convert_mdpress() {
  if [ -e $1 ]; then
    cd "$1"
    mdpress "./$2"
    log "OK"
  else
    log "FAILED - output folder not found"
  fi
  cd $DIR;
}

### $1 = Input/output folder
convert_showoff() {
  if [ -e $1 ]; then
    cd "$1"
    log "OK"
    exec 2>/dev/null # Shut up
    showoff static
    exec 2>/dev/stderr
  else
    log "FAILED - folder not found"
  fi
  cd $DIR;
}

### $1 = Input folder
convert_sbt() {
  if [ -e $1 ]; then
    cd "$1"
    log "OK"
    exec 2>/dev/null # Shut up
    sbt scalaslide:gen
    exec 2>/dev/stderr
  else
    log "FAILED - folder not found"
  fi
  cd $DIR
}

### $1 = Input folder
convert_octopress() {
  if [ -e "$1" ]; then
    cd "$1"
    log "OK"
    exec 1>/dev/null 2>/dev/null # Shut up
    rake generate
    exec 1>/dev/stdout 2>/dev/stderr
  else
    log "FAILED - folder not found"
  fi
  cd $DIR;
}

### $1 = Input folder, $2 = Output folder
convert_jekyll() {
  log "OK"
  exec 1>/dev/null 2>/dev/null # Shut up
  jekyll "$1" "$2" --no-server --no-auto
  exec 1>/dev/stdout 2>/dev/stderr
}

### $1 = folder
convert_markdoc() {
  if [ -e "$1" ]; then
    cd "$1"
    log "OK"
    markdoc build
  else
    log "FAILED - folder not found"
  fi
  cd $DIR;
}

# Convert
## /blog/
echo $(convert "octopress" "Blog" "$DIR/blog") >> /dev/null
## /documentation/
echo $(convert "bfdocs" "Documentation" "$DIR/documenation/manifest_split.json $DIR/documentation/out") >> /dev/null
## /html_css/
echo $(convert "bluecloth" "Add CSS" "$DIR/html_css/add_html.md $DIR/html_css/add_html.html") >> /dev/null
echo $(convert "bluecloth" "Link anchors" "$DIR/html_css/link_anchors.md $DIR/html_css/link_anchors.html") >> /dev/null
## /readme/
echo $(convert "bluecloth" "README" "$DIR/readme/README.md $DIR/readme/README.html") >> /dev/null
## /readme_landslide/
echo $(convert "landslide" "Landslide presentation" "$DIR/readme_landslide/preso.md $DIR/readme_landslide/preso.html") >> /dev/null
## /readme_mdpress/
echo $(convert "mdpress" "mdpress presentation" "$DIR/readme_mdpress preso.md") >> /dev/null
## /readme_preso/
echo $(convert "showoff" "ShowOff presentation" "$DIR/readme_preso") >> /dev/null
## /scalaslide/
echo $(convert "sbt" "ScalaSlide presentation" "$DIR/scalaslide") >> /dev/null
## /website/
echo $(convert "jekyll" "Website" "$DIR/website $DIR/website/_site") >> /dev/null
## /wiki/
echo $(convert "markdoc" "Wiki" "$DIR/wiki") >> /dev/null
