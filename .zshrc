#!/bin/zsh

# Alynx Zhou <alynx.zhou@gmail.com> (https://alynx.one/)

# Note: If you use `~` in a string, it won't be treated as `${HOME}`, so use
# `${HOME}` in strings directly.

# Fix bug of new tab always starts shell with home.
# https://bugs.launchpad.net/ubuntu-gnome/+bug/1193993
if [[ -f  "/etc/profile.d/vte.sh" ]]; then
	source /etc/profile.d/vte.sh
fi

# Load zsh profile.
if [[ -f "${HOME}/.zprofile" ]]; then
	source "${HOME}/.zprofile"
fi

# Keymap.
# `-e` is Emacs and `-v` is Vi.
# Alynx loves Emacs keymap.
bindkey -e
# By default `Alt-h` is help.
# Alynx likes to use it to backward kill word.
# Use `backward-kill-word` instead of `backward-delete-word`, because it follows
# `select-word-style`.
bindkey "\eh" backward-kill-word
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
# Alynx wants to add `sudo` via hit `Esc` twice.
function add_sudo() {
	[[ -z ${BUFFER} ]] && zle up-history
	[[ ${BUFFER} != "sudo "* ]] && BUFFER="sudo ${BUFFER}"
	zle end-of-line
}
zle -N add_sudo
bindkey "\e\e" add_sudo
# Alynx wants to add `v2env` via hit `Esc` three times.
function add_v2env() {
	[[ -z ${BUFFER} ]] && zle up-history
	[[ ${BUFFER} != "v2env "* ]] && BUFFER="v2env ${BUFFER}"
	zle end-of-line
}
zle -N add_v2env
bindkey "\e\e\e" add_v2env

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
#WORDCHARS="*?_-[]~=&;!#$%^(){}<>"
# Interestingly, Emacs only treats those as words.
WORDCHARS="$%"
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

# Treat the whole quoted string as word, this is useful on handling long
# arguments like URL.
autoload -U select-word-style && select-word-style shell

# Color.
# Set it as environment variables.
if command -v "dircolors" &> /dev/null; then
	eval $(dircolors -b)
fi
autoload -U colors && colors
# Make Emacs use 24-bit color in SSH.
if [[ -n ${SSH_CONNECTION} ]]; then
	export COLORTERM="truecolor"
fi

# Autocomplete.
# Load Homebrew completions.
if command -v "brew" &> /dev/null; then
	FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi
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
# Kill complete.
zstyle ":completion:*:*:kill:*:processes" list-colors "=(#b) #([0-9]#)*=0=01;31"
zstyle ":completion:*:*:kill:*" menu yes select
zstyle ":completion:*:*:*:*:processes" force-list always
zstyle ":completion:*:processes" command "ps -au${USER}"
# `cd ~` complete sequence.
zstyle ":completion:*:-tilde-:*" group-order "named-directories" "path-directories" "users" "expand"

# Restore tty status.
# ttyctl -f

# Prompt functions.
# We don't pass `-P` to `print` for prompt functions, we generate a string with
# prompt escaping sequences and let zsh handle them.

# Last command result.
# Zero prints nothing. Non-zero prints red number.
local result_status=%(?::":%F{red}%?%f")

# OS.
function os_status() {
	if [[ -n ${SSH_CONNECTION} ]]; then
		print -n "%F{yellow}$(command uname)%f%F{blue}(ssh)%f:"
	else
		print -n "%F{yellow}$(command uname)%f:"
	fi
	return 0
}

# Battery.
# Warning: Because the prompt will only refresh by pressing Enter, the battery
# percent maybe not precious.
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
# Single quote is required to do variable expansion, double quote won't work.
# Here is the LEFT PROMPT containing username `%n`, hostname `%m`, directory
# `%~`, git `$(git_status)`, jobs `$(jobs_status)`, result `${result_status}`
# and the `%#`.
PROMPT='[%F{red}%n%f@%F{cyan}%m%f:%F{yellow}%~%f$(git_status)$(jobs_status)${result_status}] %# '
# Here is the RIGHT PROMPT containing battery `$(battery_status)`, OS
# `$(os_status)`, date `%D{%Y-%m-%d}` and time `%D{%H:%M:%S}`.
RPROMPT='[$(battery_status)$(os_status)%F{cyan}%D{%Y-%m-%d} %D{%H:%M:%S}%f]'

# Command hooks.
typeset -a precmd_functions
typeset -a preexec_functions

# Cursor.
# Some programs like Neovim don't restore cursor shape after exiting.
function reset_cursor() {
	# Set cursor style (DECSCUSR), VT520:
	#
	# - 0: Blinking block.
	# - 1: Blinking block (default).
	# - 2: Steady block.
	# - 3: Blinking underline.
	# - 4: Steady underline.
	# - 5: Blinking bar, xterm.
	# - 6: Steady bar, xterm.
	print -n "\e[4 q"
}
precmd_functions+=(reset_cursor)

