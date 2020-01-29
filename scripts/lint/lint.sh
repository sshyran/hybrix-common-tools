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

EXIT_CODE=0

echo "[i] Running ShellCheck"
if sh "$SCRIPTDIR/shellcheck.sh" "$1" "$2"; then
   echo "[v] ShellCheck succeeded."
else
    echo "[v] ShellCheck failed."
    EXIT_CODE=1
fi

echo "[i] Running ESlint"
if sh "$SCRIPTDIR/eslint.sh" "$1" "$2"; then
   echo "[v] ESlint succeeded."
else
    echo "[v] ESlint failed."
    EXIT_CODE=1
fi

echo "[i] Running JSONlint"
if sh "$SCRIPTDIR/jsonlint.sh" "$1" "$2"; then
   echo "[v] JSONlint succeeded."
else
    echo "[v] JSONlint failed."
    EXIT_CODE=0
fi

cd "$WHEREAMI"
export PATH="$OLDPATH"

exit $EXIT_CODE
