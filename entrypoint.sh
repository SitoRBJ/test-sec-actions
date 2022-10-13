#!/bin/sh -l

set -e

while getopts "a:b:c:d:e:f:g:h:i:j:k:l:m:n:o:p:q:r:s:t:u:v:" o; do
   case "${o}" in
       a)
         export DTRACK_ENABLE=${OPTARG}
       ;;
       b)
         export DTRACK_URL=${OPTARG}
       ;;
       c)
         export DTRACK_KEY=${OPTARG}
       ;;
       d)
         export DTRACK_LANGUAGE=${OPTARG}
       ;;
       e)
         export CODE_ENABLE=${OPTARG}
       ;;
       f)
         export SONAR_SOURCES=${OPTARG}
       ;;
       g)
         export SONAR_HOST=${OPTARG}
       ;;
       h)
         export SONAR_LOGIN=${OPTARG}
       ;;
       i)
         export CONFIG_ENABLE=${OPTARG}
       ;;
       j)
         export SECRETS_ENABLE=${OPTARG}
       ;;
       k)
         export REVIEWDOG_GIT_TOKEN=${OPTARG}
       ;;
       l)
         export REVIEWDOG_DIR=${OPTARG}
       ;;
       m)
         export REVIEWDOG_LVL=${OPTARG}
       ;;
       n)
         export REVIEWDOG_REPORTER=${OPTARG}
       ;;
       o)
         export REVIEWDOG_FAIL=${OPTARG}
       ;;
       p)
         export DEPCHECK_PROJECT=${OPTARG}
       ;;
       q)
         export DEPCHECK_PATH=${OPTARG}
       ;;
       r)
         export DEPCHECK_FORMAT=${OPTARG}
       ;;
       s)
         export TRIVY_CONFIG_SCANREF=${OPTARG}
       ;;
       t)
         export TRIVY_CONFIG_SEVERITY=${OPTARG}
       ;;
       u)
         export TRIVY_REPO_SCANREF=${OPTARG}
       ;;
       v)
         export TRIVY_REPO_IGNORE=${OPTARG}
       ;;
       w)
         export TRIVY_REPO_SEVERITY=${OPTARG}
       ;;
       x)
         export TRIVY_REPO_VULN=${OPTARG}
       ;;
  esac
done

echo "Starting security checks"

if [[ ${DTRACK_ENABLE} == "true" ]]; then
    
    DTRACK_ARGS=""

    if [ $DTRACK_URL ];then
        DTRACK_ARGS="$DTRACK_ARGS $DTRACK_URL"
    fi
    if [ $DTRACK_KEY ];then
        DTRACK_ARGS="$DTRACK_ARGS $DTRACK_KEY"
    fi
    if [ $DTRACK_LANGUAGE ];then
        DTRACK_ARGS="$DTRACK_ARGS $DTRACK_LANGUAGE"
    fi

    echo "Run Dependency Track action"
    ./dependency_track.sh $DTRACK_ARGS

else
    echo "Skip Dependency Track action"
fi

if [[ ${CODE_ENABLE} == "true" ]]; then

    CODE_ARGS=""

    if [ $DEPCHECK_PROJECT ];then
        CODE_ARGS="$CODE_ARGS $DEPCHECK_PROJECT"
    fi
    if [ $DEPCHECK_PATH ];then
        CODE_ARGS="$CODE_ARGS $DEPCHECK_PATH"
    fi
    if [ $DEPCHECK_FORMAT ];then
        CODE_ARGS="$CODE_ARGS $DEPCHECK_FORMAT"
    fi
    if [ $SONAR_SOURCES ];then
        CODE_ARGS="$CODE_ARGS $SONAR_SOURCES"
    fi
    if [ $SONAR_HOST ];then
        CODE_ARGS="$CODE_ARGS $SONAR_HOST"
    fi
    if [ $SONAR_LOGIN ];then
        CODE_ARGS="$CODE_ARGS $SONAR_LOGIN"
    fi

    echo "Run code check action"
    ./code.sh $CODE_ARGS

else
    echo "Skip code check action"
fi

if [[ ${CONFIG_ENABLE} == "true" ]]; then
    echo "Run configuration check action"

    REVIEWDOG_ARGS=""

    if [ $REVIEWDOG_GIT_TOKEN ];then
        REVIEWDOG_ARGS="$REVIEWDOG_ARGS $REVIEWDOG_GIT_TOKEN"
    fi
    if [ $REVIEWDOG_DIR ];then
        REVIEWDOG_ARGS=" $REVIEWDOG_DIR"
    fi
    if [ $REVIEWDOG_LVL ];then
        REVIEWDOG_ARGS="$REVIEWDOG_ARGS $REVIEWDOG_LVL"
    fi
    if [ $REVIEWDOG_REPORTER ];then
        REVIEWDOG_ARGS="$REVIEWDOG_ARGS $REVIEWDOG_REPORTER"
    fi
    if [ $REVIEWDOG_FAIL ];then
        REVIEWDOG_ARGS="$REVIEWDOG_ARGS $REVIEWDOG_FAIL"
    fi

    TRIVY_CONFIG_ARGS=""

    if [ $TRIVY_CONFIG_SCANREF ];then
        TRIVY_CONFIG_ARGS="$TRIVY_CONFIG_ARGS $TRIVY_CONFIG_SCANREF"
    fi
    if [ $TRIVY_CONFIG_SEVERITY ];then
        TRIVY_CONFIG_ARGS="$TRIVY_CONFIG_ARGS $TRIVY_CONFIG_SEVERITY"
    fi

    TRIVY_REPO_ARGS=""

    if [ $TRIVY_REPO_SCANREF ];then
        TRIVY_REPO_ARGS="$TRIVY_REPO_ARGS $TRIVY_REPO_SCANREF"
    fi
    if [ $TRIVY_REPO_IGNORE ];then
        TRIVY_REPO_ARGS="$TRIVY_REPO_ARGS $TRIVY_REPO_IGNORE"
    fi
    if [ $TRIVY_REPO_SEVERITY ];then
        TRIVY_REPO_ARGS="$TRIVY_REPO_ARGS $TRIVY_REPO_SEVERITY"
    fi
    if [ $TRIVY_REPO_VULN ];then
        TRIVY_REPO_ARGS="$TRIVY_REPO_ARGS $TRIVY_REPO_VULN"
    fi

    ./config.sh $REVIEWDOG_ARGS $TRIVY_CONFIG_ARGS
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