# Terminal title.
# Because terminal don't know what `%n@%m:%~` is, we need to use `print -P`, it
# will do prompt expansion.
case "${TERM}" in
	xterm*|rxvt*|(dt|k|E)term|termite|gnome*|alacritty)
		function precmd_prompt() {
			print -Pn "\e]0;%n@%M:%~\a"
		}
		function preexec_command() {
			print -Pn "\e]0;${1}\a"
		}
		precmd_functions+=(precmd_prompt)
		preexec_functions+=(preexec_command)
	;;
	screen*)
		function precmd_prompt() {
			print -Pn "\e]83;title \"${1}\"\a"
			print -Pn "\e]0;${TERM} - (%L) %n@%M:%~\a"
		}
		function preexec_command() {
			print -Pn "\e]83;title \"${1}\"\a"
			print -Pn "\e]0;${TERM} - (%L) %n@%M:%~\a"
		}
		precmd_functions+=(precmd_prompt)
		preexec_functions+=(preexec_command)
	;;
esac

# Alias.
if [[ -z ${VISUAL} ]]; then
	alias editconfig="${EDITOR} ${HOME}/.zshrc"
else
	alias editconfig="${VISUAL} ${HOME}/.zshrc"
fi
alias loadconfig="source ${HOME}/.zshrc"

if command -v "ls" &> /dev/null; then
	alias ls="ls --group-directories-first"
	alias l="ls -l --all --human-readable --group-directories-first --color=auto"
fi
if command -v "exa" &> /dev/null; then
	alias exa="exa --group-directories-first"
	alias e="exa --all --long --header --git --group --group-directories-first --color=auto"
fi

# `bat` display tab as 4 spaces by default, which is bad because it's a viewer
# instead of an editor.
if command -v "bat" &> /dev/null; then
	alias bat="bat --tabs=0"
fi

if command -v "bat" &> /dev/null; then
	alias headn30="head --lines=30"
fi

if command -v "vim" &> /dev/null; then
	alias vi="vim"
elif command -v "nvim" &> /dev/null; then
	alias vi="nvim"
fi
if command -v "emacsclient" &> /dev/null; then
	# Always create new frame. I hardly use Emacs without GUI.
	alias ec="emacsclient --create-frame --alternate-editor="
fi

if command -v "rsync" &> /dev/null; then
	function rsync-trim() {
		local new_args=()
		for i in ${@}; do
			# We don't want to make root empty.
			if [[ "${i}" != "/" ]]; then
				# Trim the last slash.
				i="${i%/}"
			fi
			new_args+=("${i}")
		done
		rsync ${new_args[@]}
	}
	# Don't use `--delete`, it will delete files that do not exist in source
	# dir but exist in destination dir. Which is really bad for merge
	# different sources into a single destination.
	#
	# Don't use `--sparse`, especially on a 10GbE link, it will decrase
	# speed to half.
	#
	# Don't use `--append`, it's not for `--partial` and could be dangerous!
	#
	# `-P` means `--partial --progress`, `--partial` will keep incomplete
	# files and will continue them next time.
	#
	# When syncing to Samba share, do not keep xattrs (`-X`).
	alias xsync="rsync-trim -ahivAHKPX --info=progress2"
	alias xsyncx="rsync-trim -ahivAHKP --info=progress2"
	alias csync="rsync-trim -achivAHKPX --info=progress2"
	alias csyncx="rsync-trim -achivAHKP --info=progress2"
fi

if command -v "gcc" &> /dev/null; then
	alias gcc11="gcc -std=c11"
fi
if command -v "clang" &> /dev/null; then
	alias clang11="clang -std=c11"
fi

if command -v "diff" &> /dev/null; then
	alias diffu="diff --unified --recursive --text --new-file --color"
fi
if command -v "patch" &> /dev/null; then
	alias patchp="patch --no-backup-if-mismatch --forward --strip=1"
fi

# Some programs does not use libc, so proxychains won't work on them (like Go),
# and they don't accept socks5 protocol in ENVs. I first use privoxy to turn
#socks5 proxy into http proxy, and use an alias to declare all related ENVs.
if command -v "privoxy" &> /dev/null; then
	alias proxyenv="http_proxy=\"http://127.0.0.1:8118\" \
https_proxy=\"http://127.0.0.1:8118\" \
ftp_proxy=\"http://127.0.0.1:8118\" \
rsync_proxy=\"http://127.0.0.1:8118\" \
no_proxy=\"localhost,127.0.0.1,localaddress,.localdomain\""
	alias prenv="http_proxy=\"http://127.0.0.1:8118\" \
https_proxy=\"http://127.0.0.1:8118\" \
ftp_proxy=\"http://127.0.0.1:8118\" \
rsync_proxy=\"http://127.0.0.1:8118\" \
no_proxy=\"localhost,127.0.0.1,localaddress,.localdomain\""
fi
if command -v "v2raya" &> /dev/null; then
	alias v2rayaenv="http_proxy=\"http://127.0.0.1:20171\" \
https_proxy=\"http://127.0.0.1:20171\" \
ftp_proxy=\"http://127.0.0.1:20171\" \
rsync_proxy=\"http://127.0.0.1:20171\" \
no_proxy=\"localhost,127.0.0.1,localaddress,.localdomain\""
	alias v2env="http_proxy=\"http://127.0.0.1:20171\" \
https_proxy=\"http://127.0.0.1:20171\" \
ftp_proxy=\"http://127.0.0.1:20171\" \
rsync_proxy=\"http://127.0.0.1:20171\" \
no_proxy=\"localhost,127.0.0.1,localaddress,.localdomain\""
	alias vgit="v2env git"
	alias vgitf="vgit fetch"
	alias vgitfu="vgitf upstream"
	alias vgitpl="vgit pull"
	alias vgitps="vgit push"
	alias vffmpeg="v2env ffmpeg"
