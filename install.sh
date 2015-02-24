if [ -k ~/.bash_profile ] ; then
  echo 'breaking old bash profile symlink'
elif [ -f ~/.bash_profile ] ; then
  echo 'moving old bash to ._bash_profile.old'
  cp -f ~/.bash_profile ~/._bash_profile.old
  rm -f ~/.bash_profile
fi
ln -Ffhs `dirname $0`/bash_profile ~/.bash_profile
echo 'symlinked new ~/.bash_profile, sourcing it now.'
source ~/.bash_profile
