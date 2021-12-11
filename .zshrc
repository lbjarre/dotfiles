# ZSHRC

export PATH="${HOME}/bin:${PATH}"

# Autocomplete stuff
[ $(command -v brew)] && fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
autoload -Uz compinit
compinit

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

## Debian ls aliases (with some modifications) that just got stuck in my head
alias ls="exa --group-directories-first"
alias ll="exa --group-directories-first -l"
alias la="exa --group-directories-first -la"
alias lt="exa --group-directories-first -lT"

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
    complete -F __start_kubectl k
fi

[ $(command -v kubectx) ] && alias kc=kubectx

