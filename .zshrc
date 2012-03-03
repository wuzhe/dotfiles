#------------------------------------------------------------------#
# File:     .zshrc   ZSH resource file                             #
# Version:  0.1.16                                                 #
# Author:   Øyvind "Mr.Elendig" Heggstad <mrelendig@har-ikkje.net> #
#------------------------------------------------------------------#

#------------------------------
# History stuff
#------------------------------
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

#------------------------------
# Variables
#------------------------------
export EDITOR="em"
export PAGER="most"
export PATH="${HOME}/bin:${PATH}"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

if [[ $EMACS = "t" ]] then
   unsetopt zle  # turn off advanced line editting

   ls_pager=( cat ) # ls is simple piped to cat
   ls_flags=( -A )  # default ls flags
   export PAGER="cat"
fi

# java
#export JAVA_HOME="/usr/local/jdk1.6.0/jre"
#export JAVAVM_OPTS="-Djava.net.preferIPv4Stack=true"
#export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=lcd'
#export _JAVA_OPTIONS='-Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
#export JAVA_FONTS=/usr/share/fonts/TTF

#-----------------------------
# Dircolors
#-----------------------------
LS_COLORS='rs=0:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:';
export LS_COLORS

#------------------------------
# Keybindings
#------------------------------
bindkey -e
typeset -g -A key
#bindkey '\e[3~' delete-char
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
#bindkey '\e[2~' overwrite-mode
bindkey '^?' backward-delete-char
bindkey '^[[1~' beginning-of-line
bindkey '^[[5~' up-line-or-history
bindkey '^[[3~' delete-char
bindkey '^[[4~' end-of-line
bindkey '^[[6~' down-line-or-history
bindkey '^[[A' up-line-or-search
bindkey '^[[D' backward-char
bindkey '^[[B' down-line-or-search
bindkey '^[[C' forward-char
# for rxvt
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line

setopt AUTO_CD

#------------------------------
# Alias stuff
#------------------------------
#alias ls="gnuls --color -F"
#alias ll="gnuls --color -lh"
alias -g L="|$PAGER"
alias tmux="tmux -2"
#alias ec="emacsclient -t"

#-----------------------------
# Commands
#-----------------------------
eval `keychain --eval --agents ssh id_rsa`

#------------------------------
# Comp stuff
#------------------------------
zmodload zsh/complist
autoload -Uz compinit
compinit
zstyle :compinstall filename '${HOME}/.zshrc'

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always

zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*'   force-list always

#------------------------------
# Window title
#------------------------------
case $TERM in
    *xterm*|rxvt|rxvt-unicode|rxvt-256color|(dt|k|E)term)
		precmd () { print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~]\a" }
		preexec () { print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~] ($1)\a" }
	;;
    screen)
    	precmd () {
			print -Pn "\e]83;title \"$1\"\a"
			print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~]\a"
		}
		preexec () {
			print -Pn "\e]83;title \"$1\"\a"
			print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~] ($1)\a"
		}
	;;
esac

#------------------------------
# Prompt
#------------------------------
setprompt () {
	# load some modules
	autoload -U colors zsh/terminfo # Used in the colour alias below
	colors
	setopt prompt_subst

	# make some aliases for the colours: (coud use normal escap.seq's too)
	for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
		eval PR_$color='%{$fg[${(L)color}]%}'
	done
	PR_NO_COLOR="%{$terminfo[sgr0]%}"

	# Check the UID
	if [[ $UID -ge 1000 ]]; then # normal user
		eval PR_USER='${PR_GREEN}%n${PR_NO_COLOR}'
		eval PR_USER_OP='${PR_GREEN}\$${PR_NO_COLOR}'
	elif [[ $UID -eq 0 ]]; then # root
		eval PR_USER='${PR_RED}%n${PR_NO_COLOR}'
		eval PR_USER_OP='${PR_RED}%#${PR_NO_COLOR}'
	fi

	# Check if we are on SSH or not  --{FIXME}--  always goes to |no SSH|
	if [[ -z "$SSH_CLIENT"  &&  -z "$SSH2_CLIENT" && -z "$SSH_CONNECTION" && $UID == 1001 ]]; then
		eval PR_HOST='${PR_GREEN}%M${PR_NO_COLOR}' # no SSH
		PS1=$'${PR_BLUE}%~${PR_USER_OP}'
	else
		eval PR_HOST='${PR_YELLOW}%M${PR_NO_COLOR}' #SSH
		PS1=$'${PR_CYAN}[${PR_USER}${PR_CYAN}@${PR_HOST}${PR_CYAN}][${PR_BLUE}%~${PR_CYAN}]${PR_USER_OP}${PR_WHITE}'
	fi
	# set the prompt
	PS2=$'%_>'
}
setprompt
