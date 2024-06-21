#/bin/bash

helm package ./helm/sources/* --destination ./helm/releases
sudo helm repo index ./helm/releases --url https://bralbral.github.io/helm/releases