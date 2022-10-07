#!/bin/bash

REVIEWDOG_GIT_TOKEN=$1
REVIEWDOG_DIR=$2
REVIEWDOG_LVL=$3
REVIEWDOG_REPORTER=$4
REVIEWDOG_FILTER=$5
REVIEWDOG_FAIL=$6
REVIEWDOG_TFSEC_VERSION=$7

# Print commands for debugging
if [[ "$RUNNER_DEBUG" = "1" ]]; then
  set -x
fi

# Fail fast on errors, unset variables, and failures in piped commands
set -Eeuo pipefail

cd "${GITHUB_WORKSPACE}/${REVIEWDOG_DIR}" || exit

echo "Print tfsec details ..."
tfsec --version

echo 'Running tfsec with reviewdog ...'
export REVIEWDOG_GITHUB_API_TOKEN="${REVIEWDOG_GIT_TOKEN}"

# Allow failures now, as reviewdog handles them
set +Eeuo pipefail

# shellcheck disable=SC2086
tfsec --format=json ${INPUT_TFSEC_FLAGS:-} . | jq -r -f to-rdjson.jq | reviewdog -f=rdjson -name="tfsec" -reporter="${REVIEWDOG_REPORTER}" -level="${REVIEWDOG_LVL}" -fail-on-error="${REVIEWDOG_FAIL}" -filter-mode="${REVIEWDOG_FILTER}"

tfsec_return="${PIPESTATUS[0]}" reviewdog_return="${PIPESTATUS[2]}" exit_code=$?

echo "set-output name=tfsec-return-code: ${tfsec_return}"
echo "set-output name=reviewdog-return-code: ${reviewdog_return}"

exit "${exit_code}"