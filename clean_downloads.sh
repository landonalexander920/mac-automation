#!/bin/zsh
# clean_downloads.sh
# Sorts everything in your Downloads folder into subfolders by file type.
# Run "plan" to preview, then "apply" to actually move files. Nothing runs by default.
# Nothing is ever deleted. Files only get moved into folders.

DOWNLOADS="$HOME/Downloads"
# Safe by default: nothing moves unless you type "apply"
if [[ $# -ne 1 || ( "$1" != "plan" && "$1" != "apply" ) ]]; then
  echo "Usage: clean_downloads.sh plan|apply"
  echo "  plan  = preview what would move"
  echo "  apply = actually move the files"
  exit 1
fi

DRY_RUN=true
[[ "$1" == "apply" ]] && DRY_RUN=false

# Make sure the Downloads folder actually exists before doing anything
if [[ ! -d "$DOWNLOADS" ]]; then
  echo "Could not find $DOWNLOADS. Nothing was changed."
  exit 1
fi

# Which folder each file extension goes into
typeset -A FOLDERS
FOLDERS=(
  pdf Documents  doc Documents  docx Documents  txt Documents  rtf Documents
  pptx Documents  xlsx Documents  csv Documents  pages Documents
  png Images  jpg Images  jpeg Images  heic Images  gif Images  webp Images  svg Images
  mp4 Videos  mov Videos  mkv Videos
  mp3 Audio  wav Audio  m4a Audio
  zip Archives  rar Archives  7z Archives  tar Archives  gz Archives
  dmg Installers  pkg Installers  iso Installers
  py Code  sh Code  ps1 Code  json Code  html Code  js Code
)

moved=0

# (.N) means: only regular files (no folders), and do not error if Downloads is empty
for file in "$DOWNLOADS"/*(.N); do
  name="${file:t}"          # just the file name, no path
  ext="${${name:e}:l}"      # the extension, lowercased (PDF becomes pdf)

  # Skip files that are still downloading
  [[ "$ext" == "crdownload" || "$ext" == "part" || "$ext" == "download" ]] && continue

  folder="${FOLDERS[$ext]:-Other}"   # unknown types go to Other
  dest="$DOWNLOADS/$folder/$name"

  # If a file with the same name is already there, add (1), (2), etc. instead of overwriting
  n=1
  while [[ -e "$dest" ]]; do
    if [[ -n "$ext" ]]; then
      dest="$DOWNLOADS/$folder/${name:r} ($n).${name:e}"
    else
      dest="$DOWNLOADS/$folder/$name ($n)"
    fi
    ((n++))
  done

  if $DRY_RUN; then
    echo "[preview] $name  ->  $folder/"
  else
    mkdir -p "$DOWNLOADS/$folder"
    # -n = never overwrite an existing file, as a second safety net
    mv -n "$file" "$dest"
    echo "Moved $name  ->  $folder/"
  fi
  ((moved++))
done

if $DRY_RUN; then
  echo "\nPreview done. $moved file(s) would be moved. Run with apply to do it for real."
else
  echo "\nDone. Moved $moved file(s)."
fi
