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



IFS=$'\n'
LINTLIST="/tmp/hybrixlint.list"
git diff --stat --cached --name-only master | grep ".sh$" | grep -v "node_"  > $LINTLIST
SHELLCHECK=$(command -v shellcheck)
STAGED_FILES=$(cat "$LINTLIST");

echo "\nPre Push:\n"

if [ -z "$STAGED_FILES" ]; then
    echo "\033[42mNO CHANGES\033[0m\n"
    cd "$WHEREAMI"
    export PATH="$OLDPATH"
    exit 0
fi

PASS=true

echo "\nValidating Shell scripts:\n"

# Check for eslint
if [ ! -f "$SHELLCHECK" ]; then
    echo "\033[41mPlease install ShellCheck https://www.shellcheck.net"
    exit 1
fi

while read -r FILE; do
    if [ -f "$FILE" ]; then
        "$SHELLCHECK" --severity=error "$FILE"

        if [ "$?" -eq 0 ]; then
            echo "\033[32mShellCheck Passed: $FILE\033[0m"
        else
            echo "\033[31mShellCheck Failed: $FILE\033[0m"
            PASS=false
        fi
    else
        echo "ShellCheck Skipped (File removed): $FILE"
    fi
done < "$LINTLIST"

echo "\nJavascript validation completed!\n"

if ! $PASS; then
    echo "\033[41mCOMMIT FAILED:\033[0m Your commit contains files that should pass ShellCheck but do not. Please fix the ShellCheck errors and try again.\n"
    cd "$WHEREAMI"
    export PATH="$OLDPATH"
    exit 1
else
    echo "\033[42mCOMMIT SUCCEEDED\033[0m\n"
fi

cd "$WHEREAMI"
export PATH="$OLDPATH"

exit $?
