#
# ~/.bashrc
#

export LESS_TERMCAP_mb=$'\033[01;31m'
export LESS_TERMCAP_md=$'\033[01;31m'
export LESS_TERMCAP_me=$'\033[0m'
export LESS_TERMCAP_se=$'\033[0m'
export LESS_TERMCAP_so=$'\033[01;44m'
export LESS_TERMCAP_ue=$'\033[0m'
export LESS_TERMCAP_us=$'\033[01;32m'
alias mancolor.unset='unset LESS_TERMCAP_mb LESS_TERMCAP_md LESS_TERMCAP_me LESS_TERMCAP_se LESS_TERMCAP_so LESS_TERMCAP_ue LESS_TERMCAP_us'

export EDITOR="nvim"
export TERMINAL="gnome-terminal"
export DIFFPROG="$EDITOR"
export GIT_EDITOR="$EDITOR"
export PAGER="less -x4 -RinS"

export _JAVA_OPTIONS='-Dfile.encoding=UTF-8 -Dawt.useSystemAAFontSettings=on -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
#export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
#export JAVA_FONTS=/usr/share/fonts/wenquanyi/wqy-microhei
export JAVA_FONTS=/usr/share/fonts/cantarell
export PATH="/home/icerupt/.nimble/bin:$PATH"


# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

