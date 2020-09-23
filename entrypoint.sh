#!/bin/bash

cd $GITHUB_WORKSPACE
composer install

vendor/bin/phpunit -c phpunit.xml --coverage-text coverage.txt

MARKDOWN=$(pandoc -f plain -t gdm coverage.txt)
NUMBER=$(jq --raw-output .pull_request.number "$GITHUB_EVENT_PATH")

curl -sSL \
  -H "Authorization: token ${GITHUB_TOKEN}" \
  -H "Accept: application/vnd.github.v3+json" \
  -X POST \
  -H "Content-Type: application/json" \
  -d "{\"body\":[\"$MARKDOWN\"]}" \
  "https://api.github.com/repos/${GITHUB_REPOSITORY}/issues/${NUMBER}/comments"
