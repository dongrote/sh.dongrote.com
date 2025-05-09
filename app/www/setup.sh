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

_wget_stdout() {
    which wget >/dev/null 2>&1
    if [ $? -eq 0 ] ; then
        wget -qO- "$1"
        return $?
    else
        which curl >/dev/null 2>&1
        if [ $? -eq 0 ] ; then
            curl -so- "$1"
            return $?
        fi
    fi
}

arch_package_map() {
    case "$1" in
        "build-essential") echo -n "base-devel" ;;
        *) echo -n "$1" ;;
    esac
}

install_arch_package() {
    for pkg in $@; do
        output=$(_sudo pacman -S --noconfirm $(arch_package_map $pkg) 2>&1 >/dev/null)
        status=$?
        if [ $status -ne 0 ] ; then
            error "Error installing $pkg"
            echo "$output"
            return $status
        fi
    done
}

azurelinux_package_map() {
    case "$1" in
        "docker") echo -n "moby-engine moby-cli ca-certificates docker-compose" ;;
        *) echo -n "$1" ;;
    esac
}

install_azurelinux_package() {
    for pkg in $@; do
        output=$(_sudo tdnf install -y $pkg 2>&1 >/dev/null)
        status=$?
        if [ $status -ne 0 ] ; then
            error "Error installing $pkg"
            echo "$output"
            return $status
        fi
    done
}

debian_package_map() {
    case "$1" in
        *) echo -n "$1" ;;
    esac
}

install_debian_package() {
    for pkg in $@; do
        output=$(_sudo apt-get install -y $(debian_package_map $pkg) 2>&1)
        status=$?
        if [ $status -ne 0 ] ; then
            error "Error installing $pkg"
            echo "$output"
            return $status
        fi
    done
}

install_package() {
    case "$ID" in
        "arch") install_arch_package $@ ;;
        "debian") install_debian_package $@ ;;
        "azurelinux") install_azurelinux_package $@ ;;
        *)
            error "$ID not supported"
            return 1
            ;;
    esac
    if [ $? -eq 0 ]; then
        success "Installed $@"
        return 0
    fi

    error "Error installing $@"
    return 1
}

install_rust() {
    which cargo >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        info "Rust is already installed."
        return
    fi

    stderr=$(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y 2>&1 >/dev/null)
    if [ $? -eq 0 ] ; then
        success "Installed Rust"
    else
        error "Error installing rust"
        echo "$stderr"
    fi
}

install_dotnet() {
    _wget_stdout https://sh.dongrote.com/dotnet/install.sh | sh
}

install_nodejs() {
    _wget_stdout https://sh.dongrote.com/nodejs/install.sh | sh
}

install_neovim() {
    _wget_stdout https://sh.dongrote.com/neovim/install.sh | sh
}

install_tmux() {
    _wget_stdout https://sh.dongrote.com/tmux/install.sh | sh
}

if [ ! -e /etc/os-release ] ; then
    echo "Expected an /etc/os-release file but did not find one."
    exit 1
fi

info "Reading /etc/os-release"
. /etc/os-release


case "$ID" in
    "arch"|"debian"|"azurelinux")
        success "Recognized operating system as $ID"
        ;;
    *)
        error "$ID is not supported."
        exit 1
        ;;
esac

install_package tmux htop tree build-essential
install_dotnet
install_nodejs
install_rust
install_neovim
install_tmux
