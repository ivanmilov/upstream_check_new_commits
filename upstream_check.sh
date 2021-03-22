#!/bin/sh

set -e

# fail if upstream_repository is not set in workflow
if [ -z "${INPUT_UPSTREAM_REPOSITORY}" ]; then
    echo 'Workflow missing input value for "upstream_repository"' 1>&2
    echo '      example: "upstream_repository: ivanmilov/upstream_check_new_commits"' 1>&2
    exit 1
else
    UPSTREAM_REPO="https://github.com/${INPUT_UPSTREAM_REPOSITORY}.git"
fi

# ensure target_branch is checked out
if [ $(git branch --show-current) != "${INPUT_TARGET_BRANCH}" ]; then
    git checkout "${INPUT_TARGET_BRANCH}"
    echo 'Target branch ' ${INPUT_TARGET_BRANCH} ' checked out' 1>&1
fi

# set upstream to upstream_repository
git remote add upstream "${UPSTREAM_REPO}"

# check latest commit hashes for a match, exit if nothing to sync
git fetch upstream "${INPUT_UPSTREAM_BRANCH}"
LOCAL_COMMIT_HASH=$(git rev-parse "${INPUT_TARGET_BRANCH}")
UPSTREAM_COMMIT_HASH=$(git rev-parse upstream/"${INPUT_UPSTREAM_BRANCH}")

if [ "${LOCAL_COMMIT_HASH}" = "${UPSTREAM_COMMIT_HASH}" ]; then
    echo "::set-output name=has_new_commits::false" 1>&1
    echo 'No new commits to sync, exiting' 1>&1
    exit 0
fi

echo 'There are new commits to sync' 1>&1
echo "::set-output name=has_new_commits::true" 1>&1
