{ config, lib, pkgs, pkgs-unstable, st-pkgs, ... }:

{
  home.username = "bryant";
  home.homeDirectory = "/home/bryant";

  home.keyboard = null; # keyboard is managed in system confi

  home.stateVersion = "24.05"; # Please check release packages before change

  nixpkgs.config.allowUnfree = true; # For obsidian

  home = {
   packages = lib.concatLists [
    (with pkgs;
     [
      # general
      firefox
      brave
      git
      alacritty
      tree
      fastfetch
      xclip
      zsh
      vlc

      # development
      less

      fzf
      lazygit
      zoxide
      atuin
      dust
      fd
      ripgrep
      tmux

    ])
    
    (with pkgs-unstable;[
     neovim-unwrapped
    ])

    (with st-pkgs;[
     st-bryant
    ])
   ];
   file = {};
   sessionPath = [];
   sessionVariables =  {};
  };

  programs.neovim = {
   enable = true;
   package = pkgs-unstable.neovim-unwrapped;
   extraConfig = ''
    set clipboard=unnamedplus
    set showmode
    set showtabline=0
    set noswapfile
    set undofile
    set nowrap
    set expandtab
    set cmdheight=0
    set shiftwidth=2
    set softtabstop=2
    set tabstop=2
    set nonumber
    set hlsearch
    set incsearch
    set smartcase
    set ignorecase
   '';
  };

  programs.lazygit = {
   enable = true;
   settings = {
    os = {
     open = "st -e nvim {{filename}}";
     editPreset = "nvim";
    };
   };
  };


  programs.fzf = {
   enable = true;
   enableZshIntegration = true;
   defaultCommand = "fd --type f";
   defaultOptions = [
    "--preview-window noborder"
    "--height=50%"
   ];
  };

  
  programs.git = {
   enable = true;
   userName = "Bryant Santiago";
   userEmail = "pazbryant@proton.me";
   extraConfig = {
    init = {
     defaultBranch = "main";
    };
    core = {
     editor = "nvim";
    };
   };
  };


  programs.zoxide = {
   enable = true;
   enableZshIntegration = true;
   options = [ "--cmd cd" ];
  };	

  programs.firefox = {
   enable = true;
   profiles = {
    Personal = {
     id = 0;
    };
    Work = {
     id = 1;
    };
   };
  };

  programs.zsh = {
   enable = true;
   defaultKeymap = "emacs";
   sessionVariables = {
    EDITOR="nvim";
    VISUAL="nvim";
    TERMINAL="st";
    SUDO_EDITOR="nvim";
    BROWSER="firefox";
    VIDEO="mpv";
    COLORTERM="truecolor";
    OPENER="xdg-open";
    PAGER="less";
    BAT_PAGER="less";
    MANPAGER="nvim +Man";
    SXHKD_SHELL="zsh";
   };
   shellAliases = {
    sp = "systemctl suspend";
    sudo = "sudo ";
    rel = "xrdb merge ~/.Xresources && kill -USR1 $(pidof st)";
    cl="clear";

    sht = "shutdown now";
    ff = "fastfetch";
    dh = "rm ~/.history.db ~/.zsh_history";
    gb="git branch";
    glg="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%C";
    gsb="git status --short --branch";
    lzg="lazygit";
    gdc="git diff --cached";
    gd="git diff";
    gco="git checkout";
    gaa="git add -A";
    gc="git commit";
    ggpush="git push origin $(git rev-parse --abbrev-ref HEAD)";
    ggpull="git pull origin $(git rev-parse --abbrev-ref HEAD)";

    ta="tmux attach";
    tk="tmux kill-server";
    tn="tmux new -s $USER";
   };
   initExtra = ''
    reload() {
      source /home/bryant/.zshrc
    }
    
    arch() {
      architecture=""
      case $(uname -m) in
      i386) architecture="386" ;;
      i686) architecture="386" ;;
      x86_64) architecture="amd64" ;;
      arm) dpkg --print-architecture | grep -q "arm64" && architecture="arm64" || architecture="arm" ;;
      esac
    
      echo "$architecture"
    }
   '';
  };

  programs.atuin = {
   enable = true;
   enableZshIntegration = true;
   settings = {
    db_path = "~/.history.db";
    filter_mode = "session"; # session/global/directory/host
    key_path = "~/.key";
    session_path = "~/.session";
    dialect = "us";
    style = "compact";
    inline_height = 10;
    auto_sync = false;
    history_filter = [ "^clear" "^cd" "^ls" ];
    cwd_filter = [ "^/very/secret/area" ];
    max_preview_height = 4;
    show_help = true;
    secrets_filter = true;
    enter_accept = true;
    common_subcommands = [
     "cargo"
     "go"
     "git"
     "npm"
     "yarn"
     "pnpm"
     "kubectl"
    ];
    common_prefix = ["sudo"];
    keymap_mode = "vim-insert";
    keymap_cursor = { 
      emacs = "steady-underline";
      vim_insert = "steady-underline";
      vim_normal = "steady-underline";
    };
   };
  };

  programs.tmux = {
   enable = true;
   sensibleOnTop = false;
   secureSocket = false;
   extraConfig = ''
    # set mouse mode on
    set -g mouse on
    
    # set focus event (nvim)
    set-option -g focus-events on
    
    # disable status bar at start
    set -g status off
    bind-key b set-option status
    
    # set copy mode
    set-window-option -g mode-keys vi
    
    bind -T copy-mode-vi v send-keys -X begin-selection
    bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
    bind -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
    
    # delay after prefix
    set -sg escape-time 0
    
    # set true colors compatibility
    set -g default-terminal "tmux-256color"
    set -sa terminal-overrides ',*:RGB'
    
    # create new window current path
    bind-key c new-window -c "#{pane_current_path}"
    
    # split vertical panel in current path
    bind-key % split-window -h -c "#{pane_current_path}"
    bind-key '"' split-window -c "#{pane_current_path}"
    
    # display panel numbers time
    set -g display-panes-time 10000
    
    # remove kill panel confirmation 
    unbind-key x
    bind-key x kill-pane
    
    # remove kill session confirmation
    bind-key X kill-session
    
    # base index
    set -g base-index 1
    
    # panel border type
    set -g pane-border-lines simple
    
    # terminal history limit
    set-option -g history-limit 5000
    
    # bspwm layout switching
    bind-key 1 select-layout even-horizontal
    bind-key 2 select-layout even-vertical
    bind-key 3 select-layout main-horizontal
    bind-key 4 select-layout main-vertical
    bind-key 5 select-layout tiled
    
    # Resize pane by 1 cell
    bind-key -r j resize-pane -D
    bind-key -r k resize-pane -U 
    bind-key -r h resize-pane -L 
    bind-key -r l resize-pane -R 
    
    # yazi configuration
    set -g allow-passthrough on
    set -ga update-environment TERM
    
    # reload tmux configuration
    bind r source-file ~/.tmux.conf \; display-message "tmux reloaded."
   '';
  };

  programs.alacritty = {
   enable = true;
   settings = {
    cursor = {
     style = {
      shape = "Underline";
     };
    };
    env = {
     TERM = "xterm-256color";
    };
    font = {
     size = 9;
     offset = {
      x = 0;
      y = 0;
     };
     normal = {
      family = "Maple Mono NF";
      style = "Regular";
     };
     bold = {
      family = "Maple Mono NF";
      style = "Bold";
     };
     italic = {
      family = "Maple Mono NF";
      style = "Italic";
     };
    };
    mouse = {
     hide_when_typing = true;
    };
    window = {
     decorations = "full";
     dynamic_padding = true;
     opacity = 1;
     startup_mode = "Windowed";
     padding = { 
      x = 10; 
      y = 10;
     };
    };
    keyboard = {
     bindings = [
      { key = "Tab";  mods = "Control" ;  chars = "\u001B[27;5;9~"; }
      { key = "Return";  mods = "Control" ;  chars = "\u001B[13;5u"; }
      { key = "Return";  mods = "Shift" ;  chars = "\u001B[13;2u"; }
      { action = "IncreaseFontSize";  key = "Plus" ;  mods = "Control|Shift"; }
     ];
    }; 
   };
  };

  programs.home-manager.enable = true;
}
