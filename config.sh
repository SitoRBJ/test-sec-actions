#!/bin/sh -l

echo "Run Tfsec"
tfsec .

echo "Run Trivy"


echo "Upload trivy config scan result to Github"

jq '.runs[0].results[] | "\(.level):\(.locations[0].physicalLocation.artifactLocation.uri):\(.locations[0].physicalLocation.region.endLine):\(.locations[0].physicalLocation.region.startColumn): \(.message.text)"' < trivy-results-config.sarif | sed 's/"//g' |  reviewdog -efm="%t%.%+:%f:%l:%c: %m" -reporter=github-pr-check -fail-on-error