#!/usr/bin/env bash
# Symlink every tracked config file into $HOME.
#
#   ./install.sh --dry-run     show what would happen, change nothing
#   ./install.sh               link everything (existing files moved to *.bak)
#   ./install.sh zsh tmux      link only these packages
#   ./install.sh --bootstrap   install prerequisites first, then link
#
# Layout convention: each top-level dir is a "package" whose contents mirror
# $HOME. So zsh/.zshrc -> ~/.zshrc, tmux/.config/tmux/x -> ~/.config/tmux/x.
# This is also the GNU stow layout, so `stow -t ~ zsh tmux` works if you
# prefer stow over this script.

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ALL_PACKAGES=(zsh git tmux ghostty nvim btop lsd scripts)

DRY_RUN=false
BOOTSTRAP=false
PACKAGES=()

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --bootstrap) BOOTSTRAP=true ;;
    -h|--help) sed -n '2,16p' "$0" | sed 's/^# \?//'; exit 0 ;;
    -*) echo "unknown flag: $arg" >&2; exit 1 ;;
    *) PACKAGES+=("$arg") ;;
  esac
done
[[ ${#PACKAGES[@]} -eq 0 ]] && PACKAGES=("${ALL_PACKAGES[@]}")

run() { if $DRY_RUN; then echo "  would: $*"; else "$@"; fi; }

# ---------------------------------------------------------------- bootstrap

bootstrap() {
  echo "==> bootstrap"

  if ! command -v brew >/dev/null; then
    echo "  Homebrew missing. Install from https://brew.sh first." >&2
    exit 1
  fi

  # Homebrew packages. Full dump of the source machine; see CLAUDE.md for the
  # terminal-only subset if you don't want all of it.
  run brew bundle install --file="$DOTFILES/Brewfile"

  # oh-my-zsh
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    run git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
  fi

  # oh-my-zsh custom plugins used by .zshrc
  local custom="$HOME/.oh-my-zsh/custom/plugins"
  for plugin in zsh-syntax-highlighting zsh-autosuggestions; do
    if [[ ! -d "$custom/$plugin" ]]; then
      run git clone --depth=1 "https://github.com/zsh-users/$plugin.git" "$custom/$plugin"
    fi
  done

  # oh-my-tmux: upstream 1900-line tmux.conf lives outside this repo, only our
  # tmux.conf.local overrides it. Pinned to the commit the source machine runs.
  local omt="$HOME/.local/share/tmux/oh-my-tmux"
  if [[ ! -d "$omt" ]]; then
    run mkdir -p "$(dirname "$omt")"
    run git clone https://github.com/gpakosz/.tmux.git "$omt"
    run git -C "$omt" checkout --quiet af33f07
  fi
  run mkdir -p "$HOME/.config/tmux"
  run ln -sfn "$omt/.tmux.conf" "$HOME/.config/tmux/tmux.conf"
}

# ---------------------------------------------------------------- linking

link_package() {
  local pkg="$1" pkg_dir="$DOTFILES/$1"
  [[ -d "$pkg_dir" ]] || { echo "  no such package: $pkg" >&2; return 1; }
  echo "==> $pkg"

  while IFS= read -r rel; do
    local src="$pkg_dir/$rel" dest="$HOME/$rel"

    # already pointing at us
    if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
      echo "  ok:    ~/$rel"
      continue
    fi

    # something real is in the way -> back it up, never delete
    if [[ -e "$dest" || -L "$dest" ]]; then
      echo "  backup ~/$rel -> ~/$rel.bak"
      run mv "$dest" "$dest.bak"
    fi

    echo "  link:  ~/$rel"
    run mkdir -p "$(dirname "$dest")"
    run ln -sfn "$src" "$dest"
  done < <(cd "$pkg_dir" && find . -type f -not -name '.DS_Store' | sed 's|^\./||' | sort)
}

# ---------------------------------------------------------------- main

$DRY_RUN && echo "DRY RUN — nothing will change"
$BOOTSTRAP && bootstrap

for pkg in "${PACKAGES[@]}"; do link_package "$pkg"; done

# Secret-scanning pre-commit hook travels with the repo.
run git -C "$DOTFILES" config core.hooksPath hooks

cat <<'DONE'

Done. Next:
  exec zsh                        reload the shell
  ghostty: quit and reopen        it only reads config at launch

Machine-specific values you probably need to change are listed in CLAUDE.md.
DONE
