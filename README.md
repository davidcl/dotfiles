# dotfiles
My dotfiles and personal preferences 

To install on a new machine:
```sh
# get the repo
git clone --bare git@github.com:davidcl/dotfiles.git $HOME/.dotfiles.git
# alias to ease further commands
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"
# checkout the files
dotfiles checkout --force
# local git config to avoid listing all files  
dotfiles config --local status.showUntrackedFiles no
```
