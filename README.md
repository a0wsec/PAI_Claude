# PAI + Claude Code — Docker Starter

> PAI (Personal AI Infrastructure) + Claude Code CLI dans n'importe quel container Docker/Exegol.
> Skills, hooks, algorithm, documentation — pret a l'emploi.

## One-liner

```bash
apt-get update -qq && apt-get install -y -qq curl git unzip python3 sshpass nmap zsh && curl -fsSL https://bun.sh/install | bash && export PATH="$HOME/.bun/bin:$PATH" && ln -sf "$HOME/.bun/bin/bun" /usr/local/bin/bun && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && apt-get install -y -qq nodejs && npm install -g @anthropic-ai/claude-code && git clone https://github.com/a0wsec/PAI_Claude.git /tmp/PAI_Claude && mkdir -p ~/.claude && cp -r /tmp/PAI_Claude/* ~/.claude/ && cp -r /tmp/PAI_Claude/.* ~/.claude/ 2>/dev/null; rm -rf /tmp/PAI_Claude && echo "export PATH=\$HOME/.bun/bin:\$PATH" >> ~/.bashrc && echo "export PAI_DIR=\$HOME/.claude/PAI" >> ~/.bashrc && echo "alias pai='claude'" >> ~/.bashrc && ln -sf /usr/local/bin/claude /usr/local/bin/pai 2>/dev/null; echo '#!/bin/bash' > /usr/local/bin/pai && echo 'exec claude "$@"' >> /usr/local/bin/pai && chmod +x /usr/local/bin/pai
```

## Demarrer

```bash
# Option 1: commande pai
pai
# → Lance Claude Code avec le system prompt PAI

# Option 2: claude direct
claude
# → Lance Claude Code standard

# Option 3: dans un dossier specifique
cd /workspace && pai
```

## Premier lancement

La premiere fois, Claude Code demande l'auth OAuth:

```
1. Lance 'claude' ou 'pai'
2. Suis le lien OAuth dans le terminal
3. Accepte sur le navigateur
4. Le terminal est pret
```

Alternative: utiliser une API key

```bash
export ANTHROPIC_API_KEY=sk-ant-...
pai
```

## Skills disponibles

Une fois lance, les 45+ skills sont directement utilisables:

```
/RedTeam <cible>           # Analyse adverse d'un argument/plan
/ISA                        # Ideal State Artifact — spec de tache
/Science                    # Methode scientifique (hypothese → experience)
/FirstPrinciples            # Deconstruction par principes premiers
/ContextSearch              # Recherche dans les sessions precedentes
/Interceptor                # Browser automation (verification UI)
/BeCreative                 # Ideation divergente
/Council                    # Debat multi-agent
/RootCauseAnalysis          # Analyse de cause racine (5 Whys, Fishbone)
/CreateCLI                  # Generer un CLI TypeScript
/Migrate                    # Importer du contenu externe
/Interview                  # Interview conversational (TELOS, preferences)
/PAIUpgrade                 # Scanner les sources pour des upgrades PAI
```

## Modes de l'Algorithme

| Mode | Usage |
|------|-------|
| `/e1` | Standard — taches simples (<90s) |
| `/e2` | Extended — qualite elevee (3min) |
| `/e3` | Advanced — multi-fichier substantiel (10min) |
| `/e4` | Deep — architecture, cross-cutting (30min) |
| `/e5` | Comprehensive — pas de limite de temps |

## Structure

```
~/.claude/
├── CLAUDE.md              # Config principale + mode detection
├── skills/                # 45+ skills (ISA, RedTeam, Interceptor, Art...)
├── PAI/
│   ├── ALGORITHM/         # Algorithm v6.3.0 + capabilities
│   ├── DOCUMENTATION/     # Docs architecture, skills, hooks...
│   └── PAI_SYSTEM_PROMPT.md
├── hooks/                 # Hooks PAI (ISASync, SecurityPipeline...)
└── pai-docker-install.sh  # Script d'installation
```

## Mise a jour

```bash
cd /tmp && git clone https://github.com/a0wsec/PAI_Claude.git
cd PAI_Claude && bash pai-docker-install.sh
# → Met a jour les skills + hooks sans toucher a la config existante
```
