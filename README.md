# Dotfiles
These are managed with git, using tips found [here](https://www.atlassian.com/git/tutorials/dotfiles)

**Note:** This is a mirror, and may not always be up-to-date.  Consider checking
out [sourcehut](https://git.sr.ht/~trevdev/dotfiles)

## Installation
1. To install these, make an alias and the following git ignore so that cloning
goes well:
    ```bash
    alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME' && \
      echo ".dotfiles" >> .gitignore
    ```
1. Then clone this thing:
    ```bash
    git clone --bare git@git.sr.ht:~trevdev/dotfiles $HOME/.dotfiles
    ```
2. Move conflicting/existing files
    ```bash
    mkdir -p .config-backup && \
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
    xargs -I{} mv {} .config-backup/{}
    ```
3. Then checkout the config && ignore untracked files
    ```bash
    config checkout && config config --local status.showUntrackedFiles no
    ```
4. Don't forget to initialize submodules and source the updated shell env
    ```bash
    config submodule update --init --recursive
    source .bashrc
    ```
