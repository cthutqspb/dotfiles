# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
#export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="spaceship"

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
#plugins=(
#    git
#    archlinux
#    branch
#    colorize
#    #composer
#    docker
#    docker-compose
#    emoji
#    npm
#    #pip
#)

#source $ZSH/oh-my-zsh.sh

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
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


#Custom

#git
alias ls='ls --color=auto'
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
############

autoload -Uz add-zsh-hook


parse_node_version(){
    node_v=$(node -v 2> /dev/null)   
}

add-zsh-hook precmd parse_node_version

[ ${ZSH_VERSION} ] && precmd() { prompt_command; }
[ ${BASH_VERSION} ] && PROMPT_COMMAND=prompt_command

# colors for ls
if [[ -f ~/.dir_colors ]] ; then
    eval $(dircolors -b ~/.dir_colors)
elif [[ -f /etc/DIR_COLORS ]] ; then
    eval $(dircolors -b /etc/DIR_COLORS)
fi

case "$TERM" in
    xterm-color|*-256color|xterm-kitty) color_prompt=yes;;
esac


prompt_command() { 

    if [ ${ZSH_VERSION} ]; then
    # Zsh prompt expansion syntax
    #PS1='%{%F{red}%}%n%{%f%}@%{%F{red}%}%m %{%F{cyan}%}%~ %{%F{white}%}%# %{%f%}'
        PS1='%F{8}┌──%F{blue} %m%f %F{cyan} %n%f %F{103} %~%f ${vcs_info_msg_0_} %F{2} ${node_v}
%F{8}└─$%F{white} ' 
    elif [ ${BASH_VERSION} ]; then
    # Bash prompt expansion syntax
            PS1="\[\e[3${HOSTCOLOR}m\] \h  \[\e[3${USERCOLOR}m\] \u  \[\e[3${PATHCOLOR}m\] \w  \[\e[3${TEXTCOLOR}m\]$ ";   
    fi   
}
zstyle ':vcs_info:git:*' formats '%F{190} %F{245}[%F{23}%b%F{245}]%f'
zstyle ':vcs_info:*' stagedstr '%F{green}•'
zstyle ':vcs_info:*' unstagedstr '%F{yellow}•'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' enable git svn


source /usr/share/nvm/init-nvm.sh
export EDITOR=/usr/bin/nvim
export LANG=ru_RU.UTF-8

LS_COLORS='no=00;37:fi=00:di=00;33:ln=04;36:pi=40;33:so=01;35:bd=40;33;01:'
export LS_COLORS
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*' menu yes select
autoload -Uz compinit
compinit

#History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory


# Hyprland
if uwsm check may-start && uwsm select; then
	exec systemd-cat -t uwsm_start uwsm start default
fi

#export STARSHIP_CONFIG=~/.config/starship/starship.toml
#eval "$(starship init zsh)"
