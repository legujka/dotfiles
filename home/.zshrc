export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="strug"

DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT="true"

# Exports
export PATH="$HOME/bin:$HOME/.local/bin:$HOME/go/bin:$PATH"
export GOPATH="$HOME/go"

# Completions cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh
zstyle ':completion:*' squeeze-slashes on
DISABLE_COMPLETION_WAITING_DOTS="true"

# Plugins
plugins=(
  git
  vi-mode
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Vi mode cursor
VI_MODE_SET_CURSOR=true
VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true

source $ZSH/oh-my-zsh.sh

# Local configs
[[ -f ~/.zshrc.local   ]] && source ~/.zshrc.local
[[ -r ~/.zsh_aliases   ]] && source ~/.zsh_aliases
[[ -r ~/.zsh_functions ]] && source ~/.zsh_functions

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt inc_append_history
setopt share_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt extended_history

# Autoreload history across sessions
autoload -Uz add-zsh-hook
add-zsh-hook precmd zsh_reload_history
zsh_reload_history() { fc -R }

# Fzf
if command -v fzf &> /dev/null
then
  source <(fzf --zsh) 2>/dev/null || source ~/.fzf.zsh 2>/dev/null || true
  
  export FZF_DEFAULT_OPTS='
    --height 40%
    --layout=reverse
    --border
    --inline-info

    --color=bg+:#363A4F,bg:#24273A,spinner:#F4DBD6,hl:#ED8796
    --color=fg:#CAD3F5,header:#ED8796,info:#C6A0F6,pointer:#F4DBD6
    --color=marker:#B7BDF8,fg+:#CAD3F5,prompt:#C6A0F6,hl+:#ED8796
    --color=selected-bg:#494D64
    --color=border:#6E738D,label:#CAD3F5

    --bind ctrl-j:down
    --bind ctrl-k:up
    --bind ctrl-d:half-page-down
    --bind ctrl-u:half-page-up
    --bind ctrl-a:select-all
    --bind ctrl-s:toggle-sort
    --bind ctrl-/:toggle-preview
    --bind ctrl-space:toggle+down
    --bind shift-tab:toggle-up'

  export FZF_CTRL_R_OPTS="
    --preview 'echo {}'
    --preview-window down:3:wrap
    --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
    --header 'Press CTRL-Y to copy command'"

  # Use fd for fzf if available
  if command -v fd &> /dev/null
  then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  fi
fi

# Vi mode `jk` to escape insert mode
bindkey -M viins 'jk' vi-cmd-mode

# Zoxide alias replacing cd, if installed
if command -v zoxide &> /dev/null
then
  eval "$(zoxide init zsh)"
  alias cd='z'
  alias cdi='zi'
fi

# Eza alias replacing ls, if installed
if command -v eza &> /dev/null
then
  alias ls='eza --color always -l --git -g --header --icons'
  alias ll='eza -alF --icons --color=always --group-directories-first'
  alias la='eza -a --icons --color=always --group-directories-first'
  alias l='eza -F --icons --color=always --group-directories-first'
  alias l.='eza -a | egrep "^\."'
fi

# Setup lazygit config, if installed
if command -v lazygit &> /dev/null
then
  export XDG_CONFIG_HOME="$HOME/.config"
fi

# Bat alias replacing cat, if installed
if command -v bat &> /dev/null
then
  export BAT_CONFIG_DIR="$HOME/.config/bat"
  alias cat='bat'
fi

# aliases for ./home/.local/scripts
if command -v dlv &> /dev/null
then
  alias dbg="$HOME/.local/scripts/debug.sh"
fi

alias dotenv="source $HOME/.local/scripts/dotenv_export.sh"

# Fastfetch only in first kitty window
if [[ -o interactive ]] && [[ "$KITTY_WINDOW_ID" == "1" ]]
then
  command -v fastfetch &>/dev/null && fastfetch
fi
