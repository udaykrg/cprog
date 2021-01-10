#!/bin/bash
#

# Copies certain kinds of known files and directories from a given Jenkins master directory
# into a git repo, removing any old ones, adds 'em, commits 'em, pushes 'em.
# 
set -ex

if [ $# -ne 2 ]; then
  echo usage: $0 root_dir jenkins_master
  exit 1
fi

ROOT_DIR=$1
JENKINS_MASTER=$2

ORIG_DIR=$PWD

mkdir -p $ROOT_DIR

cd $ROOT_DIR

rm -rf *-jenkins-git

git clone git@GIT_SERVER:${JENKINS_MASTER}-jenkins-git.git

cd $ROOT_DIR/${JENKINS_MASTER}-jenkins-git

# rsync-no-vanished is just a wrapper making sure rsync doesn't fail on vanished files during the process.
# Jenkins master is in a subdirectory of /var/lib/jenkins.
$ORIG_DIR/rsync-no-vanished -av --delete --exclude="jobConfigHistory" \
    --exclude="war" \
    --exclude="config-history" \
    --exclude=".hudson" \
    --exclude=".ivy2" \
    --exclude=".m2" \
    --exclude="lost+found" \
    --include="*/" \
    --include="*config.xml" \
    --include="users/*" \
    --include="*.hpi" \
    --include="*.jpi" \
    --include="*pinned" \
    --include="*disabled" \
    --exclude="*" \
    --prune-empty-dirs /var/lib/jenkins/${JENKINS_MASTER}/ .

[ -d /var/lib/jenkins/${JENKINS_MASTER}/scriptler ] && $ORIG_DIR/rsync-no-vanished -av --delete /var/lib/jenkins/${JENKINS_MASTER}/scriptler .
[ -d /var/lib/jenkins/${JENKINS_MASTER}/secrets ] && $ORIG_DIR/rsync-no-vanished -av --delete /var/lib/jenkins/${JENKINS_MASTER}/secrets .
cp /var/lib/jenkins/${JENKINS_MASTER}/*.xml .
cp /var/lib/jenkins/${JENKINS_MASTER}/*.key .

git add -A

git commit -m "Jenkins ${JENKINS_MASTER} config backup for $(date)"

git push origin master
