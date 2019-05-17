#!/bin/sh
OLDPATH="$PATH"
WHEREAMI="`pwd`"

# $HYBRIXD/node/scripts/setup  => $HYBRIXD
SCRIPTDIR="`dirname \"$0\"`"
HYBRIXD="`cd \"$SCRIPTDIR/../../..\" && pwd`"

echo "[i] setup node."
sh "$HYBRIXD/node/scripts/npm/setup.sh"
if [ -d "$HYBRIXD/interface" ];then
    echo "[i] setup interface."
    sh "$HYBRIXD/interface/scripts/npm/setup.sh"
fi

if [ -d "$HYBRIXD/deterministic" ];then
    echo "[i] setup determinstic."
    sh "$HYBRIXD/deterministic/scripts/npm/setup.sh"
fi

if [ -d "$HYBRIXD/tui-wallet" ];then
    echo "[i] setup tui-wallet."
    sh "$HYBRIXD/tui-wallet/scripts/npm/setup.sh"
fi

if [ -d "$HYBRIXD/web-wallet" ];then
    echo "[i] setup web-wallet."
    sh "$HYBRIXD/web-wallet/scripts/npm/setup.sh"
fi

if [ -d "$HYBRIXD/cli-wallet" ];then
    echo "[i] setup cli-wallet."
    sh "$HYBRIXD/cli-wallet/scripts/npm/setup.sh"
fi
export PATH="$OLDPATH"
cd "$WHEREAMI"
exit $?
