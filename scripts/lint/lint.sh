#!/bin/sh
OLDPATH="$PATH"
WHEREAMI="`pwd`"

# $HYBRIXD/node/scripts/npm  => $HYBRIXD
SCRIPTDIR="`dirname \"$0\"`"
HYBRIXD="`cd \"$SCRIPTDIR/../../..\" && pwd`"

export PATH="$HYBRIXD/node/node_binaries/bin:$PATH"

# Move to provided directory
if [ -z "$2" ]; then
    cd "$HYBRIXD/$1"
elif [ -z "$1" ]; then
    cd "$WHEREAMI"
else
    cd "$1"
fi

echo "[i] Running ShellCheck"
sh "$SCRIPTDIR/shellcheck.sh" "$1" "$2"

echo "[i] Running ESlint"
sh "$SCRIPTDIR/eslint.sh" "$1" "$2"

echo "[i] Running JSONlint"
sh "$SCRIPTDIR/jsonlint.sh" "$1" "$2"

cd "$WHEREAMI"
export PATH="$OLDPATH"

exit $?
