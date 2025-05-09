#!/bin/sh

error() {
    echo "[!] $@" >&2
}

info() {
    echo "[i] $@"
}

success() {
    echo "[+] $@"
}

_sudo() {
    if [ $(id -u) -ne 0 ] ; then
        sudo $@
    else
        $@
    fi
}

_wget() {
    retval=1
    which wget >/dev/null 2>&1
    if [ $? -eq 0 ] ; then
        wget -qO "$2" "$1"
        retval=$?
    else
        which curl >/dev/null 2>&1
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

    info "Installing tmux"
    . /etc/os-release

    case "$ID" in
        "debian")
            _sudo apt-get install -y tmux
            ;;
        "arch")
            _sudo pacman -S --noconfirm tmux
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

info "cloning catppuccin"
git clone -b v2.1.3 \
    https://github.com/catppuccin/tmux.git \
    "$HOME/.config/tmux/plugins/catppuccin/tmux" >/dev/null 2>&1

info "cloning tmux-plugins/tpm"
git clone https://github.com/tmux-plugins/tpm \
    "$HOME/.tmux/plugins/tpm" >/dev/null 2>&1

info "fetching .tmux.conf"
_wget https://sh.dongrote.com/tmux/tmux.conf "$HOME/.tmux.conf"
