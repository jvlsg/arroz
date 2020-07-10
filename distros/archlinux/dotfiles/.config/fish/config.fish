#FUNCTIONS ======================================================================
abbr .. "cd .."
abbr rm "rm -i"
abbr ll "ls -lah --color=auto"
abbr l "ls -a --color=auto"
abbr s "sudo"
abbr c "clear"

function fonts
	fc-list | cut -f2 -d ":" | sort -u
end

set fish_greeting

# ENV VARIABLES  ============================================================
#export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/sbin:/sbin:/bin:/home/jv/.vimpkg/bin"
export EDITOR='vim'
export BROWSER='firefox'
set PATH $PATH ~/.gem/ruby/2.7.0/bin
