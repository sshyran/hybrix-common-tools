#!/bin/sh
OLDPATH="$PATH"
WHEREAMI="`pwd`"
export PATH="$WHEREAMI/node_binaries/bin:$PATH"
NODEINST="`which node`"
UGLIFY=node_modules/uglify-es/bin/uglifyjs
CSSMIN=node_modules/cssmin/bin/cssmin

# $HYBRIXD/node/scripts/npm  => $HYBRIXD
SCRIPTDIR="`dirname \"$0\"`"
HYBRIXD="`cd \"$SCRIPTDIR/../../..\" && pwd`"

NODE="$HYBRIXD/node"

echo "SCRIPTDIR: "$SCRIPTDIR


if [ "`uname`" = "Darwin" ]; then
    SYSTEM="darwin-x64"
elif [ "`uname -m`" = "i386" ] || [ "`uname -m`" = "i686" ]; then
    SYSTEM="x86"
elif [ "`uname -m`" = "x86_64" ]; then
    SYSTEM="x86_64"
else
    echo "[!] Unknown Architecture (or incomplete implementation)"
    exit 1;
fi

GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

checkGit(){
    branch_name=$(git symbolic-ref -q HEAD)
    branch_name=${branch_name##refs/heads/}
    branch_name=${branch_name:-HEAD}
    echo " [.] Current branch: $branch_name"

    git remote update > /dev/null
    UPSTREAM=${1:-'@{u}'}
    LOCAL=$(git rev-parse @{u})
    REMOTE=$(git rev-parse "$UPSTREAM")
    BASE=$(git merge-base @{u} "$UPSTREAM")

    if [ "$LOCAL" = "$REMOTE" ]; then
        echo "  [.] Up-to-date"
    elif [ "$LOCAL" = "$BASE" ]; then
        echo "$RED  [.] Need to pull$RESET"
    elif [ "$REMOTE" = "$BASE" ]; then
        echo "$GREEN  [.] Need to push$RESET"
    else
        echo "$RED  [.] Diverged$RESET"
    fi
}


echo "[.] Validate hybrixd/node."
if [ -d "$HYBRIXD/node" ]; then
    echo " [.] hybrixd/node found."

    if [ -L "$HYBRIXD/node/common" ]; then
        echo " [.] hybrixd/node/common found."
        if [ "$(readlink $HYBRIXD/node/common)" = "$HYBRIXD/common" ]; then
            echo " [.] hybrixd/node/common linked correctly."
        else
            echo "$RED [!] hybrixd/node/common linked incorrectly."
            echo "     Expected: $HYBRIXD/common"
            echo "     Found:    $(readlink $HYBRIXD/node/common)$RESET"
        fi
    else
        echo " [!] hybrixd/node/common not linked."
    fi

    if [ -L "$HYBRIXD/node/node_binaries" ]; then
        echo " [.] hybrixd/node/node_binaries found."
        if [ "$(readlink $HYBRIXD/node/node_binaries)" = "$HYBRIXD/nodejs/$SYSTEM" ]; then
            echo " [.] hybrixd/node/node_binaries linked correctly."
        else
            echo "$RED [!] hybrixd/node/node_binaries linked incorrectly."
            echo "     Expected: $HYBRIXD/nodejs/$SYSTEM"
            echo "     Found:    $(readlink $HYBRIXD/node/node_binaries)$RESET"
        fi
    else
        echo "$RED [!] hybrixd/node/node_binaries not linked.$RESET"
    fi

    #TODO interface dist
    #TODO determinstic dist
    #TODO web-wallet dist

    #TODO check if up to date


    cd "$HYBRIXD/node/"
    checkGit


else
    echo " [!] hybrixd/node not found."
fi


echo "[.] Validate hybrixd/web-wallet."
if [ -d "$HYBRIXD/web-wallet" ]; then
    echo " [.] hybrixd/web-wallet found."

    if [ -L "$HYBRIXD/web-wallet/common" ]; then
        echo " [.] hybrixd/web-wallet/common found."
        if [ "$(readlink $HYBRIXD/web-wallet/common)" = "$HYBRIXD/common" ]; then
            echo " [.] hybrixd/web-wallet/common linked correctly."
        else
            echo "$RED [!] hybrixd/web-wallet/common linked incorrectly."
            echo "     Expected: $HYBRIXD/common"
            echo "     Found:    $(readlink $HYBRIXD/web-wallet/common)$RESET"
        fi
    else
        echo "$RED [!] hybrixd/web-wallet/common not linked (Known Issue).$RESET"
    fi

    if [ -L "$HYBRIXD/web-wallet/interface" ]; then
        echo " [.] hybrixd/web-wallet/interface found."
        if [ "$(readlink $HYBRIXD/web-wallet/interface)" = "$HYBRIXD/interface/dist" ]; then
            echo " [.] hybrixd/web-wallet/interface linked correctly."
        else
            echo "$RED [!] hybrixd/web-wallet/interface linked incorrectly."
            echo "     Expected: $HYBRIXD/interface/dist"
            echo "     Found:    $(readlink $HYBRIXD/web-wallet/interface)$RESET"
        fi
    else
        echo "$RED [!] hybrixd/web-wallet/interface not linked.$RESET"
    fi

    if [ -L "$HYBRIXD/web-wallet/node_binaries" ]; then
        echo " [.] hybrixd/web-wallet/node_binaries found."
        if [ "$(readlink $HYBRIXD/web-wallet/node_binaries)" = "$HYBRIXD/nodejs/$SYSTEM" ]; then
            echo " [.] hybrixd/web-wallet/node_binaries linked correctly."
        else
            echo "$RED [!] hybrixd/web-wallet/node_binaries linked incorrectly."
            echo "     Expected: $HYBRIXD/nodejs/$SYSTEM"
            echo "     Found:    $(readlink $HYBRIXD/web-wallet/node_binaries)$RESET"
        fi
    else
        echo "$RED [!] hybrixd/web-wallet/node_binaries not linked (Known Issue).$RESET"
    fi

    cd "$HYBRIXD/web-wallet/"
    checkGit
else
    echo " [.] hybrixd/web-wallet not found."
fi


echo "[.] Validate hybrixd/tui-wallet."
if [ -d "$HYBRIXD/tui-wallet" ]; then
    echo " [.] hybrixd/tui-wallet found."

    if [ -L "$HYBRIXD/tui-wallet/common" ]; then
        echo " [.] hybrixd/tui-wallet/common found."
        if [ "$(readlink $HYBRIXD/tui-wallet/common)" = "$HYBRIXD/common" ]; then
            echo " [.] hybrixd/tui-wallet/common linked correctly."
        else
            echo "$RED [!] hybrixd/tui-wallet/common linked incorrectly."
            echo "     Expected: $HYBRIXD/common"
            echo "     Found:    $(readlink $HYBRIXD/tui-wallet/common)$RESET"
        fi
    else
        echo "$RED [!] hybrixd/tui-wallet/common not linked.$RESET"
    fi

    if [ -L "$HYBRIXD/tui-wallet/interface" ]; then
        echo " [.] hybrixd/tui-wallet/interface found."
        if [ "$(readlink $HYBRIXD/tui-wallet/interface)" = "$HYBRIXD/interface/dist" ]; then
            echo " [.] hybrixd/tui-wallet/interface linked correctly."
        else
            echo "$RED [!] hybrixd/tui-wallet/interface linked incorrectly."
            echo "     Expected: $HYBRIXD/interface/dist"
            echo "     Found:    $(readlink $HYBRIXD/tui-wallet/interface)$RESET"
        fi
    else
        echo "$RED [!] hybrixd/tui-wallet/interface not linked.$RESET"
    fi

    if [ -L "$HYBRIXD/tui-wallet/node_binaries" ]; then
        echo " [.] hybrixd/tui-wallet/node_binaries found."
        if [ "$(readlink $HYBRIXD/tui-wallet/node_binaries)" = "$HYBRIXD/nodejs/$SYSTEM" ]; then
            echo " [.] hybrixd/tui-wallet/node_binaries linked correctly"
        else
            echo "$RED [!] hybrixd/tui-wallet/node_binaries linked incorrectly."
            echo "     Expected: $HYBRIXD/nodejs/$SYSTEM"
            echo "     Found:    $(readlink $HYBRIXD/tui-wallet/node_binaries)$RESET"
        fi
    else
        echo "$RED [!] hybrixd/tui-wallet/node_binaries not linked.$RESET"
    fi

    cd "$HYBRIXD/tui-wallet/"
    checkGit

else
    echo " [.] hybrixd/tui-wallet not found."
fi

echo "[.] Validate hybrixd/cli-wallet."
if [ -d "$HYBRIXD/cli-wallet" ]; then
    echo " [.] hybrixd/cli-wallet found."

    if [ -L "$HYBRIXD/cli-wallet/common" ]; then
        echo " [.] hybrixd/cli-wallet/common found."
        if [ "$(readlink $HYBRIXD/cli-wallet/common)" = "$HYBRIXD/common" ]; then
            echo " [.] hybrixd/cli-wallet/common linked correctly."
        else
            echo "$RED [!] hybrixd/cli-wallet/common linked incorrectly."
            echo "     Expected: $HYBRIXD/common"
            echo "     Found:    $(readlink $HYBRIXD/cli-wallet/common)$RESET"
        fi
    else
        echo "$RED [!] hybrixd/cli-wallet/common not linked.$RESET"
    fi

    if [ -L "$HYBRIXD/cli-wallet/interface" ]; then
        echo " [.] hybrixd/cli-wallet/interface found."
        if [ "$(readlink $HYBRIXD/cli-wallet/interface)" = "$HYBRIXD/interface/dist" ]; then
            echo " [.] hybrixd/cli-wallet/interface linked correctly."
        else
            echo "$RED [!] hybrixd/cli-wallet/interface linked incorrectly."
            echo "     Expected: $HYBRIXD/interface/dist"
            echo "     Found:    $(readlink $HYBRIXD/cli-wallet/interface)$RESET"
        fi
    else
        echo "$RED [!] hybrixd/cli-wallet/interface not linked.$RESET"
    fi

    if [ -L "$HYBRIXD/cli-wallet/node_binaries" ]; then
        echo " [.] hybrixd/cli-wallet/node_binaries found."
        if [ "$(readlink $HYBRIXD/cli-wallet/node_binaries)" = "$HYBRIXD/nodejs/$SYSTEM" ]; then
            echo " [.] hybrixd/cli-wallet/node_binaries linked correctly."
        else
            echo "$RED [!] hybrixd/cli-wallet/node_binaries linked incorrectly."
            echo "     Expected: $HYBRIXD/nodejs/$SYSTEM"
            echo "     Found:    $(readlink $HYBRIXD/cli-wallet/node_binaries)$RESET"
        fi
    else
        echo "$RED [!] hybrixd/cli-wallet/node_binaries not linked.$RESET"
    fi

    cd "$HYBRIXD/cli-wallet/"
    checkGit

else
    echo " [.] hybrixd/cli-wallet not found."
fi


echo "[.] Validate hybrixd/deterministic."
if [ -d "$HYBRIXD/deterministic" ]; then
    echo " [.] hybrixd/deterministic found."

    if [ -L "$HYBRIXD/deterministic/common" ]; then
        echo " [.] hybrixd/deterministic/common found."
        if [ "$(readlink $HYBRIXD/deterministic/common)" = "$HYBRIXD/common" ]; then
            echo " [.] hybrixd/deterministic/common linked correctly."
        else
            echo "RED [!] hybrixd/deterministic/common linked incorrectly."
            echo "     Expected: $HYBRIXD/common"
            echo "     Found:    $(readlink $HYBRIXD/deterministic/common)$RESET"
        fi
    else
        echo "$RED [!] hybrixd/deterministic/common not linked.$RESET"
    fi

    if [ -L "$HYBRIXD/deterministic/interface" ]; then
        echo " [.] hybrixd/deterministic/interface found."
        if [ "$(readlink $HYBRIXD/deterministic/interface)" = "$HYBRIXD/interface/dist" ]; then
            echo " [.] hybrixd/deterministic/interface linked correctly."
        else
            echo "$RED [!] hybrixd/deterministic/interface linked incorrectly."
            echo "     Expected: $HYBRIXD/interface/dist"
            echo "     Found:    $(readlink $HYBRIXD/deterministic/interface)$RESET"
        fi
    else
        echo "$RED [!] hybrixd/deterministic/interface not linked.$RESET"
    fi

    if [ -L "$HYBRIXD/deterministic/node_binaries" ]; then
        echo " [.] hybrixd/deterministic/node_binaries found."
        if [ "$(readlink $HYBRIXD/deterministic/node_binaries)" = "$HYBRIXD/nodejs/$SYSTEM" ]; then
            echo " [.] hybrixd/deterministic/node_binaries linked correctly."
        else
            echo "$RED [!] hybrixd/deterministic/node_binaries linked incorrectly."
            echo "     Expected: $HYBRIXD/nodejs/$SYSTEM"
            echo "     Found:    $(readlink $HYBRIXD/deterministic/node_binaries)$RESET"
        fi
    else
        echo "$RED [!] hybrixd/deterministic/node_binaries not linked.$RESET"
    fi

    cd "$HYBRIXD/deterministic/"
    checkGit

else
    echo " [.] hybrixd/deterministic not found."
fi


echo "[.] Validate hybrixd/interface."
if [ -d "$HYBRIXD/interface" ]; then
    echo " [.] hybrixd/interface found."

    if [ -L "$HYBRIXD/interface/common" ]; then
        echo " [.] hybrixd/interface/common found."
        if [ "$(readlink $HYBRIXD/interface/common)" = "$HYBRIXD/common" ]; then
            echo " [.] hybrixd/interface/common linked correctly."
        else
            echo "$RED [!] hybrixd/interface/common linked incorrectly."
            echo "     Expected: $HYBRIXD/common"
            echo "     Found:    $(readlink $HYBRIXD/interface/common)$RESET"
        fi
    else
        echo "$RED [!] hybrixd/interface/common not linked.$RESET"
    fi

    if [ -L "$HYBRIXD/interface/node_binaries" ]; then
        echo " [.] hybrixd/interface/node_binaries found."
        if [ "$(readlink $HYBRIXD/interface/node_binaries)" = "$HYBRIXD/nodejs/$SYSTEM" ]; then
            echo " [.] hybrixd/interface/node_binaries linked correctly."
        else
            echo "$RED [!] hybrixd/interface/node_binaries linked incorrectly."
            echo "     Expected: $HYBRIXD/nodejs/$SYSTEM"
            echo "     Found:    $(readlink $HYBRIXD/interface/node_binaries)$RESET"
        fi
    else
        echo "$RED [!] hybrixd/interface/node_binaries not linked.$RESET"
    fi

    cd "$HYBRIXD/interface/"
    checkGit

else
    echo " [.] hybrixd/interface not found."
fi

echo "[.] Validate hybrixd/common."
if [ -d "$HYBRIXD/common" ]; then
    echo " [.] hybrixd/common found."
    cd "$HYBRIXD/common"
    checkGit

    #TODO check if up to date
else
    echo " [!] hybrixd/common not found."
fi

export PATH="$OLDPATH"
cd "$WHEREAMI"
