#!/bin/sh
# Download the CIFAR-10 dataset into this directory (cs682/datasets).
#
# Works with bash, zsh and sh on macOS, Linux, Windows Subsystem for Linux
# and Google Colab:
#
#   bash get_datasets.sh

set -e

cd "$(dirname "$0")"

URL="https://www.cs.toronto.edu/~kriz/cifar-10-python.tar.gz"
ARCHIVE="cifar-10-python.tar.gz"
DATA_DIR="cifar-10-batches-py"

have_all_batches() {
  for f in data_batch_1 data_batch_2 data_batch_3 data_batch_4 data_batch_5 test_batch; do
    [ -f "$DATA_DIR/$f" ] || return 1
  done
}

if have_all_batches; then
  echo "CIFAR-10 is already in $(pwd)/$DATA_DIR; nothing to do."
  exit 0
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "Error: the 'curl' command is not installed." >&2
  echo "  Ubuntu / WSL:  sudo apt install curl" >&2
  exit 1
fi

echo "Downloading CIFAR-10 (about 163 MB)..."
# -f: fail on HTTP errors, -L: follow redirects
curl -fL --retry 3 -o "$ARCHIVE" "$URL"

echo "Extracting..."
tar -xzf "$ARCHIVE"
rm -f "$ARCHIVE"

if have_all_batches; then
  echo "Done: CIFAR-10 is in $(pwd)/$DATA_DIR"
else
  echo "Error: extraction finished but some CIFAR-10 files are missing." >&2
  exit 1
fi
