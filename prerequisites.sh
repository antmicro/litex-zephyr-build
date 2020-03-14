#!/bin/bash

sudo apt install -y direnv

SHELL_NAME=$(basename $SHELL)

case $SHELL_NAME in
  "bash")
    echo "Adding direnv hooh for bash"
    echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
    ;;
  "zsh")
    echo "Adding direnv hook for zsh"
    echo 'eval "$(direnv hook zsh)"' >> ~/.bashrc
    ;;
  *)
    echo 'Unknown shell'
    ;;
esac
