# Fedora Bluefin Development Setup

Este playbook Ansible configura automaticamente um ambiente de desenvolvimento completo em Fedora Atomic (Silverblue/Bluefin).

## Pré-requisitos

- Fedora Bluefin ou Silverblue
- Conexão com internet
- Conta com privilégios sudo

## Instalação e Uso

### Opção 1: Usar o script de setup (Recomendado)

```bash
cd ~/.ansible
sudo ./run-setup.sh
```

### Opção 2: Executar diretamente com Ansible

```bash
cd ~/.ansible
sudo ansible-playbook -i inventory.ini playbook.yml
```

## O que será instalado

### Ferramentas CLI (via Homebrew)
- **stow** - Gerenciamento de dotfiles (links simbólicos)
- **zoxide** - Navegação de diretórios inteligente (substituto do z)
- **eza** - Listagem de arquivos moderna (substituto do ls/exa)
- **fzf** - Fuzzy finder para linha de comando
- **bat** - Visualizador de arquivos com syntax highlighting (substituto do cat)
- **gh** - GitHub CLI oficial
- **fnm** - Fast Node Manager (gerenciador de Node.js)

### Ferramentas de Desenvolvimento
- **Visual Studio Code** (RPM via Microsoft repository)
- **OpenCode** (alternativa community do VSCode)
- **Node.js** (última versão LTS via fnm)
- **pnpm** (via corepack)
- **Bun** (JavaScript runtime/package manager)
- **Claude Code** (CLI da Anthropic)

### Flatpaks
- Discord
- DBeaver Community Edition
- Zen Browser
- OBS Studio
- WezTerm

### Ferramentas de Automação
- **Linux Toys** (coleção de utilitários)

### Dotfiles
- Clone do repositório dotfiles (branch `bluefin`)
- Instalação do GNU Stow (via Homebrew)
- Link simbólico dos arquivos de configuração

## Estrutura de Arquivos

```
.ansible/
├── playbook.yml          # Playbook principal
├── inventory.ini         # Inventário de hosts
├── requirements.yml      # Dependências do Ansible Galaxy
├── run-setup.sh          # Script de execução
└── README.md             # Este arquivo
```

## Variáveis Personalizáveis

Você pode modificar as variáveis no arquivo `playbook.yml`:

```yaml
vars:
  dotfiles_repo: "https://github.com/nitoba/dotfiles.git"
  dotfiles_branch: "bluefin"
  flatpak_apps:
    - com.discordapp.Discord
    - io.dbeaver.DBeaverCommunity
    # ... adicione mais Flatpaks aqui
```

## Executar tarefas específicas

Para executar apenas tarefas específicas, use tags:

```bash
# Apenas dotfiles
ansible-playbook -i inventory.ini playbook.yml --tags "dotfiles"

# Apenas Node.js e ferramentas relacionadas
ansible-playbook -i inventory.ini playbook.yml --tags "nodejs"
```

## Solução de Problemas

### Verbose mode
Para ver detalhes da execução:

```bash
ansible-playbook -i inventory.ini playbook.yml -v
```

### Modo check (dry-run)
Para verificar o que seria alterado sem fazer mudanças:

```bash
ansible-playbook -i inventory.ini playbook.yml --check
```

### Pular erros
Para continuar mesmo com erros:

```bash
ansible-playbook -i inventory.ini playbook.yml --skip-tags "problematic-tag"
```

## Após a Instalação

1. **Reboot necessário**: Após a instalação, reboot para aplicar todas as mudanças do rpm-ostree:
   ```bash
   systemctl reboot
   ```

2. **Verifique as instalações**:
   ```bash
   node --version      # Node.js
   pnpm --version      # pnpm
   bun --version       # Bun
   fnm --version       # fnm
   claude --version    # Claude Code
   z --version         # zoxide
   eza --version       # eza
   fzf --version       # fzf
   bat --version       # bat
   gh --version        # GitHub CLI
   ```

## Notas Específicas para Fedora Atomic

- Algumas instalações usam `rpm-ostree` que requer reboot
- Flatpaks são instalados diretamente (sem necessidade de reboot)
- O script detecta e avisa se não estiver rodando em Fedora Bluefin/Silverblue

## Contribuindo

Sinta-se livre para modificar este playbook para suas necessidades. As principais configurações estão no arquivo `playbook.yml`.
