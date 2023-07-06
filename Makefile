
check-cve-good:
	swio eval --input input/good.json --policy policies --name cve::allow

check-cve-bad:
	swio eval --input input/bad.json --policy policies --name cve::allow

#-----------------------------------------------------------------------------
INPUT_DIR=./input
DATA_DIR=./data
IMAGE_REF=quay.io/redhat-appstudio/ec-golden-image:4516c7873cbc786647b93bbb1bdcffec9f8da5e6

# Download an image's manifest.json file
MANIFEST_FILE=$(DATA_DIR)/manifest.json
fetch-manifest:
	@mkdir -p $(DATA_DIR)
	@skopeo inspect --raw docker://$(IMAGE_REF) > $(MANIFEST_FILE)
	@echo Created $(MANIFEST_FILE)

# Download attestations (using skopeo not cosign)
ATT_FILE=$(INPUT_DIR)/attestation.json
fetch-att: fetch-manifest
# Hackery alert: The script gets all the attestations and outputs them
# one per line, but for now I just want to work with one of them.
	@bin/fetch-attestations.sh $(IMAGE_REF) | tail -1 | jq > $(ATT_FILE)
	@echo Created $(ATT_FILE)

# Note: This doesn't work currently
verify-att:
	swio eval -i $(ATT_FILE) -d $(DATA_DIR) -p policies/wip/intoto-envelope.dog -n intoto-envelope::good -v

#-----------------------------------------------------------------------------
# Browse releases at https://github.com/seedwing-io/seedwing-policy/releases

SWIO_RELEASES=https://api.github.com/repos/seedwing-io/seedwing-policy/releases
SWIO_FILE=swio-linux-amd64
ifndef SWIO_VERSION
	SWIO_VERSION=$(shell curl -sL $(SWIO_RELEASES) | jq -r '.[].name' | head -1)
endif
SWIO_DOWNLOAD=https://github.com/seedwing-io/seedwing-policy/releases/download/v$(SWIO_VERSION)/$(SWIO_FILE)
SWIO_DEST=$(HOME)/bin/swio

install-swio:
	curl -sL $(SWIO_DOWNLOAD) -o $(SWIO_DEST)
	chmod 755 $(SWIO_DEST)
	$(SWIO_DEST) --version
