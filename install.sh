if [ -L ~/.sh ] ; then
  rm -f ~/.sh
fi
if [ ! -e ~/.sh ] ; then
  ln -Ffhs `pwd` ~/.sh
fi
if [ ! -e ~/.local/bin/bashmarks.sh ] ; then
  git clone git://github.com/huyng/bashmarks.git
  cd bashmarks
  make install
  cd ..
  rm -rf bashmarks
fi
if [ -e ~/.bash_profile ] ; then
  if [ -L ~/.bash_profile ] ; then
    echo 'breaking old bash profile symlink'
    rm -f ~/.bash_profile
  else [ -f ~/.bash_profile ]
    echo 'moving old bash to ._bash_profile.old'
    cp -f ~/.bash_profile ~/._bash_profile.old
    rm -f ~/.bash_profile
  fi
fi
  ln -Ffhs `pwd`/bash_profile ~/.bash_profile
  echo `pwd`/bash_profile ~/.bash_profile
  echo 'symlinked new ~/.bash_profile, sourcing it now.'
  source ~/.bash_profile
