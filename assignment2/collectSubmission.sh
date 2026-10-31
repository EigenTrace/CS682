#!/bin/sh
# Package your code and notebooks into a zip file to upload to Gradescope.
# The CIFAR-10 dataset, build artifacts, PDFs and helper files are left out.
#
# Run from the assignment2 directory (works with bash, zsh and sh on
# macOS, Linux and Windows Subsystem for Linux):
#
#   bash collectSubmission.sh             # asks for your UMass ID
#   bash collectSubmission.sh <UMassID>   # e.g. bash collectSubmission.sh arnaik
#
# On Google Colab, pass your UMass ID as an argument:
#   !bash collectSubmission.sh <UMassID>
#
# If no UMass ID is given, the zip file is named assignment2.zip.
# Export and merge your notebooks into a PDF separately.

set -e

cd "$(dirname "$0")"

if [ ! -d cs682 ]; then
  echo "Error: the cs682 directory is missing; keep this script in the assignment2 directory." >&2
  exit 1
fi

for file in FullyConnectedNets.ipynb BatchNormalization.ipynb Dropout.ipynb ConvolutionalNetworks.ipynb PyTorch.ipynb; do
  if [ ! -f "$file" ]; then
    echo "Error: required notebook $file not found." >&2
    exit 1
  fi
done

if ! command -v zip >/dev/null 2>&1; then
  echo "Error: the 'zip' command is not installed." >&2
  echo "  Ubuntu / WSL:  sudo apt install zip" >&2
  exit 1
fi

if [ $# -gt 1 ]; then
  echo "Usage: bash collectSubmission.sh [UMassID]" >&2
  exit 1
fi

# Strip whitespace and a trailing @umass.edu, then check the characters.
clean_id() {
  cleaned=$(printf '%s' "$1" | tr -d '[:space:]')
  cleaned=${cleaned%@umass.edu}
  case $cleaned in
    *[!A-Za-z0-9._-]*) return 1 ;;
  esac
  printf '%s' "$cleaned"
}

umass_id=""
if [ $# -gt 0 ]; then
  if ! umass_id=$(clean_id "$1"); then
    echo "Error: '$1' is not a valid UMass ID (letters, digits, '.', '_' and '-' only)." >&2
    exit 1
  fi
elif [ -t 0 ]; then
  while :; do
    printf 'Enter your UMass ID (e.g. arnaik), or press Enter to skip: '
    raw_id=""
    read -r raw_id || true
    if umass_id=$(clean_id "$raw_id"); then
      break
    fi
    echo "  '$raw_id' is not a valid UMass ID (letters, digits, '.', '_' and '-' only)."
  done
fi

if [ -n "$umass_id" ]; then
  zip_name="$umass_id.zip"
else
  zip_name="assignment2.zip"
  echo "No UMass ID given; naming the file $zip_name."
  echo "Please rename it to <UMassID>.zip, or rerun: bash collectSubmission.sh <UMassID>"
fi

rm -f "./$zip_name"
zip -r -q "./$zip_name" . \
  -x "*.git*" "*cs682/datasets*" "*cifar-10-batches-py*" "*.ipynb_checkpoints*" \
     "*__pycache__*" "*.DS_Store" "*__MACOSX*" "*.zip" "*.tar.gz" "*.pdf" \
     ".env/*" ".venv/*" "venv/*" "*cs682/build/*" \
     "*.pyc" "*.pyo" "*.so" "*.pyd" "*.o" "*.obj" "*.exp" "*.lib" \
     "*cs682/im2col_cython.c" \
     "*README.md" "*collectSubmission.sh" "*requirements.txt" \
     "frameworkpython" "*start_ipython_osx.sh"

echo "Created $zip_name"
echo "Upload $zip_name together with the PDF of your notebooks to Gradescope."
