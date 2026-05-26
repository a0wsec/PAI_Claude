# PAI + Claude Code — Docker/Exegol Starter

```bash
git clone https://github.com/a0wsec/PAI_Claude.git /tmp/PAI_Claude
cd /tmp/PAI_Claude && bash pai-docker-install.sh
pai
```

C'est tout. Le script installe bun, node, Claude Code, copie les skills/hooks/algo, configure l'alias `pai`.

---

## Apres installation

```bash
pai              # Claude Code + PAI system prompt
claude           # Claude Code sans PAI
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

## Update

```bash
git clone https://github.com/a0wsec/PAI_Claude.git /tmp/PAI_Claude
cd /tmp/PAI_Claude && bash pai-docker-install.sh
```
