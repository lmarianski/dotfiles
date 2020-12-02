# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# User specific environment

export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache

export RUBY_VER=2.6.0
export ANDROID_HOME=/opt/android-sdk/
export ANDROID_PATH=${ANDROID_HOME}emulator:${ANDROID_HOME}tools/bin:${ANDROID_HOME}platform-tools/:${ANDROID_HOME}tools/
export JAVA_HOME=/usr/lib/jvm/default
export GOPATH=$HOME/go

#export KEYBASE=$(keybase config get -b mountdir)

export PATH="$HOME/.local/bin:$HOME/bin:$PATH:$HOME/scripts:/usr/local/bin:$HOME/.gem/ruby/${RUBY_VER}/bin:${ANDROID_PATH}:$HOME/.npm/bin:$GOPATH/bin:$PATH"

export PATH="$HOME/.node_modules/bin:$PATH"

# User specific aliases and functions

#alias rm=trash
alias ls='ls --color=auto'
alias clip="xclip -sel clipboard"
alias sn="java -jar $HOME/Dokumenty/Projects/sn/out/artifacts/sn_jar/sn.jar "
#alias "yarn berry"="yarn set version berry"

mkdir -p /tmp/makepkg
export MAKEFLAGS=-j12
export BUILDDIR=/tmp/makepkg

###-tns-completion-start-###
if [ -f $HOME/.tnsrc ]; then 
    source $HOME/.tnsrc 
fi
###-tns-completion-end-###

#eval $(kompose completion bash)

# added by travis gem
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh

[ -f /usr/share/nvm/init-nvm.sh ] && source /usr/share/nvm/init-nvm.sh

# Prompt Customization

#
# Run 'nvm use' automatically every time there's 
# a .nvmrc file in the directory. Also, revert to default 
# version when entering a directory without .nvmrc
#
source /usr/share/nvm/init-nvm.sh

enter_directory() {
	if [[ $PWD == $PREV_PWD ]]; then
	    return
	fi

	PREV_PWD=$PWD
	if [[ -f ".nvmrc" ]]; then
	    nvm use
	    NVM_DIRTY=true
	elif [[ $NVM_DIRTY = true ]]; then
	    nvm use default
	    NVM_DIRTY=false
	fi
}

export PROMPT_COMMAND=enter_directory
PS1='[\u@\h \W]\$ '

