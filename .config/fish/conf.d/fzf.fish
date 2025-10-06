# Set up fzf key bindings and fuzzy completion
set --export FZF_DEFAULT_COMMAND "fd --hidden --strip-cwd-prefix --exclude .git "
set --export FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set --export FZF_ALT_C_COMMAND "fd --type=d --hidden --strip-cwd-prefix --exclude .git"

set --export FZF_DEFAULT_OPTS "--height 50% --layout=default --border --color=hl:#50FA7B"

# Setup fzf previews
set --export FZF_CTRL_T_OPTS "--preview 'batcat --color=always -n --line-range :500 {}'"
set --export FZF_ALT_C_OPTS "--walker-skip .git,node_modules,target --preview 'eza --icons=always --tree --color=always {} | head -200'"

 
fzf --fish | source
