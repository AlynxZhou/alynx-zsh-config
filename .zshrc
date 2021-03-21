#!/bin/zsh

# Alynx Zhou <alynx.zhou@gmail.com> (https://alynx.one/)

# Note: If you use `~` in a string, it won't be treated as `${HOME}`, so use `${HOME}` in strings directly.

# Fix bug of new tab always starts shell with ~.
# https://bugs.launchpad.net/ubuntu-gnome/+bug/1193993
if [[ -f  "/etc/profile.d/vte.sh" ]]; then
	source /etc/profile.d/vte.sh
fi

# Load zsh profile.
if [[ -f "${HOME}/.zprofile" ]]; then
	source ${HOME}/.zprofile
fi

# Keymap.
# `-e` Emacs `-v` Vi
# Alynx loves Emacs keymap.
bindkey -e
# By default `Alt-h` is help.
# Alynx likes to use it to backward delete word.
bindkey "\eh" backward-delete-word
# `Up` / `Down` for searching history.
bindkey "\e[A" up-line-or-search
bindkey "\e[B" down-line-or-search
# `Left` / `Right`.
bindkey "\e[C" forward-char
bindkey "\e[D" backward-char
# `Alt-Left` / `Alt-Right`.
bindkey "\e[1;3C" forward-word
bindkey "\e[1;3D" backward-word
# `Home` / `End`.
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# `PageUp` / `PageDown`.
bindkey "\e[5~" up-line-or-history
bindkey "\e[6~" down-line-or-history
# Alynx wants to add sudo via hit `Esc` twice.
function add_sudo() {
	[[ -z ${BUFFER} ]] && zle up-history
	[[ ${BUFFER} != sudo\ * ]] && BUFFER="sudo ${BUFFER}"
	# Move to end of line.
	zle end-of-line
}
zle -N add_sudo
bindkey "\e\e" add_sudo

# Alynx likes to set history file name to `~/.zhistory`.
HISTFILE="${HOME}/.zhistory"
# Max history file size.
HISTSIZE=100000
# Max history record number.
SAVEHIST=10000

# Enable autocurrect.
setopt correct
# Share history between different zsh instances.
setopt append_history
setopt share_history
# Only keep one record for continuous same record.
setopt hist_save_no_dups
setopt hist_ignore_dups
# Ignore record starting with space.
setopt hist_ignore_space
# Add timestamp for history.
setopt extended_history
# Use `cd -TAB` to enter history path.
setopt auto_pushd
# Enter directory without `cd`.
setopt autocd
# Only keep one record for continuous same history path.
setopt pushd_ignore_dups
# Support `cd -NUM`.
setopt pushd_minus
# Use enhanced glob.
setopt extended_glob
# Don't change priority for background commands.
setopt no_bg_nice
# Pass `*` to program when no file matches it.
setopt no_nomatch
# Disable beep.
unsetopt beep
# Complete full path by alpha. `/v/c/p/p` => `/var/cache/pacman/pkg`.
setopt complete_in_word
# Complete parameter like `identifier=path`.
setopt magic_equal_subst
# Allow to use functions in prompt.
setopt prompt_subst
# Allow comments in interactive mode.
setopt interactive_comments
# Treat them as a part of word.
WORDCHARS="*?_-[]~=&;!#$%^(){}<>"
setopt auto_list
setopt auto_menu
# Disable selecting menu item while completing.
# setopt menu_complete
# Allow different column weight.
setopt listpacked
# Continue job after disown.
setopt auto_continue
# Treat `#`, `~` and `^` characters as patterns for filename generation.
setopt extended_glob
# Only display newest RPROMPT, which makes copy easier.
setopt transient_rprompt
# Display all options with status when call `setopt`.
setopt ksh_option_print

# Color.
# Set it as environment variables.
export ZLSCOLORS=${LS_COLORS}
autoload -U colors && colors

# Autocomplete.
zstyle :compinstall filename "${HOME}/.zshrc"
autoload -Uz compinit && compinit

