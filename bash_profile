source ~/.local/bin/bashmarks.sh
source ~/.sh/bashcolors

# shared aliases
source ~/.sh/aliases

# local aliases (not on this repo)
# source ~/.sh/local/**/**.aliases

source ~/.sh/funcs
source ~/.sh/strap
source ~/.sh/completions/*

#my prompt
PS1="\r\n$Cyan[\w] $Blue\r\n$IRed\h: $Color_Off"

export PATH="~/.sh/x:$PATH"
