#!/bin/bash

TRIVY_SCANREF=$1
TRIVY_SEVERITY=$2
TRIVY_OUTPUT='trivy-results-config.sarif'
ARGS=""

set -e

if [ $TRIVY_SEVERITY ];then
  ARGS="$ARGS --severity $TRIVY_SEVERITY"
fi

echo "Building SARIF config report"
trivy --quiet config --format sarif --output ${TRIVY_OUTPUT} ${ARGS} ${TRIVY_SCANREF}

echo "Upload trivy config scan result to Github"

jq '.runs[0].results[] | "\(.level):\(.locations[0].physicalLocation.artifactLocation.uri):\(.locations[0].physicalLocation.region.endLine):\(.locations[0].physicalLocation.region.startColumn): \(.message.text)"' < ${TRIVY_OUTPUT} | sed 's/"//g' |  reviewdog -efm="%t%.%+:%f:%l:%c: %m" -reporter=github-pr-check -fail-on-error
