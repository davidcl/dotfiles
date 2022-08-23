# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# WSL specific setup
if [ -f /etc/wsl.conf ]; then
    export DISPLAY=127.0.1.1:0
    # Mount Alpine vhdx as a workdir
    if [ ! -d /mnt/wsl/work ] ; then
       mkdir /mnt/wsl/work
       wsl.exe -d Alpine mount --bind /work /mnt/wsl/work
    fi
    if [ ! -d $HOME/work ] ; then
        ln -s /mnt/wsl/work $HOME/work
    fi
fi

shopt -s globstar

# specific PS1
#source /usr/share/git-core/contrib/completion/git-prompt.sh
#PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
. ${HOME}/.config/powerline.bash
PROMPT_COMMAND='__update_ps1 $?'

# C/C++/Fortran configuration
if [ -e "$(command -v gcc-8)" ]; then
    export CC=gcc-8
    export CC_STR=" CC=gcc-8"
    export CXX=g++-8
    export CXX_STR=" CXX=g++-8"
    export F77=gfortran-8
    export F77_STR=" F77=gfortran-8"
fi
if [ -e "$(command -v gcc-11)" ]; then
    export CC=gcc-11
    export CC_STR=" CC=gcc-11"
    export CXX=g++-11
    export CXX_STR=" CXX=g++-11"
    export F77=gfortran-11
    export F77_STR=" F77=gfortran-11"
fi


# EDITOR
export EDITOR=/usr/bin/vim
export SVN_EDITOR=/usr/bin/vim

# User specific aliases and functions
alias dotfiles="/usr/bin/git --git-dir=/home/davidcl/.dotfiles.git/ --work-tree=/home/davidcl"
alias make="LANG=en_US.utf8 nice make -j\$(nproc)"
alias git="LANG=en_US.utf8 /usr/bin/git"
alias xpath="xmllint --xpath"
alias ping6_linklocal="ping6 -I enp7s0 ff02::1"

alias scikill="kill -9 \`pidof lt-scilab-bin lt-scilab-cli-bin scilab-bin scilab-cli-bin\`"
alias scidebug="gdb -command=gdb.txt --pid=\`pidof lt-scilab-bin lt-scilab-cli-bin scilab-bin scilab-cli-bin\` "
alias scipid="pidof lt-scilab-bin lt-scilab-cli-bin scilab-bin scilab-cli-bin"

alias sciconfig="JAVA_HOME=/etc/alternatives/java_sdk/ ./configure --enable-silent-rules --without-emf "${CC_STR}${CXX_STR}${F77_STR} 
alias clangconfig="sciconfig CC=clang CXX=clang++"
alias scireconfig="find . -name '*.Plo' -delete && ./config.status"
alias debugmake="make CFLAGS='-O0 -g -fdiagnostics-color' CXXFLAGS='-O0 -g -fdiagnostics-color' FFLAGS='-O0 -g -fdiagnostics-color'"

# to execute desktop files
function desktop-open {
    eval "$(grep '^Exec' $1 | sed 's/^Exec=//' | sed 's/%.//')"
}

# Specific functions

