# Path to your oh-my-zsh installation.
  export ZSH=/home/patchouli/.oh-my-zsh

# oh-my-zsh bullshit
ZSH_THEME="dieter"
plugins=(git)
source $ZSH/oh-my-zsh.sh

#MPD bullshit
mpd
export MPD_HOST="~/.mpd/socket"
mpdscribble

# Cozy emacs client alias
alias emc="emacsclient -n"

# Devkitpro exports for 3ds dev
export DEVKITPRO=/opt/devkitpro
export DEVKITARM=/opt/devkitpro/devkitARM
export DEVKITARM=/opt/devkitpro/devkitARM
