#!/usr/bin/env zsh
# ZSHRC

export PATH="${HOME}/bin:${PATH}"

# Checks if a command exists (either executable file or zsh function.)
cmd-exists() { command -v "${1}" 1>/dev/null 2>&1; }

# Autocomplete stuff
cmd-exists brew && fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
autoload -Uz compinit
compinit

# If we are on macOS: I want to have some homebrew binaries earlier in PATH so
# we prefer them from native binaries from the OS.
if [ $(uname -s) = "Darwin" ]; then
    export PATH="$(brew --prefix)/opt/sqlite/bin:${PATH}"
fi

## Export TTY for GPG, needed for the password prompt
export GPG_TTY=$(tty)

## I did not choose the vim life---it chose me
export EDITOR=nvim
alias vim=nvim
alias vi=nvim

## rust toolchain
[ -f ~/.cargo/env ] && source ~/.cargo/env

## go binaries
cmd-exists go && export PATH="${PATH}:$(go env GOPATH)/bin"

## ocaml toolchain
cmd-exists opam && eval $(opam env --switch=default --shell=zsh)

## bun
if [ -f ~/.bun ]; then
    [ -s "${HOME}/.bun/_bun" ] && source "${HOME}/.bun/_bun"
    export BUN_INSTALL="${HOME}/.bun"
    export PATH="${BUN_INSTALL}/bin:${PATH}"
fi

## Debian ls aliases (with some modifications) that just got stuck in my head
if cmd-exists eza; then
    # list
    alias ls="eza --group-directories-first"
    # list, but with some more info
    alias ll="eza --group-directories-first -l"
    # list all, i.e. include hidden files
    alias la="eza --group-directories-first -la"
    # list tree, i.e. recursive tree
    alias lt="eza --group-directories-first -lT"
fi

## Zoxide
cmd-exists zoxide && eval "$(zoxide init zsh)"

## fzf
fzf_files=(
    ~/.fzf.zsh
    /usr/share/fzf/completion.zsh
    /usr/share/fzf/key-bindings.zsh
)
for file in ${fzf_files}; do
    [ -f "${file}" ] && source "${file}"
done

## Starship
cmd-exists starship && eval "$(starship init zsh)"

## Atuin
cmd-exists atuin && eval "$(atuin init zsh --disable-up-arrow)"

## Kubectl
if cmd-exists kubectl; then
    source <(kubectl completion zsh)
    alias k=kubectl
    compdef __start_kubectl k

    if cmd-exists kubectl-krew; then
        export PATH="${PATH}:${HOME}/.krew/bin"
    fi
fi

# AWS profile picker. On invocation starts a fzf picker for all available AWS
# profiles, and sets the AWS_PROFILE env variable to the selected profile.
aws-profile-select() {
    cmd-exists aws || exit 1
    local selected=$(aws configure list-profiles --no-cli-auto-prompt | fzf)
    printf "AWS profile set to %s\n" "${selected}"
    export AWS_PROFILE="${selected}"
}
