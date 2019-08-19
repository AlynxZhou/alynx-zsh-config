alynx-zsh-config
================

Alynx's zsh configuration files.
--------------------------------

# Usage

Just download the `.zshrc` file and put it into your home directory.

# Description

Some features:

- Single file configuration.
	`oh-my-zsh` is too hugh and I would like a simple configuare.
- Colorful prompt with git status display.
	I never use powerline because it is always hard to align and hard to copy.
- Powerful zsh built-in completion.
	Those configuration is from internet and I collected them.
- Clear dotfiles chain loading.
	Load sequence:
	+ `.profile`
		Environment variable that will be used by all shell.
	+ `.zprofile`
		Environment variable that will be used by zsh only (Alynx does not use this in fact).
	+ `.zshrc`
		Main configuration file.
	+ `.zcustom`
		This will be load at last and you can put your own configuration here, for example, if your autosuggestion puts in another dir you can execute it here.
	History is stored in `.zhistory`, and it will not load files like `.bash_profile`, `.xprofile`, they belongs to other programs, Alynx's zsh configuration only care about zsh.

If you get any ideas to improve it, please send PR or issue! Thanks!

# License

Apache-2.0

