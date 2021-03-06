# Path to your oh-my-zsh installation.
  export ZSH=/home/patchouli/.oh-my-zsh

# oh-my-zsh bullshit
ZSH_THEME="dieter"
plugins=(git)
source $ZSH/oh-my-zsh.sh

#MPD bullshit
mpd
export MPD_HOST="/home/patchouli/.mpd/socket"
mpdscribble

# Cozy emacs client alias
alias emc="emacsclient -n"

# Shortcut to make with all cores
alias mkj="make -j8"

# Devkitpro exports for 3ds dev
export DEVKITPRO=/opt/devkitpro
export DEVKITARM=/opt/devkitpro/devkitARM
export DEVKITARM=/opt/devkitpro/devkitARM
