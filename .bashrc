# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend
# Put multi-line commands into one history entry
shopt -s cmdhist

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000000
HISTFILESIZE=1000000
HISTIGNORE='ls:bg:fg'

# Save commands in history immediately instead of by exit only
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

 #make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

__prompt_command() {
    local EXIT="$?" # This needs to be first
    PS1=""

    local RCol='\[\e[0m\]' # Reset colors

    local Red='\[\e[0;31m\]'
    local LRed='\[\e[0;91m\]'
    local BGreen='\[\e[1;32m\]'
    local Green='\[\e[0;32m\]'
    local Yel='\[\e[0;33m\]'
    local BYel='\[\e[1;33m\]'
    local BBlue='\[\e[1;34m\]'
    local Pur='\[\e[0;35m\]'
    local Cyan='\[\e[0;36m\]'
    local White='\[\e[01;37m\]'
    local Black='\[\e[01;30m\]'

    local git_branch="${Cyan}$(__git_ps1)"

    # If root, just print the host in red. Otherwise, print the current user
    # and host in green.
    if [[ $EUID == 0 ]]; then
        user_color=$Red
        prompt_color=$Red
    else
        user_color=$Green
        prompt_color=$RCol
    fi
    local user="${user_color}\\u@\\h"

    PS1="${user}:${Yel}\w${git_branch}${prompt_color}\\$ ${RCol}"

    # Fancy statuses from https://stackoverflow.com/a/34812608/1657819
    local FancyX='\[\342\234\]\227'
    local Checkmark='\[\342\234\]\223'
    # Exit code of last command
    local status="${Black}$EXIT "
    if [[ $EXIT == 0 ]]; then
        status+="${Green}$Checkmark "
    else
        status+="${Red}$FancyX "
    fi
    status+="\t " # Current time

    PS1="$status$PS1"

    if [[ -n "$VIRTUAL_ENV" ]]; then
	local venv="(${VIRTUAL_ENV##*/}) "
	PS1="$venv$PS1"
    fi
}

if [ "$color_prompt" = yes ]; then
    PROMPT_COMMAND=__prompt_command
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -lh'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
