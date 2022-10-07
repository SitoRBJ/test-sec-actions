#!/bin/sh -l

SONAR_PROJECT=$1
SONAR_SOURCES=$2
SONAR_HOST=$3
SONAR_LOGIN=$4
SONAR_EXCLUSION=$5


DEPCHECK_PROJECT=$6
DEPCHECK_PATH=$7
DEPCHECK_FORMAT=$8

set -e

echo "Run Dependency check"

dependency-check.sh --project ${DEPCHECK_PROJECT} --scan ${DEPCHECK_PATH} --format ${DEPCHECK_FORMAT} --out '/github/workspace/reports' --noupdate

echo "Run SonarQube"
sonar-scanner \
  -Dsonar.projectKey=$SONAR_PROJECT \
  -Dsonar.sources=$SONAR_SOURCES \
  -Dsonar.host.url=$SONAR_HOST \
  -Dsonar.login=$SONAR_LOGIN \
  -Dsonar.exclusions=$SONAR_EXCLUSION