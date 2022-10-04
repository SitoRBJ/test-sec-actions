#!/bin/sh -l

DTRACK_URL=$1
DTRACK_KEY=$2
LANGUAGE=$3

SONAR_PROJECT=$6
SONAR_SOURCES=$7
SONAR_HOST=$8
SONAR_LOGIN=$9
SONAR_EXCLUSION=$10 

echo "Run Dependency Track action"
./dependency_track.sh DTRACK_URL DTRACK_KEY LANGUAGE

echo "Run SonarQube"
./sonar.sh SONAR_PROJECT SONAR_SOURCES SONAR_HOST SONAR_LOGIN SONAR_EXCLUSION

echo "Run configuration check action"
./config.sh

echo "Run secrets leaks action"
./secrets_leaks.sh

