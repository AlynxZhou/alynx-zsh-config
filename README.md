alynx-zsh-config
================

Alynx's zsh configuration files.
--------------------------------

If you get any ideas to improve it, please send PR or issue! Thanks!

# Usage

Just download the `.zshrc` file and put it into your home directory.

# Description

Some features:

## Single file configuration.

`oh-my-zsh` is too hugh and I would like a simple configuare.

## Colorful prompt with git status display.

I never use powerline because it is always hard to align and hard to copy.

## Powerful zsh built-in completion.

Those configuration is from internet and I collected them.

## Clear dotfiles chain loading.

History is stored in `.zhistory`, and it will not load files like `.bash_profile`, `.xprofile`, they belongs to other programs, Alynx's zsh configuration only care about zsh.

Load sequence:
	
### `.zprofile`

Environment variable that will be used by zsh only (Alynx does not use this in fact).

### `.zshrc`

Main configuration file.

### `.zcustom`

This will be load at last and you can put your own configuration here, for example, if your autosuggestion puts in another dir you can execute it here.

## About `.profile`

This file is dropped as well as `.pam_environment`, you are not supposed to load environment variables with your shell, because there are other programs run before your shell, for example a Desktop Environment in Wayland session which does not depend on shell scripts.

Alynx suggests you to use systemd to load your user environment variables, just create a `.conf` file under `~/.config/environment.d/` and fill it with `KEY=VALUE`. This supports both Xorg and Wayland sessions.

# License

Apache-2.0

