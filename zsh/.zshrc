# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
#
#
# MARKUS EGENE !!
eval "$(starship init zsh)"


# Set TMUX on initializatio
if command -v tmux &> /dev/null \
  && [ -z "$TMUX" ] \
  && [ -z "$INSIDE_EMACS" ] \
  && [ -z "$VSCODE_INJECTION" ] \
  && [[ "$TERM_PROGRAM" != "vscode" ]] \
  && [[ "$TERM_PROGRAM" != "cursor" ]] \
  && [ -z "$CURSOR_TRACE_DIR" ] \
  && [ -t 0 ]; then
  tmux new-session -A -s main

fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

# Docker CLI completions. Must be in fpath BEFORE oh-my-zsh runs compinit.
fpath=(/Users/markusevanger/.docker/completions $fpath)

# Homebrew's site-functions is added by `brew shellenv` in .zprofile, which only
# runs for LOGIN shells. Without this, non-login shells have a different $fpath,
# and oh-my-zsh throws away the completion cache every time the two alternate.
if [[ -d /opt/homebrew/share/zsh/site-functions ]]; then
  fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
fi
typeset -gU fpath

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshr
alias ohmyzsh="nvim ~/.oh-my-zsh"
source /opt/homebrew/opt/spaceship/spaceship.zsh

alias p="python3"
alias dev="pnpm dev"
alias build="pnpm build"
alias tg="pnpm typegen"
alias vbuild="vercel build"

alias del-packages="echo "🚮 removing node_modules && pnpm-lock.yaml..." && rm -rf node_modules pnpm-lock.yaml"

alias redo-packages-pnpm="del-packages && pi"
alias ls="lsd"


alias asd="cd ~/jobb/repos"
alias dsa="cd ~/personal"
alias asddsa="cd ~/"
alias desktop="cd ~/Desktop/"
alias f="fzf"
alias ff="fastfetch"
alias pn="pnpm"
alias v="vercel"
alias cat="bat" #use bat instead of cat
blubb() { PERL5LIB=/opt/homebrew/opt/asciiquarium/libexec/lib/perl5 /usr/bin/perl5.34 ~/Personal/programs/asciiquarium -t "$@"; }
alias asciiquarium=blubb
alias reload="source ~/.zshrc"
alias secret="openssl rand -base64 32"
alias c="claude"
alias cc="claude --dangerously-skip-permissions"
alias tt="timely"

eval "$(fnm env --use-on-cd --shell zsh)"

# custom ffmpeg-cli
export PATH="$PATH:/Users/markusevanger/personal/ffmpeg-cli"
# asdf
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

#packwiz (mc)
export PATH="/Users/markusevanger/go/bin:$PATH"


# fnm
FNM_PATH="/Users/markusevanger/Library/Application Support/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/Users/markusevanger/Library/Application Support/fnm:$PATH"
  eval "`fnm env`"
fi


# pnpm
export PNPM_HOME="/Users/markusevanger/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
#
#

# bun completions
[ -s "/Users/markusevanger/.bun/_bun" ] && source "/Users/markusevanger/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Added by Antigravity
export PATH="/Users/markusevanger/.antigravity/antigravity/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# Config file selector
export PATH="$HOME/.scripts:$PATH"

# >>> conda initialize (lazy) >>>
# The real `conda shell.zsh hook` costs ~400ms, so defer it to first use.
# Do not let `conda init` rewrite this block.
export PATH="/opt/homebrew/anaconda3/condabin:$PATH"
conda() {
  unfunction conda
  eval "$('/opt/homebrew/anaconda3/bin/conda' 'shell.zsh' 'hook')"
  conda "$@"
}
# <<< conda initialize (lazy) <<<

export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# opencode (local AI TUI)
alias o="opencode"

# >>> sshh >>>
# Records ssh connections for `sshh`. Remove with: sshh uninstall
if (( $+commands[sshh] )); then
  autoload -Uz add-zsh-hook
  _sshh_record() {
    case "$1" in
      ssh\ *|mosh\ *) command sshh record -- "$1" 2>/dev/null ;;
    esac
  }
  add-zsh-hook preexec _sshh_record
fi
# <<< sshh <<<

# >>> machine-local overrides >>>
# This file is in a public git repo. Anything secret or machine-specific
# (API keys, work paths, client aliases) goes in ~/.zshrc.local, which is
# gitignored and never committed.
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
# <<< machine-local overrides <<<
