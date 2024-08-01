{ config, lib, pkgs, pkgs-unstable, ... }:

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
      postgresql
      tealdeer
      terraform
      jetbrains.datagrip
      jetbrains.datagrip
      postman
      tmux
      starship
      zoxide
      atuin
      dust
      fd
      ripgrep

      yazi
      ueberzugpp # image viewer
      ffmpegthumbnailer # video thumbnails
      poppler # pdf reder library
     
      # window manager
      ncmpcpp
      zathura
      rclone
      rsync
      mpd
      mpv
      bspwm
      sxhkd
      picom

      dunst
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
    ])
   ];
   file = {};
   sessionVariables = {};
  };

  xsession.windowManager.bspwm = {
   enable = true;
   monitors = {
    HDMI2 = [
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
    "picom"
    "dunst"
    "udiskie"
    "xset -dpms"
    "xsetroot -cursor_name left_ptr"
    "pgrep -x sxhkd > /dev/null || sxhkd -m -1"
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

  services = {
   dunst = {
    enable = true;
    settings = {
     global = {
      font = "Maple Mono NF 9";
      separator_height = "15";
      frame_width = "1";
      frame_color = "#21203e";
      separator_color = "#eff1f5";
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
     "super + m" = "bspc rule -a St -o state=floating follow=on center=true rectangle=700x400+0+0 && st -e fish -c 'ncmpcpp'";
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
     "shift + BackSpace" = "mpc toggle";
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

  programs.git = {
   enable = true;
   userName = "Bryant Santiago";
   userEmail = "pazbryant@proton.me";
   extraConfig = {
    core = {
     editor = "nvim";
    };
   };
   aliases = {
    glg = "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --all";
    ggpush = "git push origin $(git rev-parse --abbrev-ref HEAD)";
    ggpull = "git pull origin $(git rev-parse --abbrev-ref HEAD)";
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
   sessionVariables = {
    EDITOR="nvim";
    VISUAL="nvim";
    TERMINAL="st";
    SUDO_EDITOR="nvim";
    BROWSER="firefox";
    # GTK_THEME="firefox";
    VIDEO="mpv";
    COLORTERM="truecolor";
    OPENER="xdg-open";
    PAGER="less";
    BAT_PAGER="less";
    WM="bspwm";
    MANPAGER="nvim +Man";
    SXHKD_SHELL="zsh";
   };
    profileExtra = "startx";
    shellAliases = {
     sp = "systemctl suspend";
     vi = "NVIM_APP_NAME='minimal' nvim";
     transes = "trans en:es";
     sudo = "sudo ";
     rel = "xrdb merge ~/.Xresources && kill -USR1 $(pidof st)";
     cr7 = "mpv ~/Videos/cr7/dios.mp4";
     sht = "shutdown now";
     clear = "clear; printf '\\033[4q'";
     ff = "fastfetch";
     lzg = "lazygit";
     dh = "rm ~/.history.db ~/.zsh_history";
    };
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
    history_filter = [ "^clear" "^z" ];
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
   shell = "${pkgs.zsh}/bin/zsh";
   baseIndex = 1;
   prefix = "C-Space";
   mouse = true;
   keyMode = "vi";
   escapeTime = 0;
   historyLimit = 10000;
   sensibleOnTop = false;
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
      x = 1;
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
