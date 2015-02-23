source ~/.local/bin/bashmarks.sh
source ~/.sh/bashcolors
source ~/.sh/aliases
source ~/.sh/funcs
source ~/.sh/strap


#my prompt
PS1="\r\n$Cyan[\w]\r\n$IRed\h: $Color_Off"

export PATH="~/.sh/x:$PATH"
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

#export NVM_DIR="/Users/adam/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm



# rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# nvm 
source ~/.nvm/nvm.sh


