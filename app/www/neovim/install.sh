#!/bin/sh

NVIM_CONFIG_DIRECTORY="$HOME/.config/nvim"
NVIM_LUA_DIRECTORY="$NVIM_CONFIG_DIRECTORY/lua"
NVIM_PLUGIN_DIRECTORY="$NVIM_LUA_DIRECTORY/plugins"

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

clean_existing_neovim() {
    info "removing existing neovim files"
    rm -rf "$HOME/.config/nvim"
    rm -rf "$HOME/.local/state/nvim"
    rm -rf "$HOME/.local/share/nvim"
    rm -rf "$HOME/nvim-linux-x86_64"
}

create_neovim_directories() {
    info "creating \$HOME/bin"
    mkdir -p "$HOME/bin"
}

create_home_bin_neovim_symlink() {
    info "creating neovim symlink"
    ln -s "$HOME/nvim-linux-x86_64/bin/nvim" "$HOME/bin/nvim"
}

fetch_neovim_config() {
    info "fetching .config/nvim files"
    mkdir -p "$NVIM_LUA_DIRECTORY"

    _wget "https://sh.dongrote.com/neovim/init.lua" "$NVIM_CONFIG_DIRECTORY/init.lua"

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
    info "fetching neovim plugins"
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

install_neovim() {
    . /etc/os-release
    case "$ID" in
        "arch") _sudo pacman -S --noconfirm neovim ;;
        *)
            info "downloading nightly neovim build"
            NVIM_TARBALL=nvim-linux-x86_64.tar.gz
            _wget "https://github.com/neovim/neovim/releases/download/nightly/$NVIM_TARBALL" "$NVIM_TARBALL" && \
              tar -zxf "$NVIM_TARBALL" -C "$HOME" && \
              rm "$NVIM_TARBALL" && \
              create_home_bin_neovim_symlink
            ;;
    esac
}

clean_existing_neovim
create_neovim_directories

install_neovim
fetch_neovim_config && \
  fetch_neovim_plugins
