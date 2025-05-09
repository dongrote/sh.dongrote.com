#!/bin/sh

RED="\033[0;31m"
YELLOW="\033[1;33m"
GREEN="\033[1;32m"
CLR="\033[0m"

NVIM_CONFIG_DIRECTORY="$HOME/.config/nvim"
NVIM_LUA_DIRECTORY="$NVIM_CONFIG_DIRECTORY/lua"
NVIM_PLUGIN_DIRECTORY="$NVIM_LUA_DIRECTORY/plugins"

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

clean_existing_neovim() {
    rm -rf "$HOME/.config/nvim"
    rm -rf "$HOME/.local/state/nvim"
    rm -rf "$HOME/.local/share/nvim"
    rm -rf "$HOME/nvim-linux-x86_64"
}

create_neovim_directories() {
    mkdir -p "$HOME/bin"
}

create_home_bin_neovim_symlink() {
    ln -s "$HOME/nvim-linux-x86_64/bin/nvim" "$HOME/bin/nvim"
}

fetch_neovim_config() {
    mkdir -p "$NVIM_LUA_DIRECTORY"

    _wget "https://sh.dongrote.com/neovim/init.lua" "$NMVIM_CONFIG_DIRECTORY/init.lua"

    FILES="lazy.lua \
        set.lua \
        remap.lua \
        autocmds.lua"
    for FILE in $FILES
    do
        _wget "https://sh.dongrote.com/neovim/$FILE" "$NVIM_LUA_DIRECTORY/$FILE"
    done
}

fetch_neovim_plugins() {
    mkdir -p "$NVIM_PLUGIN_DIRECTORY"
    PLUGINS="fugitive.lua \
        lsp.lua \
        lualine.lua \
        nvim-tree.lua \
        telescope.lua \
        tokyonight.lua \
        treesitter.lua \
        whichkey.lua"
    for PLUGIN in $PLUGINS
    do
        _wget "https://sh.dongrote.com/neovim/plugins/$PLUGIN" "$NVIM_PLUGIN_DIRECTORY/$PLUGIN"
    done
}

clean_existing_neovim
create_neovim_directories

NVIM_TARBALL=nvim-linux-x86_64.tar.gz
_wget "https://github.com/neovim/neovim/releases/download/nightly/$NVIM_TARBALL" "$NVIM_TARBALL" && \
  tar -zxf "$NVIM_TARBALL" -C "$HOME" && \
  rm "$NVIM_TARBALL" && \
  create_home_bin_neovim_symlink && \
  fetch_neovim_config && \
  fetch_neovim_plugins
