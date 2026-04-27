# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

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
plugins=(
  git
  tmux
  vi-mode
  docker
  docker-compose
  ubuntu
  command-not-found
  sudo
  history-substring-search
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-bat
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

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

_ros_auto_source() {
  if [ -f "install/setup.zsh" ]; then
    source "install/setup.zsh"
    echo "[${ROS_DISTRO:-no-ROS}] ($PWD)"
  fi
}

chpwd() { _ros_auto_source; }

# Run on shell startup so new tmux panes/windows pick up the workspace
_ros_auto_source

# Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
export PATH="/home/linuxbrew/.linuxbrew/opt/node@22/bin:$PATH"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Zoxide
eval "$(zoxide init zsh)"

# Neovim
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
alias vi=nvim

# Starship
eval "$(starship init zsh)"

# Add Pip to PATH
export PATH=$HOME/.local/bin:$PATH

# Node.js
#export PATH="$HOME/.npm-global/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ROS
export ROS_DOAMIN_ID=0
## RVIZ2 FIX
export QT_SCREEN_SCALE_FACTORS=1
#export QT_FONT_DPI=144

## RMW
#export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
export RMW_IMPLEMENTATION=rmw_fastrtps_cpp
alias rolling='source /opt/ros/rolling/setup.zsh && echo "${ROS_DISTRO} activated"'
alias kilted='source /opt/ros/kilted/setup.zsh && echo "${ROS_DISTRO} activated"'
alias jazzy='source /opt/ros/jazzy/setup.zsh && echo "${ROS_DISTRO} activated"'

## RoboLabs
export CBOT_DEVICE_NAME="cbot_robot_01"
export CBOT_DEVICE_PASSWORD="1234"

# Wallpaper engine path
export PATH=$PATH:/opt/linux-wallpaperengine

# USE ROLLING FOR NOW
# source /opt/ros/rolling/setup.zsh
alias arduino="/home/sayed/arduino-ide_2.3.7_Linux_64bit/arduino-ide >/dev/null 2>&1 & disown"

export TERM=xterm-256color
