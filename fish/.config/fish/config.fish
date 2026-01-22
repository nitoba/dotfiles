# ~/.config/fish/config.fish
# ==========================

# Só rodar em shells interativos
if status is-interactive

    # ----------------------------------
    # PATH e ferramentas
    # ----------------------------------
    # Rust, .NET, Neovim, OpenCode
    set -Ua fish_user_paths $HOME/.cargo/bin
    set -x PATH $PATH /opt/nvim-linux64/bin
    set -Ua fish_user_paths $HOME/.opencode/bin

    # Bun, FNM
    set --export BUN_INSTALL "$HOME/.bun"
    set --export PATH $BUN_INSTALL/bin $PATH
    set -x PATH $PATH $HOME/.local/share/fnm

    # PNPM
    set -gx PNPM_HOME "$HOME/.local/share/pnpm"
    if not string match -q -- $PNPM_HOME $PATH
        set -gx PATH "$PNPM_HOME" $PATH
    end

    # WezTerm
    fish_add_path -a "/usr/bin/wezterm"

    # ----------------------------------
    # Variáveis de ambiente
    # ----------------------------------
    set --export OLLAMA_HOST "0.0.0.0"
    set --export CUDA_VISIBLE_DEVICES "0,1,2,3"

    # ----------------------------------
    # Ferramentas de inicialização
    # ----------------------------------
    # FNM
    if type -q fnm
        set -gx FNM_DIR "$HOME/.local/share/fnm"
        fnm env --use-on-cd --shell fish | source
    end

    # Starship prompt
    if type -q starship
        starship init fish | source
    end

    # zoxide
    if type -q zoxide
        zoxide init fish | source
    end

    # Carapace
    set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense'
    if type -q carapace
        carapace _carapace | source
    end

    # Aliases
    alias ls 'eza -l --no-filesize --long --icons=always --tree --color=always --no-user --no-time --no-permissions --level=3 --git-ignore'
    alias cat 'batcat --color=always'
    alias cd 'z'
    alias standup "cd /home/nitoba/.standup; ./standup-linux"
    alias pr "/home/nitoba/Documents/repos/pr/run.sh"
end

