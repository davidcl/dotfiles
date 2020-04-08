# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# OPAM configuration
if [ -d ~/.opam ]; then
    . ~/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
fi

