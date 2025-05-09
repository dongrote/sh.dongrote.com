#!/bin/sh

RED="\033[0;31m"
YELLOW="\033[1;33m"
GREEN="\033[1;32m"
CLR="\033[0m"
NVM_VERSION=v0.40.3

error() {
    echo "${RED}[!] $@${CLR}" >&2
}

info() {
    echo "${YELLOW}[i] $@${CLR}"
}

success() {
    echo "${GREEN}[+] $@${CLR}"
}

_wget_stdout() {
    info "wget $1"
    retval=1
    which wget >/dev/null 2>&1
    if [ $? -eq 0 ] ; then
        wget -qO- "$1"
        retval=$?
    else
        which curl >/dev/null 2>&1
        if [ $? -eq 0 ] ; then
            curl -so- "$1"
            retval=$?
        fi
    fi

    return $retval
}

install_nvm() {
    _wget_stdout https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash

    # setup access to NVM
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    # install latest LTS NodeJS + NPM
    nvm install --lts
}

which nvm >/dev/null 2>&1
if [ $? -eq 0 ] ; then
    info "NVM is already installed"
    exit 0
fi

install_nvm
