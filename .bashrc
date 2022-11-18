##
# ~/.bashrc
##

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


## Default Prompts, before and starship etc  
PS0=''            # After a command.
PS1='\A \u \w $ ' # Primary
PS2='> '          # Secondary
PS4='./ '         # Indicate levels of indirection.

# Print N directory levels in the command prompt.
PROMPT_DIRTRIM=2


#
## Settings
#

# Use vi key bindings
set -o vi


#
## Environment Variables
#


#
## Aliases
#
alias cl='clear'
alias ls='ls --color=auto'
alias la='ls -A'
alias ll='ls -lA'

alias myip='echo "My IP: " && curl ipinfo.io/ip'


#
## Functions
#

# Move into a directory and print the contents.
function cdla () { cd $1 && la; }

# Make a directory, and move into it.
function mkcd () { mkdir $1 && cd $1; }

# Make a directory, move into it, and print the contents.
function mkcdla () { mkdir $1 && cd $1 && la; }

# Clear the screen and start with the contents of the current directory.
function xla () { clear && echo "" && la; }


#
## Additional Functionality
#

# Prompt
eval "$(starship init bash)"




#
