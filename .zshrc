# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# bat 0.25+ defaults to --theme=auto: it asks the terminal for its background
# colour on every invocation and picks --theme-light/--theme-dark from
# ~/.config/bat/config. Ghostty follows the GNOME appearance setting, so bat
# follows it too -- live, in already-open shells.
#
# The distrobox containers ship bat 0.24 (as `batcat`), which knows neither
# --theme-light/--theme-dark -- so it aborts on *every* invocation while reading
# that config -- nor the built-in Catppuccin themes. In those shells fall back to
# a flag-free config and the closest theme 0.24 actually ships. 0.24 has no
# auto-detection either, hence the one-shot theme-mode query.
() {
  local bat_bin
  for bat_bin in bat batcat; do
    command -v "$bat_bin" >/dev/null || continue
    if ! BAT_CONFIG_PATH=/dev/null "$bat_bin" --help 2>/dev/null | grep -q -- '--theme-light'; then
      export BAT_CONFIG_PATH="$HOME/.config/bat/config-legacy"
      if [[ "$(theme-mode 2>/dev/null)" == light ]]; then
        export BAT_THEME="OneHalfLight"
      else
        export BAT_THEME="OneHalfDark"
      fi
    fi
    break
  done
}

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

# Edit the current command line in $EDITOR. zsh's emacs keymap has ^X^E bound
# to this by default, but vi-mode (plugin below) makes viins/vicmd the active
# keymaps, where it isn't bound — so bind it there too. vi-mode already gives
# 'vv' in normal mode; this adds the familiar bash/readline chord alongside it.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M viins '^x^e' edit-command-line
bindkey -M vicmd '^x^e' edit-command-line

# tmux 3.4 does not forward an OSC 11 background query to the outer terminal --
# it answers from a value cached when the client attached -- so bat's
# auto-detection is stale inside a session and it falls back to the dark theme.
# Ask GNOME directly instead, per invocation, and only under tmux; outside it
# bat's own detection is live and correct.
if [[ -n $TMUX ]]; then
  bat() { BAT_THEME=$(theme-mode) command bat "$@"; }
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

# eza paints documents green by default, too close to the bold green it uses
# for executables. Leave them uncoloured instead.
export EZA_COLORS="*.pdf=0:*.epub=0:*.djvu=0"

alias vi=nvim
alias ls=eza
alias prime-run='__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia'

# ── distrobox helpers ─────────────────────────────────────────────────────────
# Same .zshrc runs on both sides ($HOME is bind-mounted), so each side only gets
# the alias that makes sense there.
if [[ -z $CONTAINER_ID ]]; then
  # Host → container. distrobox keeps the current directory.
  alias jazzy='distrobox enter jazzy'

  # Auto-enter jazzy whenever cd lands in a built ROS2 workspace. Same
  # install/setup.zsh marker and upward walk as _ros_auto_source below, just
  # run from the host side. No once-per-session guard: every cd back into a
  # matching dir re-enters, even right after exiting.
  # _distrobox_auto_enter() {
  #   local dir=$PWD
  #   while true; do
  #     if [[ -f $dir/install/setup.zsh ]]; then
  #       # print -P "%F{cyan}[distrobox]%f ${dir:t}: entering jazzy"
  #       distrobox enter jazzy
  #       return
  #     fi
  #     [[ $dir == / ]] && break
  #     dir=${dir:h}
  #   done
  # }
  # autoload -Uz add-zsh-hook
  # add-zsh-hook chpwd _distrobox_auto_enter
  # _distrobox_auto_enter          # fire for the directory the shell starts in
else
  # Container: arm NVIDIA offload for Gazebo/RViz
  # source ~/.config/distrobox/sim-env.sh
  # local _r=$(glxinfo -B 2>/dev/null | awk -F': ' '/OpenGL renderer/{print $2}')

  # Container-only nvim: the Fedora /usr/bin/nvim is built against glibc 2.43 and
  # cannot run here (Ubuntu 24.04 has 2.39). Host PATH is untouched.
  path=($HOME/.local/opt/nvim-jazzy/bin $path)
fi

# fzf shell integration. `fzf --zsh` arrived in 0.48; the Fedora host has 0.74,
# but the distrobox (Ubuntu 24.04) ships 0.44, which installs the scripts to
# /usr/share/doc/fzf/examples instead. Pick whichever this machine supports.
if fzf --zsh >/dev/null 2>&1; then
  ## Fedora fzf 0.74
  source <(fzf --zsh)
else
  ## Ubuntu24 fzf 0.44
  for _fzf_f in /usr/share/doc/fzf/examples/key-bindings.zsh \
                /usr/share/doc/fzf/examples/completion.zsh; do
    [[ -r $_fzf_f ]] && source "$_fzf_f"
  done
  unset _fzf_f
fi
source ~/.local/share/fzf-git/fzf-git.sh
eval "$(starship init zsh)"

