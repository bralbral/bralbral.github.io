#/bin/bash

helm package ./helm/* --destination ./release
sudo helm repo index ./release --url https://bralbral.github.io/release/