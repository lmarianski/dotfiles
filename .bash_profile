# .bash_profile

# Get the aliases and functions
[[ -f ~/.bashrc ]] && . ~/.bashrc

# User specific environment and startup programs
export GPG_TTY=$(tty)

## Unlock gnome keyring when logging thru SSH
if [ -n "$DESKTOP_SESSION" ];then
    eval $(gnome-keyring-daemon --start)
    export SSH_AUTH_SOCK
fi