#!/bin/bash

cd $GITHUB_WORKSPACE
composer install

vendor/bin/phpunit -c phpunit.xml --coverage-html coverage.html

MARKDOWN=$(pandoc -f html -t markdown coverage.html)
NUMBER=$(jq --raw-output .pull_request.number "$GITHUB_EVENT_PATH")

curl -sSL \
  -H "Authorization: token ${GITHUB_TOKEN}" \
  -H "Accept: application/vnd.github.v3+json" \
  -X POST \
  -H "Content-Type: application/json" \
  -d "{\"body\":[\"$markdown\"]}" \
  "https://api.github.com/repos/${GITHUB_REPOSITORY}/issues/${NUMBER}/comments"
