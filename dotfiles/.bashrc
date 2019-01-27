#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#ALIASES ======================================================================
alias sudo='sudo '
alias ls='ls --color=auto '
alias ll='ls -la '
alias l='ls -a'
alias s='sudo '
alias c='clear '
alias rm='rm -i '

alias fonts='fc-list | cut -f2 -d ":" | sort -u'
#==============================================================================

#PS1='[\u@\h \W]\$ '

# PS1 prompt
# PROMPT_COMMAND=__prompt_command
# __prompt_command() {
#     local EXIT="$?"
#     PS1=""
#     if [ $EXIT != 0 ]; then
#         PS1+="\[\033[0;32m\]>[\[\033[0;31m\]$EXIT\[\033[0;32m\]]>"
#     else
#         PS1+="\[\033[0;32m\]>"
#     fi
#     if [ "$EUID" -ne 0 ]; then
#         PS1+="[\[\033[0;34m\]\u"
#     else
#         PS1+="[\[\033[0;31m\]\u"
#     fi
#     #PS1+="\[\033[0;32m\]] | [\[\033[0;35m\]\h\[\033[0;32m\]] | [\[\033[0;36m\]\w\[\033[0;32m\]]\n#>:\[\033[0m\] "
#     PS1+="\[\033[0;32m\]] | [\[\033[0;35m\]\h\[\033[0;32m\]] | [\[\033[0;36m\]\w\[\033[0;32m\]]\n#>:\[\033[0m\] "
# }

function nonzero_return() {
	RETVAL=$?
	[ $RETVAL -ne 0 ] && echo "$RETVAL"
}

parse_git_branch() {
     git branch 2> /dev/null | grep "\*" | cut -c 3-
}

#export PS1="[\`nonzero_return\`] [\[\e[36m\]\u\[\e[m\]@\[\e[32m\]\h\[\e[m\]] [\$(parse_git_branch)\[\033[00m\] ] [\[\e[34m\]\w\[\e[m\]] \n#>: "
# PS1 prompt
PROMPT_COMMAND=__prompt_command
__prompt_command() {
    local EXIT="$?"
    PS1=""
    if [ $EXIT != 0 ]; then
        PS1+="\[\033[0;32m\][\[\033[0;31m\]$EXIT\[\033[0;32m\]]"
        else
        PS1+="\[\033[0;32m\]"
    fi
    if [ "$EUID" -ne 0 ]; then
        PS1+="[\[\033[0;34m\]\u"
    else
        PS1+="[\[\033[0;31m\]\u"
    fi
    PS1+="\[\033[0;32m\]@\[\033[0;35m\]\h\[\033[0;32m\]] | [$(parse_git_branch)] | [\[\033[0;36m\]\w\[\033[0;32m\]]\n#>:\[\033[0m\] "
}


#if [ -e ~/.bashrc.aliases ] ; then
#   source ~/.bashrc.aliases
#fi
# >>> Added by cnchi installer
EDITOR=/usr/bin/vim