# Autocomplete settings.
# Set complete colors.
zstyle ":completion:*" rehash true
zstyle ":completion:*" verbose yes
zstyle ":completion:*" menu select
zstyle ":completion:*:*:default" force-list always
zstyle ":completion:*" select-prompt "%SSelect:  lines: %L  matches: %M  [%p]"
zstyle ":completion:*:match:*" original only
zstyle ":completion::prefix-1:*" completer _complete
zstyle ":completion:predict:*" completer _complete
zstyle ":completion:incremental:*" completer _complete _correct
zstyle ":completion:*" completer _complete _prefix _correct _prefix _match _approximate
# Path autocomplete.
zstyle ":completion:*" expand "yes"
zstyle ":completion:*" squeeze-slashes "yes"
zstyle ":completion::complete:*" "\\"
# Set complete colors.
zmodload zsh/complist
zstyle ":completion:*" list-colors ${(s.:.)LS_COLORS}
# Cap correct.
zstyle ":completion:*" matcher-list "" "m:{a-zA-Z}={A-Za-z}"
# Mistake correct.
zstyle ":completion:*" completer _complete _match _approximate
zstyle ":completion:*:match:*" original only
zstyle ":completion:*:approximate:*" max-errors 1 numeric
# Group complete items.
zstyle ":completion:*:matches" group "yes"
zstyle ":completion:*" group-name ""
zstyle ":completion:*:options" description "yes"
zstyle ":completion:*:options" auto-description "%d"
zstyle ":completion:*:descriptions" format "%F{cyan}%B-- %d --%b%f"
zstyle ":completion:*:messages" format "%F{purple}%B-- %d --%b%f"
zstyle ":completion:*:warnings" format "%F{red}%B-- No Matches Found --%b%f"
zstyle ":completion:*:corrections" format "%F{green}%B-- %d (errors: %e) --%b%f"
# kill complete.
zstyle ":completion:*:*:kill:*:processes" list-colors "=(#b) #([0-9]#)*=0=01;31"
zstyle ":completion:*:*:kill:*" menu yes select
zstyle ":completion:*:*:*:*:processes" force-list always
zstyle ":completion:*:processes" command "ps -au${USER}"
# cd ~ complete sequence.
zstyle ":completion:*:-tilde-:*" group-order "named-directories" "path-directories" "users" "expand"

# Restore tty status.
# ttyctl -f

# Prompt settings.
# Last command result.
# Zero prints nothing. Non-zero prints red number.
local result_status=%(?::":%F{red}%?%f")

# OS detection.
function os_status() {
	if [[ -n ${SSH_CONNECTION} ]]; then
		print -n "%F{blue}(ssh)%f%F{yellow}$(command uname)%f:"
	else
		print -n "%F{yellow}$(command uname)%f:"
	fi
	return 0
}

# Battery.
# Warning: For the prompt will only refresh by pressing <ENTER>, the battery showing maybe not right.
function battery_status() {
	if [[ -f "/sys/class/power_supply/BAT0/capacity" ]]; then
		local BATTERY=$(command cat /sys/class/power_supply/BAT0/capacity 2> /dev/null)
		print -n "%F{green}${BATTERY}%%%f:"
		return ${BATTERY}
	fi
	return 0
}

# Git status.
function git_status() {
	# Check for git repo.
	if [[ -n $(command git rev-parse --short HEAD 2> /dev/null) ]]; then
		# Check for dirty or not.
		if [[ -n $(command git status --porcelain --ignore-submodules=dirty 2> /dev/null | command tail -n1) ]]; then
			print -n ":%F{blue}$(command git symbolic-ref --short HEAD 2> /dev/null)%f%F{yellow}*%f"
			return 1
		else
			print -n ":%F{blue}$(command git symbolic-ref --short HEAD 2> /dev/null)%f"
			return 0
		fi
	fi
	return -1
}

## Background jobs.
function jobs_status() {
	local JOBS=$(jobs -l | command wc -l)
	if [[ ${JOBS} -ne 0 ]]; then
		print -n ":%F{green}${JOBS}&%f"
		return ${JOBS}
	fi
	return 0
}

# Prompt.
# Alynx prefers to use only left prompt.
# Here is the LEFT PROMPT containing username `%n`, hostname `%m`, directory `%~`, git `$(git_status)`, jobs `$(jobs_status)`, result `${result_status}` and the `%#`.
PROMPT='[%F{red}%n%f@%F{cyan}%m%f:%F{yellow}%~%f$(git_status)$(jobs_status)${result_status}] %# '
# Here is the RIGHT PROMPT containing battery `$(battery_status)`, os `$(os_status)`, date `%D{%Y-%m-%d}` and time `%D{%H:%M:%S}`.
RPROMPT='[$(battery_status)$(os_status)%F{cyan}%D{%Y-%m-%d} %D{%H:%M:%S}%f]'

