#!/bin/sh

RED="\033[0;31m"
YELLOW="\033[1;33m"
GREEN="\033[1;32m"
CLR="\033[0m"

error() {
    echo "${RED}[!] $@${CLR}" >&2
}

info() {
    echo "${YELLOW}[i] $@${CLR}"
}

success() {
    echo "${GREEN}[+] $@${CLR}"
}

_sudo() {
    if [ $(id -u) -ne 0 ] ; then
        sudo $@
    else
        $@
    fi
}

_wget() {
    info "wget $1"
    retval=1
    which wget 2>&1 >/dev/null
    if [ $? -eq 0 ] ; then
        wget -qO "$2" "$1"
        retval=$?
    else
        which curl 2>&1 >/dev/null
        if [ $? -eq 0 ] ; then
            curl -so "$2" "$1"
            retval=$?
        fi
    fi

    return $retval
}

install_tmux() {
    if [ ! -e /etc/os-release ] ; then
        echo "Expected an /etc/os-release file but did not find one."
        exit 1
    fi

    info "Reading /etc/os-release"
    . /etc/os-release

    case "$ID" in
        "debian")
            _sudo apt-get install -y tmux
            ;;
        "arch")
            _sudo pacman -Sy tmux
            ;;
        "azurelinux")
            _sudo tdnf install -y tmux
            ;;
        *)
            error "$ID is not supported."
            exit 1
            ;;
    esac
    success "Installed tmux"
}

install_tmux

rm -rf "$HOME/.tmux"
rm -rf "$HOME/.config/tmux"

mkdir -p "$HOME/.tmux/plugins"
mkdir -p "$HOME/.config/tmux/plugins/catppuccin"

git clone -b v2.1.3 \
    https://github.com/catppuccin/tmux.git \
    "$HOME/.config/tmux/plugins/catppuccin/tmux" 2>&1 >/dev/null

git clone https://github.com/tmux-plugins/tpm \
    "$HOME/.tmux/plugins/tpm" 2>&1 /dev/null

_wget https://sh.dongrote.com/tmux/tmux.conf "$HOME/.tmux.conf"
