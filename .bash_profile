export PATH=$HOME/miniconda3/lib:$PATH
export LD_LIBRARY_PATH=$HOME/miniconda3/lib:$LD_LIBRARY_PATH

[ -f $HOME/.local/bin/zsh ] && exec $HOME/.local/bin/zsh -l

if [ -f ~/.bashrc ]; then source ~/.bashrc; fi
