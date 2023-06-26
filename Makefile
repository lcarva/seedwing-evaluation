
check-cve-good:
	swio eval --input input/good.json --policy policies --name cve::allow

check-cve-bad:
	swio eval --input input/bad.json --policy policies --name cve::allow

