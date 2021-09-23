#!/bin/env bash

echo "creating Makefile"
cat <<EOT >Makefile
.ONESHELL:

build:
	touch index.md
	if [ ! -d ./node_modules ]; then npm install; fi
	pandoc -s --self-contained \\
		-c node_modules/milligram/dist/milligram.min.css \\
		index.md -o index.html

clean:
	rm index.html || true 
	rm -rf node_modules  || true

wait:
	while true; do inotifywait -e modify index.md; make build; done
EOT

echo "create package.json"
cat <<EOT >package.json
{
  "dependencies": {
    "milligram": "^1.4.1"
  }
}
EOT

echo ""
echo "please install pandoc, nodejs and inotifywait before proceeding"
echo ""
echo "start editing index.md"
echo ""
echo "* make: build index.html"
echo "* make clean: delete build artefacts"
echo "* make wait: build index.html when index.md is saved"
