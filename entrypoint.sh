#!/bin/sh -l

DTRACK_ENABLE=$1
DTRACK_URL=$2
DTRACK_KEY=$3
LANGUAGE=$4

CODE_ENABLE=$5
SONAR_PROJECT=$6
SONAR_SOURCES=$7
SONAR_HOST=$8
SONAR_LOGIN=$9
SONAR_EXCLUSION=$10 

CONFIG_ENABLE=$11
SECRETS_ENABLE=$12

REVIEWDOG_GIT_TOKEN=$13
REVIEWDOG_DIR=$14
REVIEWDOG_LVL=$15
REVIEWDOG_REPORTER=$16
REVIEWDOG_FILTER=$17
REVIEWDOG_FAIL=$18
REVIEWDOG_TFSEC_VERSION=$19

DEPCHECK_PROJECT=$20
DEPCHECK_PATH=$21
DEPCHECK_FORMAT=$22


echo "Starting security checks"

if [[ ${DTRACK_ENABLE} == "true" ]]; then
    echo "Run Dependency Track action"
    ./dependency_track.sh DTRACK_URL DTRACK_KEY LANGUAGE
else
    echo "Skip Dependency Track action"
fi

if [[ ${CODE_ENABLE} == "true" ]]; then
    echo "Run code check action"
    ./code.sh SONAR_PROJECT SONAR_SOURCES SONAR_HOST SONAR_LOGIN SONAR_EXCLUSION DEPCHECK_PROJECT DEPCHECK_PATH DEPCHECK_FORMAT

else
    echo "Skip code check action"
fi

if [[ ${CONFIG_ENABLE} == "true" ]]; then
    echo "Run configuration check action"
    ./config.sh REVIEWDOG_GIT_TOKEN REVIEWDOG_DIR REVIEWDOG_LVL REVIEWDOG_REPORTER REVIEWDOG_FILTER REVIEWDOG_FAIL REVIEWDOG_TFSEC_VERSION 
else
    echo "Slip configuration check action"
fi

if [[ ${SECRETS_ENABLE} == "true" ]]; then
    echo "Run secrets leaks action"
    ./secrets_leaks.sh
else
    echo "Skip secrets leaks action"
fi

echo "Security checks finished"
