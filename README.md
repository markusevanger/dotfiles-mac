# dotfiles-mac

👋 Velkommen til mitt terminal setup for jobb-macen min! Her finner du detaljer om alt jeg bruker. Hovedsaklig jobber jeg mest med claude og webdev greier, så mye er veldig spesifikt for akkuratt min arbeidsflyt. Ta inspirasjon! 

Every file here is symlinked into `$HOME`, so editing `~/.zshrc` edits this repo.

## Install on a new Mac

```sh
git clone https://github.com/<user>/dotfiles-mac ~/dotfiles-mac
cd ~/dotfiles-mac
./install.sh --dry-run      # see what it would touch
./install.sh --bootstrap    # install prerequisites, then symlink
exec zsh
```

Existing files are moved to `*.bak`, never deleted. Ghostty only reads its
config at launch — quit and reopen it.

## What's in here

| Package | Links to | What it is |
|---|---|---|
| `zsh` | `~/.zshrc` `~/.zshenv` `~/.zprofile` | oh-my-zsh, aliases, PATH, auto-attach to tmux |
| `tmux` | `~/.config/tmux/` | oh-my-tmux overrides, Catppuccin Mocha, dev-port status bar |
| `ghostty` | `~/.config/ghostty/config` | font, transparency, keybinds |
| `git` | `~/.gitconfig` `~/.gitignore_global` | identity, LFS, global excludes |
| `nvim` | `~/.config/nvim/` | LazyVim starter |
| `btop` `lsd` | `~/.config/…` | system monitor, `ls` replacement |
| `scripts` | `~/.scripts/` | `config`, `killdev`, `recap`, `update` — on `$PATH` |
| `Brewfile` | — | full `brew bundle dump` of the source machine |

Not tracked on purpose: `~/.config/gh` (auth state), `~/.oh-my-zsh` (upstream),
oh-my-tmux's `tmux.conf` (upstream, cloned by `install.sh`).

## Secrets

This repo is public. Secrets go in `~/.zshrc.local`, which is gitignored and
sourced at the end of `.zshrc`. A `hooks/pre-commit` scanner blocks commits
containing key-shaped strings; `install.sh` enables it via `core.hooksPath`.

## Adding a config

```sh
mv ~/.config/foo/config ~/dotfiles-mac/foo/.config/foo/config
./install.sh foo
```

Then add `foo` to `ALL_PACKAGES` in `install.sh`.
