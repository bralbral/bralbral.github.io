#/bin/bash

helm package ./helm/telegram-feedback-bot --destination ./docs
sudo helm repo index ./docs --url https://bralbral.github.io/helm/