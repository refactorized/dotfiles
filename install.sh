#!/bin/bash

dir=`pwd`


if [ -L ~/.sh ] ; then
  rm -f ~/.sh
fi
if [ ! -e ~/.sh ] ; then
  ln -Ffhs $dir ~/.sh
fi
if [ ! -e ~/.local/bin/bashmarks.sh ] ; then
  git clone git://github.com/huyng/bashmarks.git
  cd bashmarks
  make install
  cd ..
  rm -rf bashmarks
fi

# todo: use a function to dry this up
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
ln -Ffhs $dir/bash_profile ~/.bash_profile
echo $dir/bash_profile "=>" ~/.bash_profile

# todo - some kind of env config so i don't have my name as the default github user
if [ -e ~/.gitconfig ] ; then
  if [ -L ~/.gitconfig ] ; then
    echo 'breaking old user gitconfig symlink'
    rm -f ~/.gitconfig
  else [ -f ~/.gitconfig ]
    echo 'moving old gitconfig to ._gitconfig.old'
    cp -f ~/.gitconfig ~/._gitconfig.old
    rm -f ~/.gitconfig
  fi
fi
ln -Ffhs $dir/gitconfig ~/.gitconfig
echo $dir/gitconfig "=>" ~/.gitconfig

mkdir -p $dir/local
echo 'put local .aliases files in $dir/local/, if needed.'

echo 'symlinked new ~/.bash_profile, sourcing it now.'
source ~/.bash_profile

echo 'done, make sure hub is installed ( brew install hub ) or remove alias git=hub from ~/.sh/aliases'
