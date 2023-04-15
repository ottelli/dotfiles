##
# ~/.bashrc
##

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

## Default Prompts, in absense of starship etc  
PS0=''            # After a command.
PS1='\A \u \w $ ' # Primary ( date username working-directory $ )
PS2='> '          # Secondary
PS4='./ '         # Indicate levels of indirection.

# Print N directory levels in the command prompt.
PROMPT_DIRTRIM=2


#
## Settings
#

# Use vi key bindings
set -o vi

# Check the window size after each command, and resize as necessary
shopt -s checkwinsize

# History
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend

# Completions
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ] ; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ] ; then
		. /etc/bash_completion
	fi
fi	


#
## Aliases
#
alias cl='clear'
alias ls='ls --color=auto'
alias la='ls -A'
alias ll='ls -lA'

alias myip='echo "Current IP is: $(curl -s ipinfo.io/ip)"'

# Can also define local aliases, eg for specific workflows
if [ -f $HOME/.bash_aliases ] ; then
	. $HOME/.bash_aliases
fi

# enable color support of ls and grep
if [ -x /usr/bin/dircolors ] ; then
	test -r $HOME/.dircolors && eval "$(dircolors -b $HOME/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	alias dir='dir --color=auto'
	alias vdir='vdir --color=auto'
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi


#
## Programming Environments
#

# Node Version Manager
if [ -d "$HOME/.nvm" ] ; then
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # loads completions
fi

# Python Virtual Environments
if [ -d "$HOME/.pyenv" ] ; then
	export PYENV_ROOT=$HOME/.pyenv
	export PATH="$PATH:$PYENV_ROOT/bin"
	eval "$(pyenv init --path)" 	# sets up shims path
	eval "$(pyenv init -)"		# install pyenv into shell, enable shims and autocompletion
	eval "$(pyenv virtualenv-init -)"	# auto activate if dir contains .python-version
fi

# Go Path
if [ -d "/usr/local/go/bin" ] ; then
	export PATH="$PATH:/usr/local/go/bin"
fi

if [ -d "$HOME/go/bin" ] ; then
    export PATH="$PATH:$HOME/go/bin"
fi


#
## Functions
#

# Move into a directory and print the contents.
function cdla () { cd $1 && la; }

# Make a directory, and move into it.
function mkcd () { mkdir $1 && cd $1; }

# Clear the screen and start with the contents of the current directory.
function xla () { clear && echo "" && la; }

## Include user scripts
if [ ! -z `ls $HOME/.local/include` ] ; then
	for i in $HOME/.local/include/*;
		do . $i
	done
fi

#
## Additional Functionality
#

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Prompt
eval "$(starship init bash)"




#
