#!/bin/bash

REVIEWDOG_GIT_TOKEN=$1
REVIEWDOG_DIR=$2
REVIEWDOG_LVL=$3
REVIEWDOG_REPORTER=$4
REVIEWDOG_FAIL=$5

TRIVY_CONFIG_SCANREF=$6
TRIVY_CONFIG_SEVERITY=$7

TRIVY_REPO_SCANREF=$8
TRIVY_REPO_IGNORE=$9
TRIVY_REPO_SEVERITY=$10
TRIVY_REPO_VULN=$11
TRIVY_TIMEOUT=$12

echo "Run Tfsec"
./tsec_check.sh ${REVIEWDOG_GIT_TOKEN} ${REVIEWDOG_DIR} ${REVIEWDOG_LVL} ${REVIEWDOG_REPORTER} ${REVIEWDOG_FAIL}

echo "Run Trivy for config"
./trivy_config.sh ${TRIVY_CONFIG_SCANREF} ${TRIVY_CONFIG_SEVERITY} ${TRIVY_TIMEOUT}

echo "Run Trivy for repository"
./trivy_repo.sh  ${TRIVY_REPO_SCANREF} ${TRIVY_REPO_IGNORE} ${TRIVY_REPO_SEVERITY} ${TRIVY_REPO_VULN} ${TRIVY_TIMEOUT}