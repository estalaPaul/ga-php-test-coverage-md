#!/bin/bash

cat $GITHUB_WORKSPACE
phpunit -c "${GITHUB_WORKSPACE}/phpunit.xml" --coverage-html coverage.html $GITHUB_WORKSPACE

MARKDOWN=$(pandoc -f html -t coverage.html)
NUMBER=$(jq --raw-output .pull_request.number "$GITHUB_EVENT_PATH")

curl -sSL \
  -H "Authorization: token ${GITHUB_TOKEN}" \
  -H "Accept: application/vnd.github.v3+json" \
  -X POST \
  -H "Content-Type: application/json" \
  -d "{\"body\":[\"$markdown\"]}" \
  "https://api.github.com/repos/${GITHUB_REPOSITORY}/issues/${NUMBER}/comments"
