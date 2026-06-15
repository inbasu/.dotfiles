PS1="%F{green}%B%1~%b %f"

autoload -Uz compinit
compinit

alias wg-quick='sudo wg-quick'
alias vim='nvim'

ddg() {
    local query=$(echo "$*" | sed 's/ /+/g')
    open -a "Zen.app" "https://duckduckgo.com/?q=$query"
}
