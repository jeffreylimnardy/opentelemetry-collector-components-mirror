#!/bin/sh

set -e
set -o pipefail

# This script checks if the GitHub milestone is closed before release.

GH_REPO="$1"

MILESTONE="$2"
echo "/repos/'${GH_REPO}'/milestones?state=all"

state=$(gh api \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "/repos/$GH_REPO/milestones?state=all" --paginate | jq -r '.[]|select(.title=='\""$MILESTONE"\"').state')

if [ -z "$state" ] || [ "$state" != "closed" ]; then
    echo "::error::Milestone for release '${MILESTONE}' does not exist or is not closed"
    exit 1
fi

