source ~/.local/bin/bashmarks.sh
source ~/.sh/bashcolors
source ~/.sh/aliases
source ~/.sh/funcs
source ~/.sh/strap
source ~/.sh/completions/*

#my prompt
PS1="\r\n$Cyan[\w]\r\n$IRed\h: $Color_Off"

export PATH="~/.sh/x:$PATH"
