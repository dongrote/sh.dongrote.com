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
    info "wget $1"
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

get_system() {
    . /etc/os-release

    echo "$ID"
}

arch_install() {
    _sudo pacman -S --noconfirm dotnet-sdk-8.0
}

azurelinux_install() {
    _sudo tdnf install -y dotnet-sdk-8.0 dotnet-sdk-9.0
}

debian_install() {
    _wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb packages-microsoft-prod.deb
    _sudo dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb

    _sudo apt-get update && \
        _sudo apt-get install -y dotnet-sdk-8.0 dotnet-sdk-9.0
}

install_dotnet() {
    SYSTEM=$(get_system)
    case $SYSTEM in
        "arch") arch_install ;;
        "azurelinux") azurelinux_install ;;
        "debian") debian_install ;;
        *) error "Unsupported $SYSTEM" ;;
    esac
}

install_dotnet
