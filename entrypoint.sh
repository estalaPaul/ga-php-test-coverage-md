#!/bin/bash

cd $GITHUB_WORKSPACE
composer install

vendor/bin/phpunit --coverage-text=coverage.txt

markdown=$(jq -aRs . <<< cat coverage.txt)
NUMBER=$(jq --raw-output .pull_request.number "$GITHUB_EVENT_PATH")

echo $markdown;

curl -sSL \
  -X POST \
  -H "Authorization: token ${GITHUB_TOKEN}" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/${GITHUB_REPOSITORY}/issues/${NUMBER}/comments" \
  -d "{\"body\":$markdown}"