function bgoid {
        while [ -n "$1" ] ;do
                url="http://bugzilla.scilab.org/show_bug.cgi?id=${1}"
                echo "$url"
                firefox --new-tab "$url"
                shift
        done
}
function croid {
        while [ -n "$1" ] ;do
                firefox --new-tab "http://codereview.scilab.org/r/$1"
                shift
        done
}
function bbug {
        while [ -n "$1" ] ;do
                firefox --new-tab "http://bugzilla.scilab.org/buglist.cgi?query_format=specific&order=relevance+desc&bug_status=__open__&product=Scilab++software&content=$1"
                shift
        done
}
function cgit {
        while [ -n "$1" ] ;do
                firefox --new-tab "http://cgit.scilab.org/scilab/commit/?id=$1"
                shift
        done
}
function gitweb {
        while [ -n "$1" ] ;do
          firefox --new-tab "http://gitweb.scilab.org/?p=scilab.git;a=commit;h=$1"
          shift
        done
}
function review {
        while [ -n "$1" ] ;do
                url="http://codereview.scilab.org/#/q/$1,n,z"
                echo "$url"
                firefox --new-tab "$url"
                shift
        done
}
function zcos_less {
    unzip -p "$1" content.xml |xmllint --format - |less
}
function test_run {

    if [[ -f $1 ]]; then
        bin/scilab -nwni -quit -e "exec $1"
    elif [[ $# -lt 2 ]]; then
        bin/scilab -nwni -quit -e "test_run(\"$1\", [],[\"create_ref\",\"mode_nwni\"])"
    else
        module=$1
        shift
        tests="["
        for t in "$@"
        do
            tests="$tests \"$t\""
        done
        tests="$tests]"
        bin/scilab -nwni -quit -e "test_run(\"$module\",$tests,[\"create_ref\",\"mode_nwni\"])"
    fi

    
}
function _test_run_completions {
    local testname
    if [[ $COMP_CWORD -lt 2 ]]; then
        COMPREPLY=($(compgen -W "$(find modules -mindepth 1 -maxdepth 1 -type d -printf '%f\n')" -- "${COMP_WORDS[1]}"))
    else
        testname="$(find modules/${COMP_WORDS[1]}/tests -name ${COMP_WORDS[$COMP_CWORD]}*.tst -exec basename {} .tst \;)"
        COMPREPLY=($(compgen -W "$testname" -- "${COMP_WORDS[$COMP_CWORD]}"))
    fi
}
complete -F _test_run_completions test_run

function doAndWarn () 
{ 
echo "doAndWarn $1";
START=`date`;
send_alias=$(alias);
cmd="$1";
shift;
args=${1:+$(IFS='"' echo "\"${*//\"/\\\"}\"")};
if bash -O expand_aliases ; then
    notify-send -u low "Command $cmd is finished.";
else
    notify-send -u critical "Command $cmd failed!";
fi <<EOF
cd $PWD
$send_alias
$cmd $args
EOF

echo "Started at $START.";
echo "Ended   at $(date)."
}

# Set dev. env variables

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# http://udrepper.livejournal.com/11429.html
export MALLOC_PERTURB_=$((RANDOM % 255 + 1))
test -n "$PS1" && echo 1>&2 MALLOC_PERTURB_=$MALLOC_PERTURB_

export MALLOC_CHECK_=2  # 0: off; 1: announce on stderr; 2: abort
test -n "$PS1" && echo 1>&2 MALLOC_CHECK_=$MALLOC_CHECK_

export MEMCPY_CHECK_=2 # 0: off; 1: announce on stderr and abort
test -n "$PS1" && echo 1>&2 MEMCPY_CHECK_=$MEMCPY_CHECK_

export SCI_DISABLE_EXCEPTION_CATCHING=1

# debug alias
export ASAN_OPTIONS=detect_leaks=0
export JAVA_DEBUG_OPTIONS="-Xint -Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,address=8010,server=y,suspend=n -XX:+UnlockDiagnosticVMOptions -XX:-LogVMOutput -XX:-DisplayVMOutput -XX:-PrintVMOptions"
export JAVA_PROFILE_OPTIONS="-agentlib:hprof=cpu=samples,depth=40"
# export _JAVA_OPTIONS=$JAVA_DEBUG_OPTIONS
alias scilab-debug="_JAVA_OPTIONS=\"$JAVA_DEBUG_OPTIONS\" bin/scilab"
alias scilab-profile="_JAVA_OPTIONS=\"$JAVA_PROFILE_OPTIONS\" bin/scilab"
alias scilab-valgrind='SCI=$(pwd) ./libtool --mode=execute valgrind --show-below-main=yes --num-callers=12 --demangle=yes --leak-check=full --show-reachable=yes --smc-check=all --gen-suppressions=all --show-below-main=yes --track-origins=yes --log-file=valgrind.log scilab-cli-bin -nwni -profiling'
alias scilab-master="~/work/branches/master/scilab/bin/scilab"
alias scilab-next="~/work/branches/6.0/scilab/bin/scilab"
alias scilab-stable="EGL_LOG_LEVEL=fatal ~/work/releases/scilab-6.0.2/bin/scilab"
alias scilab-previous="~/work/branches/5.5/scilab/bin/scilab"
alias scilab-limited="cgexec -g 'cpu,memory:limited' bin/scilab"

# servers
alias davidcl.ovh="ssh vps448456.ovh.net -t 'tmux attach || tmux new'"
alias borneo.local="ssh borneo.local -t 'tmux attach || tmux new'"


# rust configuration
export CARGO_TARGET_DIR="$HOME/.cargo/cache"
export RUSTUP_HOME="/opt/rustup"

# golang configuration
export GOPATH="/home/davidcl/tools/go:/usr/share/gocode"

# emsdk for WebAssembly
if shopt -q login_shell && [ -f /home/davidcl/work/tools/emsdk/emsdk_env.sh ]; then
    echo 'to load esdk use: source /home/davidcl/work/tools/emsdk/emsdk_env.sh'
#    source /home/davidcl/work/tools/emsdk/emsdk_env.sh
fi

# add specific tools to the path
PATH="${PATH}:/home/davidcl/work/projects/projetP/qgen-2.0.0w-20150225-x86-linux-bin/bin"
EMX_CODEGEN_PATH="/home/davidcl/work/projects/argo/toolset/EMXCodeGen/Build/x86_64-unknown-linux-gnu-Release"
PATH="${PATH}:${EMX_CODEGEN_PATH}"

# User specific environment and startup programs
PATH=$PATH:$HOME/.local/bin:$HOME/bin

# discard conda packages loading, the user is free to choose
#export PATH=/opt/miniconda2/bin:$PATH

# rust binaries
PATH="$HOME/.cargo/bin:$PATH"

# golang binaries
PATH=$PATH:/home/davidcl/tools/go/bin

export PATH 

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/davidcl/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/davidcl/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/davidcl/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/davidcl/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

