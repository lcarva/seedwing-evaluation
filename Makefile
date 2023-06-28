
check-cve-good:
	swio eval --input input/good.json --policy policies --name cve::allow

check-cve-bad:
	swio eval --input input/bad.json --policy policies --name cve::allow

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
