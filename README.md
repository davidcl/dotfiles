# dotfiles
My dotfiles and personal preferences 

To install on a new machine:
```sh
# get the repo
git clone --bare git@github.com:davidcl/dotfiles.git $HOME/.dotfiles.git
# alias to ease further commands
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"
# backup existing files
dotfiles checkout 2>&1 |egrep "\s+\." |xargs -I{} mv {} {}.dotfiles.bak
# checkout the files
dotfiles checkout
# restore files for future commit
ls .*.dotfiles.bak |rev |cut -f 3- -d '.' |rev |xargs -I{} mv {}.dotfiles.bak {}
# local git config to avoid listing all files  
dotfiles config --local status.showUntrackedFiles no
```
