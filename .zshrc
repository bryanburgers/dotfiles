# Start oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(
    cargo
    docker
    docker-compose
    git
    tmux
    zsh-autosuggestions
    zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh
# End oh-my-zsh

# vim key bindings
bindkey -v
bindkey '^R' history-incremental-search-backward

# A nice PS1 (doesn't have any of the git stuff, yet)
autoload -U colors && colors
PS1="%{$fg[cyan]%}%n %{$fg[yellow]%}%~ %{$reset_color%}$ "

# The most important alias
alias ll='ls -alF'

export CLICOLOR=1
export DOTDIR="$( (readlink -f ~/.bashrc || echo "$HOME/dotfiles/.bashrc") 2> /dev/null | xargs dirname)"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export PATH="$DOTDIR/bin:$HOME/bin:$PATH"
export VIMINIT="so $DOTDIR/.vimrc"

if [[ "$(uname)" == "Darwin" ]]; then
    PLATFORM="darwin"
elif [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
    PLATFORM="linux"
fi

alias tmux="tmux -2 -f $DOTDIR/.tmux.$PLATFORM.conf"

tmux-start() {
    SESSION=$(basename $1)
    if [[ "$PLATFORM" == "linux" ]]; then
        CWD=$(readlink -f $1)
    else
        # readlink -f not available on MacOS
        CWD=$1
    fi
    # tmux has-session -t $SESSION 2>/dev/null
    tmux list-sessions -F "#S" 2>/dev/null | grep -qe "^${SESSION}$" >/dev/null
    if [[ "$?" -eq 1 ]]; then
        # The session does not exist. Create a new session, then start vi in
        # the first window and git in the second window.
        tmux new-session -d -s $SESSION -c $CWD
    fi

    if [ -z ${TMUX+x} ]; then
        # We're not in tmux. Attach to the session.
        tmux attach-session -t $SESSION
    else
        # We're in tmux. Switch to the session.
        tmux switch-client -t $SESSION
    fi
}

if [[ "$PLATFORM" == "darwin" ]]; then
    alias ll='ls -alF'
else
    alias ll='ls -alF --color=auto'
fi
alias vim='vi'

# https://stackoverflow.com/q/47211245/314971
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000000
export SAVEHIST=10000000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
