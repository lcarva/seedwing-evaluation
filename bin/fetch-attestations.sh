#!/bin/bash
#
# Extract attestations for a particular image ref.
#
# (This can be done more easily with cosign download, but I wanted to do it the hard
# way as a learning exercise, and to avoid introducing cosign as a dependency.)

# Use bash "safe mode" for hacking sanity
set -euo pipefail
IFS=$'\n\t'

# Expect one parameter, an image ref
IMAGE_REF=$1

# Use skopeo to read details about the image
INSPECT_DATA=$( skopeo inspect --no-tags docker://$IMAGE_REF )

# Extract the repo name and the image digest
IMAGE_REPO=$( echo "$INSPECT_DATA" | jq -r .Name )
IMAGE_DIGEST=$( echo "$INSPECT_DATA" | jq -r .Digest )

# Derive the name of the tag that should point to the relevant attestation
ATT_TAG=$( echo "$IMAGE_DIGEST" | tr ':' '-' ).att

# Copy down the attestation image
TMP_DIR=$( mktemp -d )
skopeo copy --quiet docker://$IMAGE_REPO:$ATT_TAG dir://$TMP_DIR

# Look inside the manifest.json file to find the layers
ATT_LAYERS=$( cat $TMP_DIR/manifest.json | jq -r '.layers | .[].digest | split(":")[1]' )

# Each layer contains an individual attestation. Output them jsonl style, one per line
for att in $ATT_LAYERS; do
  cat $TMP_DIR/$att
  echo
done

# Clean up the temp directory
rm -rf $TMP_DIR
