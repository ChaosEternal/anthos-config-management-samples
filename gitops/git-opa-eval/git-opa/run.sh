#!/bin/bash
# $0 envfile policypath query
# data.gitops.premerge.pass=true
# envs accepted
# TARGETHEAD
# SOURCEHEAD
# GITVOL volume mount path
# POLICYPATH relative path pointing to the policies to eval
#

source $1
POLICYPATH=$2
QUERY=$3

cd /workspace
git checkout "$TARGETHEAD"
GIT_EXTERNAL_DIFF="git-opa-eval -d \"$POLICYPATH\" -q \"$QUERY\"" git diff "$TARGETHEAD" "$SOURCEHEAD" &> /tmp/summary
RES=$?
cat /tmp/summary
#glab mr note $_MR_ID -m "$(cat /tmp/summary|tail -c 1024)"
gh pr comment $_MR_ID -F /tmp/summary  
# #if [ $RES -eq 0 ]
# then
#   glab mr merge -d  -r -m "accept" $_MR_ID
# fi
exit $RES