# ── ROS 2 workspace auto-source (distrobox only) ──────────────────────────────
# $HOME is bind-mounted into the distrobox container, so this same .zshrc is read
# on the Fedora host as well. CONTAINER_ID is set by distrobox-enter and is empty
# on the host, which keeps ROS off the host shell entirely.
if [[ -n $CONTAINER_ID ]]; then
  _ros_auto_source() {
    local dir=$PWD
    while true; do
      if [[ -f $dir/install/setup.zsh ]]; then
        # Same workspace as last time — nothing to do.
        [[ $dir == $_ROS_SOURCED_WS ]] && return
        # ROS overlays cannot be unsourced; layering a second workspace on top of
        # a live one silently shadows packages. Warn instead of stacking.
        if [[ -n $_ROS_SOURCED_WS ]]; then
          print -P "%F{yellow}[ros]%f ${dir:t}: ${_ROS_SOURCED_WS:t} already sourced — open a new shell"
          return
        fi
        source "$dir/install/setup.zsh"
        _ROS_SOURCED_WS=$dir
        # print -P "%F{green}[${ROS_DISTRO:-no-ROS}]%f ${dir:t}"
        return
      fi
      [[ $dir == / ]] && break
      dir=${dir:h}
    done
  }
  autoload -Uz add-zsh-hook
  add-zsh-hook chpwd _ros_auto_source
  _ros_auto_source          # fire for the directory the shell starts in
fi

# >>> scrcpy >>>
# scrcpy 4.1 portable build lives in ~/.local/opt/scrcpy-linux-x86_64-v4.1/,
# symlinked into ~/.local/bin (both `scrcpy` and its bundled `adb`). The
# directory must stay intact -- scrcpy finds `scrcpy-server` next to the binary.

alias phone='scrcpy'                            # mirror the phone screen
alias phone-cams='scrcpy --list-cameras'        # list camera ids + facing
alias phone-camsizes='scrcpy --list-camera-sizes'

# Phone camera as a standalone window. Defaults to the BACK camera, no audio.
#
# Usage: phonecam [front|back|external] [0|90|180|270|flipN] [mic] [scrcpy args...]
#   phonecam              back camera, upright
#   phonecam 90           back camera, rotated 90 clockwise
#   phonecam front        front (selfie) camera
#   phonecam front flip0  front camera, mirrored like a webcam preview
#   phonecam mic          back camera + phone microphone audio
#   phonecam --camera-size=1920x1080 --camera-fps=60
#
# Rotation here is --capture-orientation: it rotates the captured stream, so a
# recording or a v4l2 sink comes out rotated too. Use --orientation=N instead
# if you only want the window on screen turned and the stream left alone.
phonecam() {
  local facing=back rot=0 audio=(--no-audio) a extra=()
  for a in "$@"; do
    case "$a" in
      front|back|external)                                  facing=$a ;;
      0|90|180|270|flip0|flip90|flip180|flip270)            rot=$a ;;
      mic)                                                  audio=(--audio-source=mic-camcorder) ;;
      *)                                                    extra+=("$a") ;;
    esac
  done
  scrcpy --video-source=camera \
         --camera-facing="$facing" \
         --capture-orientation="$rot" \
         "${audio[@]}" "${extra[@]}"
}

alias phone-apps='scrcpy --list-apps'          # list installed package names

# Launch one app in its own window, on a NEW virtual display: the app appears
# only here, and the phone's own screen stays free and independent.
#
# Usage: phoneapp <package|?partial-name> [WxH[/dpi]] [scrcpy args...]
#   phoneapp com.spotify.music
#   phoneapp ?spotify                 match by app name, case-insensitive
#   phoneapp ?maps 1280x800/240       explicit window size and density
#
# The app is force-stopped first (the '+' prefix), since an app already running
# on the phone's display will not move to the virtual one on its own.
scrcpy_app() {
  local app=$1; shift
  if [[ -z $app ]]; then
    print -u2 "usage: phoneapp <package|?partial-name> [WxH[/dpi]] [scrcpy args...]"
    print -u2 "       phone-apps   # to list package names"
    return 2
  fi
  local disp=--new-display
  if [[ $1 == (<->x<->|<->x<->/<->|/<->) ]]; then
    disp="--new-display=$1"; shift
  fi
  scrcpy "$disp" --start-app="+$app" --no-audio "$@"
}

# Same, but on the phone's real screen (mirrors what the phone is showing).
scrcpy_app_main() {
  [[ -n $1 ]] || { print -u2 "usage: phoneapp-main <package|?partial-name>"; return 2 }
  local app=$1; shift
  scrcpy --start-app="+$app" "$@"
}

# noglob: so a '?partial-name' argument is not eaten by zsh globbing.
alias phoneapp='noglob scrcpy_app'
alias phoneapp-main='noglob scrcpy_app_main'

alias phonecam-front='phonecam front'
alias phonecam-back='phonecam back'
# <<< scrcpy <<<

# Keep zoxide's init last: it registers its own chpwd hook and warns if anything
# else is appended after it.
eval "$(zoxide init zsh --cmd cd)"

# opencode
export PATH=/home/sayed/.opencode/bin:$PATH

# distrobox: $TMUX is inherited from the host environment, but the host's tmux
# socket is not reachable from inside the container. Plugins that shell out to
# tmux (vim-tmux-navigator) therefore believe they are under tmux, fail the
# call silently, and do nothing at all -- e.g. <C-h/j/k/l> stops switching nvim
# splits. Clearing $TMUX makes them take their non-tmux fallback path (plain
# `wincmd`), which is the correct behaviour inside a container.
#
# Guarded on the socket named in $TMUX actually existing, so this is a no-op in
# a real tmux session on the host and does not disturb tmux integration there.
if [[ -n $TMUX && ! -S ${TMUX%%,*} ]]; then
  unset TMUX
fi
