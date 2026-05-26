# PAI + Claude Code — Docker/Exegol Starter

PAI (Personal AI Infrastructure) + Claude Code dans n'importe quel container Debian.
45+ skills, hooks, Algorithm v6.3.0 — operationnel en 2 minutes.

---

## One-Line

```bash
curl -sL https://raw.githubusercontent.com/a0wsec/PAI_Claude/main/pai-docker-install.sh | bash
```

---

## Step by Step

### 1. System dependencies

```bash
apt-get update -qq && apt-get install -y -qq curl git unzip python3 sshpass nmap zsh
```

### 2. Bun runtime

```bash
curl -fsSL https://bun.sh/install | bash
export PATH="$HOME/.bun/bin:$PATH"
ln -sf "$HOME/.bun/bin/bun" /usr/local/bin/bun
```

### 3. Node 22 + Claude Code

```bash
curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
apt-get install -y -qq nodejs
npm install -g @anthropic-ai/claude-code
```

### 4. PAI framework (skills, hooks, algorithm)

```bash
git clone https://github.com/a0wsec/PAI_Claude.git /tmp/PAI_Claude
mkdir -p ~/.claude
cp -r /tmp/PAI_Claude/* ~/.claude/
cp -r /tmp/PAI_Claude/.* ~/.claude/ 2>/dev/null
rm -rf /tmp/PAI_Claude
```

### 5. Shell config

```bash
echo 'export PATH="$HOME/.bun/bin:$PATH"' >> ~/.bashrc
echo 'export PAI_DIR="$HOME/.claude/PAI"' >> ~/.bashrc
echo 'alias pai="claude"' >> ~/.bashrc
cat > /usr/local/bin/pai << 'EOF'
#!/bin/bash
exec claude "$@"
EOF
chmod +x /usr/local/bin/pai
```

### 6. Lance

```bash
source ~/.bashrc
pai
# Premier lancement → OAuth → suis le lien → pret
```

---

## Apres installation

```bash
pai              # lancer Claude Code avec PAI
pai /workspace   # lancer dans un dossier specifique
claude           # Claude Code sans le system prompt PAI
```

### Skills

```
/RedTeam <cible>      /RootCauseAnalysis     /FirstPrinciples
/ISA                  /Science               /BeCreative
/Council              /CreateCLI             /ContextSearch
/Interceptor          /Interview             /Migrate
```

### Modes

```
/e1   Standard (<90s)      /e4   Deep (30min)
/e2   Extended (3min)      /e5   Comprehensive (2h+)
/e3   Advanced (10min)
```

## Structure

```
~/.claude/
├── CLAUDE.md           # Config + mode detection
├── skills/             # 45+ skills
├── PAI/
│   ├── ALGORITHM/      # Algorithm v6.3.0
│   ├── DOCUMENTATION/  # Docs architecture
│   └── PAI_SYSTEM_PROMPT.md
├── hooks/              # ISASync, SecurityPipeline...
└── pai-docker-install.sh
```

## Update

```bash
curl -sL https://raw.githubusercontent.com/a0wsec/PAI_Claude/main/pai-docker-install.sh | bash
```
