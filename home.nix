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
      syncthing
      zsh

      # theme & fonts
      capitaine-cursors
      colloid-gtk-theme
      colloid-icon-theme
     
      # development
      piper
      bottom
      less
      vscode
      gopass

      unrar
      unzip
      go
      fnm
      rustup
      docker
      docker-compose
      docker-buildx
      fzf
      jq
      lazygit
      lazydocker
      postgresql
      tealdeer
      terraform
      jetbrains.datagrip
      jetbrains.datagrip
      postman
      starship
      zoxide
      atuin
      dust
      fd
      ripgrep
      tmux

      yazi
      ueberzugpp # image viewer
      ffmpegthumbnailer # video thumbnails
      poppler # pdf reder library
     
      # window manager
      zathura
      rsync

      mpd
      ncmpcpp

      mpv
      bspwm
      sxhkd

      dunst
      bandwhich
      spotdl
      ffmpeg
      picom
      # libnotify

      pcmanfm
      pavucontrol # need to be pipewire service to be activated
      maim
      rofi
      polybar
      feh
      udiskie # need udev2 service to be activated
      translate-shell
     
      # extra
      obsidian
      qbittorrent
      discord 
    ])
    
    (with pkgs-unstable;[
     neovim
     rclone
    ])

    (with st-pkgs;[
     st-snazzy
    ])
   ];
   file = {};
   sessionVariables = {};
  };

  xsession.windowManager.bspwm = {
   enable = true;
   monitors = {
    HDMI-2 = [
      "1"
      "2"
      "3"
      "4"
      "5"
      "6"
      "7" 
    ];
   };
   settings = {
     top_padding = "0";
     bottom_padding = "11";
     window_gap = "10";
     split_ratio = "0.50";
     gapless_monocle = "true";
     borderless_monocle = "true";
     focus_follows_pointer = "false";
     border_width = "3";
     focused_border_color = "#ffaf4d";
     normal_border_color = "#c7c7c7";
   };
   startupPrograms = [
    "dunst"
    "picom"
    "udiskie"
    "xset -dpms"
    "xsetroot -cursor_name left_ptr"
    "pgrep -x sxhkd > /dev/null || sxhkd -m -1"
    "pgrep -x mpd >/dev/null || mpd"
    "feh --bg-fill /home/bryant/Downloads/1345196.png"
   ];
  };

  qt = {
   enable = true;
   platformTheme = {
    name = "Maple Mono NF";
   };
   style = {
    name = "breeze";
   };
  };

  gtk = {
   enable = true;
   font = {
    name = "Maple Mono NF";
    size = 9;
   };
   theme = {
    name = "Colloid-Light";
   };
   cursorTheme = {
    name = "capitaine-cursors-white";
   };
   iconTheme = {
    name = "Colloid-light";
   };
  };

  xdg = {
   userDirs = {
    enable = true;
   };
  };

  services = {
   picom = {
    enable = true;
   };
   mpd = {
    enable = true;
    musicDirectory = "~/Music";
    network = {
     startWhenNeeded = true;
    };
    extraConfig = ''
     audio_output {
      type "pipewire"
      name "PipeWire Sound Server"
     }
    '';
   };

   dunst = {
    enable = true;
    settings = {
     global = {
      font = "Maple Mono NF 9";
      separator_height = "15";
      frame_width = "1";
      frame_color = "#21203e";
      separator_color = "#00000000";
      mouse_left_click = "do_action, close_current";
      mouse_right_click = "close_all";
      browser = "#{pkgs.firefox}/bin/firefox";
     };
     urgency_low = {
      background = "#eff1f5";
      foreground = "#4c4f69";
     };
     urgency_normal = {
      background = "#dce0e8";
      foreground = "#4c4f69";
     };
     urgency_critical = {
      background = "#d20f39";
      foreground = "#ffffff";
     };
    };
   };
   sxhkd = {
    enable = true;
    keybindings = {
     # main bspwm key binds and sxhkd
     "super + q" = "bspc node -c";
     "super + alt + {q,r}" = "bspc {quit,wm -r}";
     "super + shift + Escape" = "pkill -USR1 -x sxhkd && dunstify 'sxhkd' 'Reloaded successfully'";
     "super + f" = "bspc node -t '~fullscreen'";
     "super + {_,shift + }{h,j,k,l}" = "bspc node -{f,s} {west,south,north,east}";
     "super + {n,p}" = "bspc node -f {next,prev}.local.!hidden.window";
     "super + shift + {p,n}" = "bspc desktop -f {prev,next}.local";
     "super + Tab" = "bspc desktop -f last";
     "super + {bracketleft,braceleft,parenleft,percent,equal,ampersand,parenright}" = "bspc desktop -f '^{1-7}'";
     "super + shift {1-7}" = "bspc node -d '^{1-7}'";
     "super + w" = "bspc desktop -l next";
     "super + shift + w" = "bspc node -t \\~floating";
     # main personal key bindings
     "super + a" = "pavucontrol";
     "super + e" = "pcmanfm";
     "super + t" = "st";
     "super + shift + t" = "alacritty";
     "super + Return" = "firefox -P Personal";
     "super + shift + Return" = "firefox -P Work";
     "super + d" = "rofi -show drun -show-icons";
     "super + shift + d" = "rofi -show window -show-icons";
     "super + m" = "bspc rule -a St -o state=floating follow=on center=true rectangle=700x400+0+0 && st -e zsh -c 'ncmpcpp'";
     # scripts
     "super + x" = "/home/bryant/.dotfiles/bin/select_and_execute.sh";
     "super + alt + w" = "/home/bryant/.dotfiles/bin/sh/set-wallpaper.sh";
     "super + b" = "/home/bryant/.dotfiles/bin/sh/set-brightness.sh";
     "super + space" = "/home/bryant/.dotfiles/bin/sh/select-keyboard.sh";
     # print
     "Print" = "maim --select | xclip -selection clipboard -t image/png && dunstify 'Save' 'Clipboard'";
     "super + Print" = "maim | xclip -selection clipboard -t image/png && dunstify 'Save' 'Clipboard'";
     "alt + Print" = "./bin/sh/take-streenshots.sh cropped";
     "shift + Print" = "./bin/sh/take-streenshots.sh full";
     # volume
     # resize windows
     "super + alt + l" = "bspc node -z right 20 0 || bspc node -z left 20 0";
     "super + alt + h" = "bspc node -z right -20 0 || bspc node -z left -20 0";
     "super + alt + j" = "bspc node -z bottom 0 20 || bspc node -z top 0 20";
     "super + alt + k" = "bspc node -z bottom 0 -20 || bspc node -z top 0 -20";
     # hidden and show
     "super + v" = "bspc node -g hidden";
     "super + shift + v" = "bspc node {,$(bspc query -N -n .hidden | tail -n1)} -g hidden=off";
     "super + shift + space" = "bspc query -N -n .local.window | xargs -I ID bspc node ID -g hidden";
     # move floating window
     "super + {Left,Down,Up,Right}" = "bspc node -v {-30 0,0 30,0 -30,30 0}";
    };
   };
  };

  programs.rofi = {
   enable = true;
   terminal = "\${pkgs.st}/bin/st";
   extraConfig = {
    modi = "window";
    terminal = "st";
    hide-scrollbar = true;
    display-run = "";
    display-drun = "";
    display-window = "";
    show-match = true;
   };
   theme = "/home/bryant/.dotfiles/theme.rasi";
  };

  programs.fzf = {
   enable = true;
   enableZshIntegration = true;
   defaultCommand = "fd --type f";
   defaultOptions = [
    "--preview-window noborder"
    "--height=50%"
   ];
   colors = {
    bg = "#eff1f5";
   "bg+" = "#ccd0da";
    spinner = "#dc8a78";
    hl = "#d20f39";
    fg = "#4c4f69";
    header = "#d20f39";
    info = "#8839ef";
    pointer = "#dc8a78";
    marker = "#dc8a78";
   "fg+" = "#4c4f69";
    prompt = "#8839ef";
   "hl+" = "#d20f39";
   };
  };

  programs.ncmpcpp = {
   enable = true;
   mpdMusicDir = "/home/bryant/Music";
   settings = {
    # general
    ncmpcpp_directory = "~/.config/ncmpcpp";
    
    # mpd
    mpd_host = "127.0.0.1";
    mpd_port = "6600";
    
    # music visualizer
    visualizer_data_source = "/tmp/mpd.fifo";
    visualizer_output_name = "my_fifo";
    visualizer_in_stereo = "yes";
    
    # starting
    playlist_display_mode = "columns";
    browser_display_mode = "columns";
    search_engine_display_mode = "columns";
    playlist_editor_display_mode = "columns";
    autocenter_mode = "yes";
    centered_cursor = "yes";
    user_interface = "classic";
    follow_now_playing_lyrics = "yes";
    lyrics_fetchers = "tekstowo, azlyrics, genius, musixmatch, sing365, metrolyrics, justsomelyrics, jahlyrics, plyrics, zeneszoveg, internet";
    external_editor = "nvim";
    main_window_color = "default";
    
    # ui
    header_visibility = "no";
    statusbar_visibility = "yes";
    titles_visibility = "yes";
    enable_window_title = "yes";
   };
   bindings = [
     { key = "="; command = "show_clock"; }
     { key = "+"; command = "volume_up"; }
     { key = "-"; command = "volume_down"; }
     { key = "j"; command = "scroll_down"; }
     { key = "k"; command = "scroll_up"; }
     { key = "ctrl-u"; command = "page_up"; }
     { key = "ctrl-d"; command = "page_down"; }
     { key = "h"; command = "previous_column"; }
     { key = "l"; command = "next_column"; }
     { key = "."; command = "show_lyrics"; }
     { key = "n"; command = "next_found_item"; }
     { key = "N"; command = "previous_found_item"; }
     { key = "g"; command = "move_home"; }
     { key = "G"; command = "move_end"; }
     { key = "0"; command = "replay_song"; }
     { key = "ctrl-f"; command = "page_down"; }
     { key = "ctrl-b"; command = "page_up"; }
     { key = "D"; command = [ "delete_playlist_items" "delete_browser_items" "delete_stored_playlist" ]; }
   ];
  };
  
  programs.zathura = {
   enable = true;
   options = {
    "collection-clipboard" = "clipboard";
    "incremental-search" = "true";
    "seach-hadjust" = "true";
    "adjust-open" = "width";
    "font" = "Maple Mono NF Bold 9";
   };
   mappings = {
    "[normal] f" = "toggle_fullscreen";  
    "[fullscreen] f" = "toggle_fullscreen";  
   };
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

  programs.mpv = {
   enable = true;
   config = {
    sub-auto="fuzzy";
    sub-font="Maple Mono NF";
    sub-font-size=32;
    sub-ass-override="force";
   };
  };

  programs.zoxide = {
   enable = true;
   enableZshIntegration = true;
   options = [ "--cmd cd" ];
  };	

  programs.bottom = {
   enable = true;
   settings = {
    colors = {
     table_header_color = "#dc8a78";
     all_cpu_color = "#dc8a78";
     avg_cpu_color = "#e64553";
     cpu_core_colors = [
      "#d20f39"
      "#fe640b"
      "#df8e1d"
      "#40a02b"
      "#209fb5"
      "#8839ef"
     ];
     ram_color = "#40a02b";
     swap_color = "#fe640b";
     rx_color = "#40a02b";
     tx_color = "#d20f39";
     widget_title_color = "#dd7878";
     border_color = "#acb0be";
     highlighted_border_color = "#ea76cb";
     text_color = "#4c4f69";
     graph_color = "#6c6f85";
     cursor_color = "#ea76cb";
     selected_text_color = "#dce0e8";
     selected_bg_color = "#8839ef";
     high_battery_color = "#40a02b";
     medium_battery_color = "#df8e1d";
     low_battery_color = "#d20f39";
     gpu_core_colors = [
       "#209fb5"
       "#8839ef"
       "#d20f39"
       "#fe640b"
       "#df8e1d"
       "#40a02b"
     ];
     arc_color = "#04a5e5";
    };
   };
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
    GTK_THEME="Colloid-Light";
    VIDEO="mpv";
    COLORTERM="truecolor";
    OPENER="xdg-open";
    PAGER="less";
    BAT_PAGER="less";
    WM="bspwm";
    MANPAGER="nvim +Man";
    SXHKD_SHELL="zsh";
    MPD_HOST="/run/user/1000/mpd/socket";
   };
   shellAliases = {
    sp = "systemctl suspend";
    vi = "NVIM_APP_NAME='minimal' nvim";
    transes = "trans en:es";
    sudo = "sudo ";
    rel = "xrdb merge ~/.Xresources && kill -USR1 $(pidof st)";
    cristiano = "mpv ~/Videos/cr7/dios.mp4";
    sht = "shutdown now";
    ff = "fastfetch";
    lzg = "lazygit";
    lzd = "lazydocker";
    dh = "rm ~/.history.db ~/.zsh_history";
    glg = "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --all";
    ggpush = "git push origin $(git rev-parse --abbrev-ref HEAD)";
    ggpull = "git pull origin $(git rev-parse --abbrev-ref HEAD)";
   };
   profileExtra = ''
    [[ -z $DISPLAY && $(tty) = /dev/tty1 ]] && startx
   '';
  };

  programs.atuin = {
   enable = true;
   enableZshIntegration = true;
   settings = {
    db_path = "~/.history.db";
    filter_mode = "host"; # session/global/directory
    key_path = "~/.key";
    session_path = "~/.session";
    dialect = "us";
    style = "compact";
    inline_height = 10;
    auto_sync = false;
    history_filter = [ "^clear" "^cd" ];
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

  programs.starship = {
   enable = true;
   enableZshIntegration = true;
   settings = {
    add_newline = false;
    line_break = {
     disabled = true;
    };
    directory = {
     truncation_length = 2;
    };
    character = {
     success_symbol = "[](bold)";
     error_symbol = "[!](bold)";
     vimcmd_symbol = "[](bold)";
    };                            
    git_branch = {
     format = "[$branch]($style) ";
    };
    git_status = {
     disabled = true;
    };
   };
  };

  programs.tmux = {
   enable = true;
   sensibleOnTop = false;
   secureSocket = false;
   extraConfig = ''
    set -g default-shell "\${pkgs.zsh}/bin/zsh"

    # set prefix
    unbind-key C-b
    set -g prefix C-Space
    
    # set mouse mode on
    set -g mouse on
    
    # set focus event (nvim)
    set-option -g focus-events on
    
    # set vim key binds
    set -g mode-keys vi
    set -s set-clipboard on
    set-option -s set-clipboard on
    
    # disable status bar at start
    set -g status off
    bind-key b set-option status
    
    # delay after prefix
    set -sg escape-time 0
    
    # set true colors compatibility
    set -g default-terminal "tmux-256color"
    set -sa terminal-overrides ',*:RGB'
    
    # enter copy mode with "v"
    bind 'v' copy-mode
    bind-key -T copy-mode-vi v send-keys -X begin-selection
    
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
    
    # set full screen
    unbind-key z
    bind-key f resize-pane -Z
    
    # panel border type
    set -g pane-border-lines simple
    
    # terminal history limit
    set-option -g history-limit 5000
    
    # vim-like pane switching
    bind ^ last-window
    bind k select-pane -U
    bind j select-pane -D
    bind h select-pane -L
    bind l select-pane -R
    
    # bspwm layout switching
    bind-key 1 select-layout even-horizontal
    bind-key 2 select-layout even-vertical
    bind-key 3 select-layout main-horizontal
    bind-key 4 select-layout main-vertical
    bind-key 5 select-layout tiled
    
    # vim panel resizing
    bind-key -r C-j resize-pane -D
    bind-key -r C-k resize-pane -U
    bind-key -r C-h resize-pane -L
    bind-key -r C-l resize-pane -R
    
    # kill other sessions
    bind-key K run-shell /home/bryant/.dotfiles/bin/sh/tmux/tmux-kill-other-sessions.sh
    bind-key k run-shell /home/bryant/.dotfiles/bin/sh/tmux/tmux-kill-other-windows.sh
    
    bind-key D run-shell "\
    /home/bryant/.dotfiles/bin/sh/tmux-new-session.sh /home/bryant/Documents/github/dotfiles/"
    
    bind-key H run-shell "/home/bryant/.dotfiles/bin/sh/tmux/tmux-new-session.sh /home/bryant/"
    
    bind-key T run-shell "/home/bryant/.dotfiles/bin/sh/tmux/tmux-new-session.sh \
    /home/bryant/Documents/github/notes/"
    
    bind-key N run-shell "/home/bryant/.dotfiles/bin/sh/tmux/tmux-new-session.sh \
    /home/bryant/Documents/github/codeeditors/nvim/"
    
    bind-key P run-shell "/home/bryant/.dotfiles/bin/sh/tmux/tmux-new-session.sh \
    /home/bryant/.password-store/"
    
    bind-key F run-shell "tmux neww /home/bryant/.dotfiles/bin/sh/tmux/tmux-new-session.sh"
    
    bind-key G run-shell "/home/bryant/.dotfiles/bin/sh/tmux/tmux-new-session.sh \
    /home/bryant/.password-store/"
    
    bind-key S run-shell "tmux neww /home/bryant/.dotfiles/bin/sh/tmux/tmux-session-selector.sh"
    
    # reload tmux configuration
    bind r source-file /home/bryant/.config/tmux/tmux.conf \; display-message "tmux reloaded."
   '';
  };

  programs.alacritty = {
   enable = true;
   settings = {
    colors = {
     primary = {
      background = "#eff1f5";
      foreground = "#4c4f69";
      dim_foreground = "#8c8fa1";
      bright_foreground = "#4c4f69";
     };
     cursor = {
      text = "#eff1f5";
      cursor = "#dc8a78";
     };
     vi_mode_cursor = {
      text = "#eff1f5";
      cursor = "#7287fd";
     };
     search = {
      matches = {
       foreground = "#eff1f5";
       background = "#6c6f85";
      };
      focused_match = {
       foreground = "#eff1f5";
       background = "#40a02b";
      };
     };
     footer_bar = {
      foreground = "#eff1f5";
      background = "#6c6f85";
     };
     hints = {
      start = {
       foreground = "#eff1f5";
       background = "#df8e1d";
     };
      end = {
       foreground = "#eff1f5";
       background = "#6c6f85";
      };
     };
     selection = {
      text = "#eff1f5";
      background = "#dc8a78";  
     };
     normal = {
      black = "#bcc0cc";
      red = "#d20f39";
      green = "#40a02b";
      yellow = "#df8e1d";
      blue = "#1e66f5";
      magenta = "#ea76cb";
      cyan = "#179299";
      white = "#5c5f77";
     };
     bright = {
      black = "#acb0be";
      red = "#d20f39";
      green = "#40a02b";
      yellow = "#df8e1d";
      blue = "#1e66f5";
      magenta = "#ea76cb";
      cyan = "#179299";
      white = "#6c6f85";
     };
     dim = {
      black = "#bcc0cc";
      red = "#d20f39";
      green = "#40a02b";
      yellow = "#df8e1d";
      blue = "#1e66f5";
      magenta = "#ea76cb";
      cyan = "#179299";
      white = "#5c5f77";
     };
     indexed_colors = [
      { index = 16; color = "#fe640b"; }
      { index = 17; color = "#dc8a78"; }
     ];
    };
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
