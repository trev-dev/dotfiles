export EDITOR="vim"
export SUDO_EDITOR="vim"
# export LOMBOK_JAR="/nix/store/lyqaw25knx09wc7h5gs2r96my1l3ikdx-lombok-1.18.26/share/java/lombok.jar"
export PATH="$PATH:$HOME/.local/node/bin:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.nimble/bin"
export SSH_AUTH_SOCK="$(/bin/gpgconf --list-dirs agent-ssh-socket)"
export XDG_DATA_HOME="$HOME/.local/share"

# if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then 
#   exec startx &>/dev/null 
# fi

