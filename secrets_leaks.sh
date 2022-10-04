#!/bin/sh -l

FILE_REPORT=report-secrets.json

./gitleaks detect -f sarif --exit-code 0 -r $FILE_REPORT
jq '.runs[0].results[] | "\(.locations[0].physicalLocation.artifactLocation.uri):\(.locations[0].physicalLocation.region.endLine):\(.locations[0].physicalLocation.region.startColumn): \(.message.text)"' < $FILE_REPORT | sed 's/"//g'
jq '.runs[0].results[] | "\(.locations[0].physicalLocation.artifactLocation.uri):\(.locations[0].physicalLocation.region.endLine):\(.locations[0].physicalLocation.region.startColumn): \(.message.text)"' < $FILE_REPORT | sed 's/"//g' |  reviewdog -efm="%f:%l:%c: %m" -reporter=github-pr-check
