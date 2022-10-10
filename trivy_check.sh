#!/bin/bash

TRIVY_TRIVY_SCANTYPE=$1
TRIVY_SCANREF=$2
TRIVY_IGNORE=$3
TRIVY_SEVERITY=$4
TRIVY_OUTPUT='trivy-results-config.sarif'
ARGS=""

set -e

if [[ ${TRIVY_IGNORE} == "true" ]]; then
  ARGS="$ARGS --ignore-unfixed"
fi

if [ $TRIVY_SEVERITY ];then
  ARGS="$ARGS --severity $TRIVY_SEVERITY"
fi

echo "Building SARIF report"
trivy --quiet ${TRIVY_SCANTYPE} --format sarif --output ${TRIVY_OUTPUT} ${ARGS} ${TRIVY_SCANREF}

echo "Upload trivy config scan result to Github"

jq '.runs[0].results[] | "\(.level):\(.locations[0].physicalLocation.artifactLocation.uri):\(.locations[0].physicalLocation.region.endLine):\(.locations[0].physicalLocation.region.startColumn): \(.message.text)"' < ${TRIVY_OUTPUT} | sed 's/"//g' |  reviewdog -efm="%t%.%+:%f:%l:%c: %m" -reporter=github-pr-check -fail-on-error
