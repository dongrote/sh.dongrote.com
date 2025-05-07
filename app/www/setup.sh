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

arch_package_map() {
    case "$1" in
        *) echo -n "$1" ;;
    esac
}

install_arch_package() {
    for pkg in $@; do
        output=$(_sudo pacman -S $pkg >/dev/null)
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
        output=$(_sudo tdnf install -y $pkg >/dev/null)
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
    which cargo 2>&1 >/dev/null
    if [ $? -eq 0 ]; then
        info "Rust is already installed."
        return
    fi

    stderr=$(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs 2>&1 | sh -s -- -y 2>&1)
    if [ $? -eq 0 ] ; then
        success "Installed Rust"
    else
        error "Error installing rust"
        echo "$stderr"
    fi
}

configure_tmux() {
  mkdir -p $HOME/.config/tmux/plugins/catppuccin
  if [ -d $HOME/.config/tmux/plugins/catppuccin/tmux ] ; then
    rm -rf $HOME/.config/tmux/plugins/catppuccin/tmux
  fi
  git clone -b v2.1.3 https://github.com/catppuccin/tmux.git $HOME/.config/tmux/plugins/catppuccin/tmux 2>&1 >/dev/null

  mkdir -p $HOME/.tmux/plugins
  if [ -d $HOME/.tmux/plugins/tpm ] ; then
    rm -rf $HOME/.tmux/plugins/tpm
  fi
  git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm 2>&1 >/dev/null
  cat <<EOF >$HOME/.tmux.conf
# rebind prefix
unbind C-b
set -g prefix C-Space
bind C-Space send-prefix

# Bind Ctrl-h, Ctrl-j, Ctrl-k, and Ctrl-l to switch panes
# instead of arrow keys
bind C-h select-pane -L
bind C-j select-pane -D
bind C-k select-pane -U
bind C-l select-pane -R

# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-cpu'

set -g @catppuccin_flavor "mocha"
set -g @catppuccin_window_status_style "basic"
set -g @catppuccin_window_text "#W"
set -g @catppuccin_window_default_text "#W"
set -g @catppuccin_window_current_text "#W"

run ~/.config/tmux/plugins/catppuccin/tmux/catppuccin.tmux

# set vi key schema
setw -g status-keys vi

set -g status-left-length 100
set -g status-right-length 100
set -g status-right "#{E:@catppuccin_status_application}"
set -agF status-right "#{E:@catppuccin_status_cpu}"
set -agF status-right "#{E:@catppuccin_status_date_time}"
set -agF status-right "#{E:@catppuccin_status_host}"

# Initialize TMUX plugin manager *keep this line at the very bottom)

run '~/.tmux/plugins/tpm/tpm'
EOF

success "Configured tmux"
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
install_rust

configure_tmux
