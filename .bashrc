export CLICOLOR=1

export DOTDIR="$( (readlink -f ~/.bashrc || echo "$HOME/dotfiles/.bashrc") 2> /dev/null | xargs dirname)"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export PATH="$DOTDIR/bin:~/bin:$PATH"
export FZF_DEFAULT_COMMAND='ag -g ""'
export EDITOR=vim
export VIMINIT="so $DOTDIR/.vimrc"

if [ "$(uname)" == "Darwin" ]; then
	PLATFORM="darwin"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
	PLATFORM="linux"
fi

alias dockerps='docker ps --format="table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"'
alias tmux="tmux -2 -f $DOTDIR/.tmux.$PLATFORM.conf"
alias ll='ls -alF'
alias vim='vi'

COLOR_RED="\[\e[0;31m\]"
COLOR_GREEN="\[\e[0;32m\]"
COLOR_YELLOW="\[\e[0;33m\]"
COLOR_CYAN="\[\e[0;36m\]"
COLOR_WHITE="\[\e[0;37m\]"
COLOR_BLUE="\[\e[0;34m\]"
COLOR_GRAY="\[\e[1;30m\]"
COLOR_RESET="\[\e[0m\]"

# Git stuff.
is_git_repo() {
    $(git rev-parse --is-inside-work-tree &> /dev/null)
}

is_git_dir() {
    $(git rev-parse --is-inside-git-dir 2> /dev/null)
}

get_git_branch() {
    local branch_name

    # Get the short symbolic ref
    branch_name=$(git symbolic-ref --quiet --short HEAD 2> /dev/null) ||
    # If HEAD isn't a symbolic ref, get the short SHA
    branch_name=$(git rev-parse --short HEAD 2> /dev/null) ||
    # Otherwise, just give up
    branch_name="(unknown)"

    printf $branch_name
}

get_git_ahead_behind() {
    local ahead behind aheadbehind
    ahead=$(git status --short --branch | grep "##.*ahead" | sed -Ee "s/.*ahead ([0-9]+).*/\1/")
    behind=$(git status --short --branch | grep "##.*behind" | sed -Ee "s/.*behind ([0-9]+).*/\1/")
    if [[ -n $ahead ]]; then
    	ahead="+$ahead"
    fi
    if [[ -n $behind ]]; then
    	behind="-$behind"
    fi

    aheadbehind="${COLOR_GREEN}$ahead${COLOR_RED}$behind"

    echo $aheadbehind
}

# Git status information
prompt_git() {
    local git_info git_state uc us ut st

    if ! is_git_repo || is_git_dir; then
        return 1
    fi

    printf " $(get_git_branch)"
#    git_info="$(get_git_branch)${COLOR_WHITE}$(get_git_ahead_behind)"
#
#    # Check for uncommitted changes in the index
#    if ! $(git diff --quiet --ignore-submodules --cached); then
#        uc="${COLOR_GREEN}!"
#    fi
#
#    # Check for unstaged changes
#    if ! $(git diff-files --quiet --ignore-submodules --); then
#        us="${COLOR_RED}!"
#    fi
#
#    # Check for untracked files
#    if [ -n "$(git ls-files --others --exclude-standard)" ]; then
#        ut="${COLOR_RED}+"
#    fi
#
#    # Check for stashed files
#    if $(git rev-parse --verify refs/stash &>/dev/null); then
#    	# Yellow $
#        st="${COLOR_YELLOW}$"
#    fi
#
#    git_state=$uc$us$ut$st
#
#    # Combine the branch name and state information
#    if [[ $git_state ]]; then
#        git_info="$git_info $git_state"
#    fi
#
#    printf " ${COLOR_CYAN}${git_info}"
}

#PS1="${COLOR_CYAN}\u ${COLOR_YELLOW}\w\$(prompt_git)${COLOR_RESET} ⚡️ "
if [ -z "$TMUX" ]; then
    PS1="${COLOR_CYAN}\u ${COLOR_YELLOW}\w${COLOR_GREEN}\$(prompt_git)${COLOR_RESET} $ "
else
    PROMPT_COMMAND="tmux refresh-client -S; $PROMPT_COMMAND"
    PS1="${COLOR_YELLOW}\w${COLOR_RESET} $ "
fi

# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history
# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

if [ "$PLATFORM" == "darwin" ]; then
	if [ -f $(brew --prefix)/etc/bash_completion ]; then
		. $(brew --prefix)/etc/bash_completion
	fi
fi

if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi


[ -f ~/.fzf.bash ] && source ~/.fzf.bash

