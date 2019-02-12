#!/bin/sh
# $1 TARGET FOLDER

WHEREAMI=`pwd`
OLDPATH=$PATH

# $HYBRIXD/$COMMON/hooks  => $HYBRIXD
SCRIPTDIR="`dirname \"$0\"`"
HYBRIXD="`cd \"$SCRIPTDIR/../..\" && pwd`"

COMMON="$HYBRIXD/common"

# GIT PRE-PUSH HOOK
echo "[i] Install git pre-push hook..."
cp "$COMMON/hooks/pre-push" "$1/.git/hooks/pre-push"
chmod +x "$1/.git/hooks/pre-push"

# GIT COMMIT-MSG HOOK
echo "[i] Install git commit-msg hook..."
cp "$COMMON/hooks/commit-msg" "$1/.git/hooks/commit-msg"
chmod +x "$1/.git/hooks/commit-msg"

# ES-LINT
echo "[i] Install es lint config..."
cp "$COMMON/hooks/eslintrc.js" "$1/.eslintrc.js"

cd "$WHEREAMI"
export PATH="$OLDPATH"
