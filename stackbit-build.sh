#!/usr/bin/env bash

set -e
set -o pipefail
set -v

initialGitHash=$(git rev-list --max-parents=0 HEAD)
node ./studio-build.js $initialGitHash &

curl -s -X POST https://api.stackbit.com/project/5f6b4b898c45e90015c9c342/webhook/build/pull > /dev/null
npx @stackbit/stackbit-pull --stackbit-pull-api-url=https://api.stackbit.com/pull/5f6b4b898c45e90015c9c342

curl -s -X POST https://api.stackbit.com/project/5f6b4b898c45e90015c9c342/webhook/build/ssgbuild > /dev/null
gatsby build

# wait for studio-build.js
wait

curl -s -X POST https://api.stackbit.com/project/5f6b4b898c45e90015c9c342/webhook/build/publish > /dev/null
echo "stackbit-build.sh: finished build"