# Terminal title.
# Because terminal don't know what `%n@%m:%~` is, we need to use `print -P`, it will parse them then pass result to title.
case $TERM in
	xterm*|rxvt*|(dt|k|E)term|termite|gnome*|alacritty)
		function precmd() {
			# vcs_info
			print -Pn "\e]0;%n@%M:%~\a"
		}
		function preexec() {
			print -Pn "\e]0;${1}\a"
		}
	;;
	screen*)
		function precmd() {
			# vcs_info
			print -Pn "\e]83;title \"${1}\"\a"
			print -Pn "\e]0;$TERM - (%L) %n@%M:%~\a"
		}
		function preexec() {
			print -Pn "\e]83;title \"${1}\"\a"
			print -Pn "\e]0;$TERM - (%L) %n@%M:%~\a"
		}
	;;
esac

# Alias.
alias editconfig="${EDITOR} ${HOME}/.zshrc"
alias loadconfig="source ${HOME}/.zshrc"

if [[ -f "/bin/ls" ]]; then
	alias l="ls -l --all --human-readable --group-directories-first --color=auto"
fi
if [[ -f "/bin/exa" ]]; then
	alias e="exa --all --long --header --git --group-directories-first --color=auto"
fi

# bat display tab as 4 spaces by default, which is bad because it's a viewer instead of editor.
if [[ -f "/bin/bat" ]]; then
	alias bat="bat --tabs=0"
fi

if [[ -f "/bin/vim" ]]; then
	alias vi="vim"
elif [[ -f "/bin/nvim" ]]; then
	alias vi="nvim"
fi
if [[ -f "/bin/emacsclient" ]]; then
	alias eg="emacsclient -c -a \"\""
	alias ec="emacsclient -nw -c -a \"\""
fi

if [[ -f "/bin/rsync" ]]; then
	alias xsync="rsync -avihHAXKPS --delete"
fi

if [[ -f "/bin/gcc" ]]; then
	alias gcc11="gcc -std=c11"
fi
if [[ -f "/bin/clang" ]]; then
	alias clang11="clang -std=c11"
fi

if [[ -f "/bin/diff" ]]; then
	alias diffu="diff --unified --recursive --text --new-file --color"
fi
# Use `-i` here so we can append patch file name directly.
if [[ -f "/bin/patch" ]]; then
	alias patchp="patch --no-backup-if-mismatch --forward --strip=1 -i"
fi

# A beautiful git log.
if [[ -f "/bin/git" ]]; then
	git config --global alias.graph "log --graph --abbrev-commit --decorate --date=iso8601 --format=format:'%C(bold blue)%h%C(reset) %C(white)%s%C(reset) %C(dim white)<%ae>%C(reset) %C(bold green)(%ad)%C(reset) %C(auto)%d%C(reset)'"
fi

# Pacman alias.
if [[ -f "/bin/pacman" ]]; then
	alias spacs="sudo pacman -S"
	alias spacr="sudo pacman -Rns"
	alias spacu="sudo pacman -U"
	alias pacfs="pacman -F"
	alias pacss="pacman -Ss"
	alias spacsyu="sudo pacman -Syyu"
	alias spacsyy="sudo pacman -Syy"
fi

# Systemd alias.
if [[ -f "/bin/systemctl" ]]; then
	# Let the pager away.
	alias systemctl="systemctl --no-pager --full"
	alias journalctl="journalctl --no-pager --full"
	alias ssctlen="sudo systemctl --no-pager --full enable"
	alias ssctlnowen="sudo systemctl --no-pager --full --now enable"
	alias ssctldis="sudo systemctl --no-pager --full disable"
	alias ssctlnowdis="sudo systemctl --no-pager --full --now disable"
	alias ssctlstart="sudo systemctl --no-pager --full start"
	alias sctlstatus="systemctl --no-pager --full status"
	alias ssctlstatus="sudo systemctl --no-pager --full status"
	alias ssctlstop="sudo systemctl --no-pager --full stop"
	alias ssctlre="sudo systemctl --no-pager --full restart"
	alias jctlb0="journalctl --no-pager --full --boot=0"
	alias sjctlb0="sudo journalctl --no-pager --full --boot=0"
	alias jctlb1="journalctl --no-pager --full --boot=-1"
	alias sjctlb1="journalctl --no-pager --full --boot=-1"
fi

# Syntax highlight.
if [[ -f "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
	source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
# Autosuggestions.
if [[ -f "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
	source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Load per-machine custom config.
if [[ -f "${HOME}/.zcustom" ]]; then
	source ${HOME}/.zcustom
fi
