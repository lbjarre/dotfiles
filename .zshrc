# ZSHRC

export PATH="${HOME}/bin:${PATH}"

# Autocomplete stuff
[ $(command -v brew) ] && fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
autoload -Uz compinit
compinit

# If we are on macOS: I want to have some homebrew binaries earlier in PATH so
# we prefer them from native binaries from the OS.
if [ $(uname -s) = "Darwin" ]; then
    export PATH="$(brew --prefix)/opt/sqlite/bin:${PATH}"
fi

## Export TTY for GPG, needed for the password prompt
export GPG_TTY=$(tty)

## I did not choose the vim life -- it chose me
export EDITOR=nvim
alias vim=nvim
alias vi=nvim

## rust toolchain
[ -f ~/.cargo/env ] && source ~/.cargo/env

## go binaries
[ $(command -v go) ] && export PATH="${PATH}:$(go env GOPATH)/bin"

## ocaml toolchain
[ $(command -v opam) ] && eval $(opam env --switch=default --shell=zsh)

## Debian ls aliases (with some modifications) that just got stuck in my head
if [ $(command -v exa) ]; then
    alias ls="exa --group-directories-first"
    alias ll="exa --group-directories-first -l"
    alias la="exa --group-directories-first -la"
    alias lt="exa --group-directories-first -lT"
fi

## Zoxide
[ $(command -v zoxide) ] && eval "$(zoxide init zsh)"

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
[ $(command -v starship) ] && eval "$(starship init zsh)"

## k8s
if [ $(command -v kubectl) ]; then
    source <(kubectl completion zsh)
    alias k=kubectl
    compdef __start_kubectl k
fi

[ $(command -v kubectx) ] && alias kc=kubectx

if [ $(command -v kubectl-krew) ]; then
    export PATH="${PATH}:${HOME}/.krew/bin"
    source <(kubectl-krew completion zsh)
fi

