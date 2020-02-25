#!/bin/sh
OLDPATH="$PATH"
WHEREAMI="`pwd`"

# $HYBRIXD/node/scripts/setup  => $HYBRIXD
SCRIPTDIR="`dirname \"$0\"`"
HYBRIXD="`cd \"$SCRIPTDIR/../../..\" && pwd`"

if [ -e "$HYBRIXD/hybrixd" ] || [ "$1" = "public" ] ; then
    ENVIRONMENT="public"
    echo "[i] Environment is public..."
elif [ -e "$HYBRIXD/node" ] || [ "$1" = "dev" ] ; then
    ENVIRONMENT="dev"
    echo "[i] Environment is development..."
else
    echo "[i] Could not determine environment"
    read -p " [?] Please enter environment [dev/public] " ENVIRONMENT
fi

if [ "$ENVIRONMENT" = "public" ]; then
    NODE="$HYBRIXD/hybrixd"
    URL_NODE="https://github.com/hybrix-io/hybrixd.git"
elif [ "$ENVIRONMENT" = "dev" ]; then
    URL_NODE="https://www.gitlab.com/hybrix/hybrixd/node.git"
    NODE="$HYBRIXD/node"
else
    echo "[!] Illegal environment \"$ENVIRONMENT\". Expected \"dev\" or \"public\""
    export PATH="$OLDPATH"
    cd "$WHEREAMI"
    exit 1
fi

if [ ! -e "$NODE" ];then
    echo "[i] Could not find node files"
    cd "$HYBRIXD"
    echo "[i] Clone node files"
    git clone "$URL_NODE"
    ln -sf "hybrixd" "node"
fi

echo "[i] setup node."
sh "$NODE/scripts/npm/setup.sh"

if [ -d "$HYBRIXD/hybrix-jslib" ];then
    echo "[i] setup interface."
    sh "$HYBRIXD/hybrix-jslib/scripts/npm/setup.sh"
elif [ -d "$HYBRIXD/interface" ];then
    echo "[i] setup interface."
    sh "$HYBRIXD/interface/scripts/npm/setup.sh"
fi

if [ -d "$HYBRIXD/deterministic" ];then
    echo "[i] setup determinstic."
    sh "$HYBRIXD/deterministic/scripts/npm/setup.sh" "$ENVIRONMENT"
fi

if [ -d "$HYBRIXD/tui-wallet" ];then
    echo "[i] setup tui-wallet."
    sh "$HYBRIXD/tui-wallet/scripts/npm/setup.sh" "$ENVIRONMENT"
fi

if [ -d "$HYBRIXD/web-wallet" ];then
    echo "[i] setup web-wallet."
    sh "$HYBRIXD/web-wallet/scripts/npm/setup.sh" "$ENVIRONMENT"
fi

if [ -d "$HYBRIXD/cli-wallet" ];then
    echo "[i] setup cli-wallet."
    sh "$HYBRIXD/cli-wallet/scripts/npm/setup.sh" "$ENVIRONMENT"
fi
export PATH="$OLDPATH"
cd "$WHEREAMI"
exit $?
