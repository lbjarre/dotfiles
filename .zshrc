# ZSHRC

autoload -Uz compinit
compinit

## Export TTY for GPG, needed for the password prompt
export GPG_TTY=$(tty)

export EDITOR=nvim

## rust toolchain
[ -f ~/.cargo/env ] && source ~/.cargo/env

## go binaries
[ $(command -v go) ] && export PATH="${PATH}:$(go env GOPATH)/bin"

## Debian ls aliases (with some modifications) that just got stuck in my head
alias ls="exa --group-directories-first"
alias ll="exa --group-directories-first -l"
alias la="exa --group-directories-first -la"
alias lt="exa --group-directories-first -lT"

## Zoxide
eval "$(zoxide init zsh)"

## fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

## Starship
eval "$(starship init zsh)"

## k8s
if [ $(command -v kubectl) ]; then
    source <(kubectl completion zsh)
    alias k=kubectl
    complete -F __start_kubectl k
fi

[ $(command -v kubectx) ] && alias kc=kubectx

