# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH

# OPAM configuration
. /home/davidcl/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

# Rust config
export PATH="$HOME/.cargo/bin:$PATH"