fi

# A beautiful git log.
if command -v "git" &> /dev/null; then
	git config --global alias.graph "log --graph --abbrev-commit --decorate --date=iso8601 --format=format:'%C(bold blue)%h%C(reset) %C(white)%s%C(reset) %C(dim white)<%ae>%C(reset) %C(bold green)(%ad)%C(reset) %C(auto)%d%C(reset)'"
fi

# Pacman helpers.
if command -v "pacman" &> /dev/null; then
	alias pmsync="pacman --sync"
	alias pmremove="pacman --remove"
	alias pmquery="pacman --query"
	alias pmfiles="pacman --files"
	alias pmup="pacman --upgrade"
	alias pmdata="pacman --database"
	alias pmtest="pacman --deptest"
	alias pmrns="pacman -Rns"
	alias spmrns="sudo pacman -Rns"
	alias pmsyu="pacman -Syyu"
	alias spmsyu="sudo pacman -Syyu"
	alias pmss="pacman -Ss"
fi

# systemd helpers.
if command -v "systemctl" &> /dev/null; then
	# Let the pager away.
	alias systemctl="systemctl --no-pager --full"
	alias journalctl="journalctl --no-pager --full --output=short-iso"
	alias sdenable="systemctl enable"
	alias ssdenable="sudo systemctl enable"
	alias sdenablenow="systemctl enable --now"
	alias ssdenablenow="sudo systemctl enable --now"
	alias sddisable="systemctl disable"
	alias ssddisable="sudo systemctl disable"
	alias sddisablenow="systemctl disable --now"
	alias ssddisablenow="sudo systemctl disable --now"
	alias sdstart="systemctl start"
	alias ssdstart="sudo systemctl start"
	alias sdstatus="systemctl status --no-pager --full"
	alias ssdstatus="sudo systemctl status --no-pager --full"
	alias sdstop="systemctl stop"
	alias ssdstop="sudo systemctl stop"
	alias sdedit="systemctl edit"
	alias ssdedit="sudo systemctl edit"
	alias jdb0="journalctl --no-pager --full --boot=0"
	alias sjdb0="sudo journalctl --no-pager --full --boot=0"
	alias jdb1="journalctl --no-pager --full --boot=-1"
	alias sjdb1="journalctl --no-pager --full --boot=-1"
	alias jeu="journalctl -eu"
	alias sjeu="sudo journalctl -eu"
fi

# FFmpeg helpers.
if command -v "ffmpeg" &> /dev/null; then
	# Convert MOV (H264 + PCM_S16LE) to MP4 (H264 + AAC@256K), typically for
	# DaVinci Resolve Studio outputs.
	function mov2mp4() {
		# We don't want the ext name because we change it.
		for i in ${@}; do
			i="${i%.mov}"
			ffmpeg -i "${i}.mov" -c:v copy -c:a aac -b:a 256k -ar 44100 "${i}.mp4"
		done
	}
	# Convert MP4 (H264 + AAC@256K) to MOV (H264 + PCM_S16LE), typically for
	# DaVinci Resolve Studio inputs, but not Sony XAVC S (H264 + PCM_S16LE
	# in MP4).
	function mp42mov() {
		# We don't want the ext name because we change it.
		for i in ${@}; do
			i="${i%.mp4}"
			ffmpeg -i "${i}.mp4" -c:v copy -c:a pcm_s16le "${i}.mov"
		done
	}
	# Convert FLAC to MP3 (256K), typically for sharing Ardour outputs.
	function flac2mp3() {
		# We don't want the ext name because we change it.
		for i in ${@}; do
			i="${i%.flac}"
			ffmpeg -i "${i}.flac" -c:a mp3 -b:a 256k  -ar 44100 "${i}.mp3"
		done
	}
	# Merge Bilibili App downloaded M4S files into MP4 (H264/H265 + AAC),
	# you can use `"${PWD##*/}"` to get current dir name.
	function m4s2mp4() {
		ffmpeg -i video.m4s -i audio.m4s -c:v copy -c:a copy "${1}.mp4"
	}
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
	source "${HOME}/.zcustom"
fi
