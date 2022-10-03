#!/bin/sh -l

DTRACK_URL=$1
DTRACK_KEY=$2
LANGUAGE=$3

echo "Run dependency track action"
./dependency_track.sh DTRACK_URL DTRACK_KEY LANGUAGE