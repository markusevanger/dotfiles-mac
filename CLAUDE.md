# Notes for Claude

You are probably reading this because someone wants a Mac terminal set up
"like this one". This repo is one person's working config, not a template.
Adapt it — do not copy it verbatim.

## Ask first, then install

Find out what the user actually wants before running anything:

1. Do they already have a terminal, shell config, or nvim setup? `install.sh`
   backs files up to `*.bak` rather than deleting, but a person with an
   existing setup usually wants pieces, not the whole thing:
   `./install.sh zsh tmux ghostty`.
2. Do they use pnpm/vercel/sanity? Most of the zsh aliases assume that stack
   and are noise otherwise.
3. `Brewfile` is a full dump of the source machine — it includes unrelated
   desktop apps (RetroArch, Surfshark, Blender…). Do not run
   `brew bundle install` against it blindly. The terminal-relevant subset is:

   ```
   tmux starship fnm pnpm neovim bat lsd fzf gh btop television
   zsh-syntax-highlighting zsh-autosuggestions
   ```
   Plus casks: `ghostty`. The `0xProtoNerdFontMono` font is required by the
   Ghostty config — install a Nerd Font or change `font-family`.

## Machine-specific values that WILL break elsewhere

`zsh/.zshrc` hardcodes the original owner's home directory in several places.
Replace `/Users/markusevanger` with `$HOME`, or delete the lines outright if
the tool isn't installed:

| Line | Value | Action |
|---|---|---|
| `fpath=(…/.docker/completions …)` | Docker completions | drop unless Docker Desktop is installed |
| `PATH=…/personal/ffmpeg-cli` | a personal script dir | drop |
| `PATH=…/go/bin` | packwiz (Minecraft) | drop unless they use Go |
| `FNM_PATH=…/Library/Application Support/fnm` | Node version manager | keep, use `$HOME` |
| `PNPM_HOME=…/Library/pnpm` | pnpm | keep, use `$HOME` |
| `…/.bun/_bun` | Bun completions | keep, use `$HOME` |
| `…/.antigravity/antigravity/bin` | an AI editor | drop |
| `/opt/homebrew/anaconda3` | conda, lazily loaded | drop unless they use conda |
| `/opt/homebrew/…` | Apple Silicon Homebrew prefix | Intel Macs use `/usr/local` |

`git/.gitconfig` contains the original owner's name and email. Change both, or
the user's commits will be attributed to someone else.

`scripts/recap` hardcodes `AUTHOR_EMAIL` and `REPOS_DIR="$HOME/jobb/repos"`.

`scripts/config` and `killdev` assume ports 3000/3001/3333 and specific
config paths.

## Known quirks in this config, not things to reproduce

- **Two prompts are loaded.** `.zshrc` line 6 runs `starship init`, line 134
  sources Homebrew's `spaceship.zsh`. The later one wins, so starship is
  effectively dead and `~/.config/starship.toml` is empty. Pick one prompt.
- **`ZSH_THEME="robbyrussell"`** is also set but overridden by the above.
- **`alias cat="bat"`** breaks scripts that pipe into `cat`. Deliberate, but
  worth telling the user.
- **`alias cc="claude --dangerously-skip-permissions"`** skips all permission
  prompts. Do not set this up for someone without explaining it.
- **`.zshrc` auto-attaches to a tmux session named `main`** on every
  interactive shell (with guards for VS Code / Cursor / Emacs). Surprising if
  the user doesn't know tmux. `tmux detach` or comment the block out.
- **`.zshenv` sources `~/.cargo/env`** and will error if Rust isn't installed.

## Structure

Each top-level dir is a package whose contents mirror `$HOME`
(`zsh/.zshrc` → `~/.zshrc`). This is the GNU stow layout, so `stow -t ~ zsh`
works too; `install.sh` just avoids the dependency.

## Secrets

The repo is public. Secrets belong in `~/.zshrc.local` (gitignored, sourced at
the end of `.zshrc`). `hooks/pre-commit` blocks commits containing key-shaped
strings — if you add config for the user, keep credentials out of tracked
files.
