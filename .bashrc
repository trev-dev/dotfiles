# vim: foldmethod=marker
# Commands that should be applied only for interactive shells.
[[ $- == *i* ]] || return

# History {{{
HISTFILESIZE=100000
HISTSIZE=10000

shopt -s histappend
shopt -s checkwinsize
shopt -s extglob
shopt -s globstar
shopt -s checkjobs
# }}}

# Aliases {{{
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias k='khal calendar'
alias ki='khal interactive'
alias kl='khal list'
alias la='ls -al'
alias lg='ledger --strict -f ~/Documents/Ledgers/2023/main.ledger'
alias lgit='lazygit'
alias ll='ls -l'
alias nixos-rebuild='sudo nixos-rebuild switch'
alias nm='neomutt'
alias nv='nvim'
alias r='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
alias t='task'
alias ti='timew'
alias tib='timew billable'
alias tm='task mod'
alias tu='taskwarrior-tui'
alias vs='vim -S'
alias zke='zk edit --interactive'
alias zkl='zk list --interactive'
# }}}

# Scripts & Apps {{{
# May not need this
# if [[ ! -v BASH_COMPLETION_VERSINFO ]]; then
#   . "/etc/profile.d/bash_completion.sh"
# fi

if [[ :$SHELLOPTS: =~ :(vi|emacs): ]]; then
  . /usr/share/fzf/completion.bash
  . /usr/share/fzf/key-bindings.bash
fi

eval "$(/bin/zoxide init bash )"

GPG_TTY="$(tty)"
export GPG_TTY
/bin/gpg-connect-agent updatestartuptty /bye > /dev/null
# }}}

# Prompt {{{
prompt_git() {
  local s='';
  local branchName='';

  # Check if the current directory is in a Git repository.
  if [ $(git rev-parse --is-inside-work-tree &>/dev/null; echo "${?}") == '0' ]; then

    # check if the current directory is in .git before running git checks
    if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]; then

      # Ensure the index is up to date.
      git update-index --really-refresh -q &>/dev/null;

      # Check for uncommitted changes in the index.
      if ! $(git diff --quiet --ignore-submodules --cached); then
        s+='+';
      fi;

      # Check for unstaged changes.
      if ! $(git diff-files --quiet --ignore-submodules --); then
        s+='!';
      fi;

      # Check for untracked files.
      if [ -n "$(git ls-files --others --exclude-standard)" ]; then
        s+='?';
      fi;

      # Check for stashed files.
      if $(git rev-parse --verify refs/stash &>/dev/null); then
        s+='$';
      fi;

    fi;

    # Get the short symbolic ref.
    # If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
    # Otherwise, just give up.
    branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
      git rev-parse --short HEAD 2> /dev/null || \
      echo '(unknown)')";

    [ -n "${s}" ] && s=" [${s}]";

    echo -e "${1}${branchName}${2}${s}  ";
  else
    return;
  fi;
}

black="\[\e[30m\]"
red="\[\e[31m\]"
green="\[\e[32m\]"
yellow="\[\e[33m\]"
blue="\[\e[34m\]"
purple="\[\e[35m\]"
cyan="\[\e[36m\]"
gray="\[\e[37m\]"
reset="\[\e[0m\]"

# Trim my path so it doesn't get too long.
export PROMPT_DIRTRIM="3"

# Highlight the user name when logged in as root.
isRoot="";
if [[ "$USER" == "root" ]]; then
  isRoot+="\[\e[1;31m\][root]$reset ";
fi;

# Adjust the prompt depending on whether we're in nix shell.
isEnv=""
if [ -n "$IN_NIX_SHELL" ]; then
    isEnv+="$yellow[env]$reset "
fi

if [[ "$TERM" == "dumb" ]]; then
    PS1="$isRoot$isEnv$reset\w > "
else
    PS1="$isRoot$isEnv$gray\w$reset "
    PS1+="\[\e[1;32m\]\$(prompt_git)$reset";
    PS1+="\[\e[1;33m\]λ$reset "
fi;

export PS1;
# }}}
