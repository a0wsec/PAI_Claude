#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
#  PAI + Claude Code — Docker/Exegol One-Line Installer
#  Usage: curl -sL https://<your-server>/pai-docker-install.sh | bash
#  Or:    bash pai-docker-install.sh
# ═══════════════════════════════════════════════════════════════
set -euo pipefail

# ─── Config (modifie si besoin) ────────────────────────────
PAI_REPO="${PAI_REPO:-https://github.com/danielmiessler/PAI.git}"
PAI_DIR="${PAI_DIR:-$HOME/.claude}"
CLAUDE_CODE_VERSION="${CLAUDE_CODE_VERSION:-latest}"  # "latest" ou version specifique

# ─── Colors ────────────────────────────────────────────────
R='\033[0m'; B='\033[1;34m'; G='\033[1;32m'; Y='\033[1;33m'; RED='\033[1;31m'
info()  { echo -e "  ${B}[*]${R} $1"; }
ok()    { echo -e "  ${G}[+]${R} $1"; }
warn()  { echo -e "  ${Y}[!]${R} $1"; }
die()   { echo -e "  ${RED}[x]${R} $1"; exit 1; }

# ─── Root check ────────────────────────────────────────────
[ "$(id -u)" -eq 0 ] || die "Run as root (or use sudo). Exegol/Docker = root by default."

echo ""
echo "  ╔══════════════════════════════════════════════════════╗"
echo "  ║   PAI + Claude Code — Docker/Exegol Installer       ║"
echo "  ╚══════════════════════════════════════════════════════╝"
echo ""

# ─── Step 1: System dependencies ────────────────────────────
info "Installing system packages..."
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq && apt-get install -y -qq \
  curl git unzip ca-certificates gnupg \
  python3 python3-pip sshpass nmap xxd \
  zsh 2>&1 | tail -1
ok "System packages done"

# ─── Step 2: Bun ────────────────────────────────────────────
if command -v bun &>/dev/null; then
  ok "Bun already installed: v$(bun --version)"
else
  info "Installing Bun..."
  curl -fsSL https://bun.sh/install | bash 2>/dev/null
  export PATH="$HOME/.bun/bin:$PATH"
  # Symlink system-wide for non-interactive subprocesses
  [ -d /usr/local/bin ] && ln -sf "$HOME/.bun/bin/bun" /usr/local/bin/bun 2>/dev/null || true
  ok "Bun v$(bun --version)"
fi

# ─── Step 3: Node (needed by Claude Code npm install) ──────
if command -v node &>/dev/null; then
  ok "Node already: $(node --version)"
else
  info "Installing Node 22..."
  curl -fsSL https://deb.nodesource.com/setup_22.x | bash - 2>/dev/null
  apt-get install -y -qq nodejs 2>&1 | tail -1
  ok "Node $(node --version)"
fi

# ─── Step 4: Claude Code CLI ────────────────────────────────
if command -v claude &>/dev/null; then
  ok "Claude Code already installed: $(claude --version 2>/dev/null || echo 'ok')"
else
  info "Installing Claude Code..."
  npm install -g @anthropic-ai/claude-code 2>&1 | tail -3
  ok "Claude Code installed"
fi

# ─── Step 5: Clone PAI (si pas deja la) ────────────────────
if [ -d "$PAI_DIR/PAI" ]; then
  ok "PAI already present in $PAI_DIR"
else
  info "Installing PAI framework..."

  # Si on est dans le repo PAI deja (bundle local), on copie
  if [ -f "$(dirname "$0")/install.sh" ] && [ -d "$(dirname "$0")/PAI" ]; then
    info "Local PAI bundle detected — copying..."
    cp -r "$(dirname "$0")"/* "$PAI_DIR/" 2>/dev/null || true
    cp -r "$(dirname "$0")"/.* "$PAI_DIR/" 2>/dev/null || true
  else
    # Sinon on clone
    info "Cloning PAI from git..."
    git clone "$PAI_REPO" /tmp/PAI-clone 2>&1 | tail -1
    mkdir -p "$PAI_DIR"
    cp -r /tmp/PAI-clone/* "$PAI_DIR/" 2>/dev/null || true
    cp -r /tmp/PAI-clone/.* "$PAI_DIR/" 2>/dev/null || true
    rm -rf /tmp/PAI-clone
  fi
  ok "PAI framework copied to $PAI_DIR"
fi

# ─── Step 6: Shell config ───────────────────────────────────
BUN_EXPORT='export PATH="$HOME/.bun/bin:$PATH"'
for rc in "$HOME/.zshenv" "$HOME/.zprofile" "$HOME/.zshrc" "$HOME/.bashrc"; do
  touch "$rc" 2>/dev/null || true
  grep -q '.bun/bin' "$rc" 2>/dev/null || echo "$BUN_EXPORT" >> "$rc"
done

# ─── Step 7: Claude Code config ─────────────────────────────
# Setup OAuth si pas configure
if [ ! -f "$HOME/.claude.json" ] && [ -z "${ANTHROPIC_API_KEY:-}" ]; then
  warn "Pas d'auth Claude Code detectee."
  echo ""
  echo "  Lance 'claude' une premiere fois pour t'authentifier via OAuth."
  echo "  Ou export ANTHROPIC_API_KEY=sk-ant-..."
  echo ""
fi

# ─── Done ───────────────────────────────────────────────────
echo ""
echo "  ╔══════════════════════════════════════════════════════╗"
echo "  ║            INSTALLATION TERMINEE                     ║"
echo "  ╠══════════════════════════════════════════════════════╣"
echo "  ║  PAI:     $PAI_DIR"
echo "  ║  Claude:  $(which claude 2>/dev/null || echo 'PATH?')"
echo "  ║  Bun:     $(which bun 2>/dev/null || echo 'PATH?')"
echo "  ║  Shell:   $(basename "$SHELL")"
echo "  ╠══════════════════════════════════════════════════════╣"
echo "  ║  Pour lancer:   pai                                  ║"
echo "  ║  Ou:            cd /workspace && claude              ║"
echo "  ╚══════════════════════════════════════════════════════╝"
echo ""

# ─── Auto-launch si TTY dispo ──────────────────────────────
if [ -r /dev/tty ] && [ "${AUTO_LAUNCH:-1}" = "1" ]; then
  info "Lancement de pai..."
  exec zsh -i -c 'source ~/.zshrc 2>/dev/null; pai' < /dev/tty 2>/dev/null || \
  exec bash -i -c 'source ~/.bashrc 2>/dev/null; pai' < /dev/tty 2>/dev/null || \
  echo "  Lance manuellement: zsh -c pai"
fi
