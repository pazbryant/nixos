{ config, lib, pkgs, pkgs-unstable, ... }:

{
  imports =
  [ 
   ./hardware-configuration.nix
  ];

  environment = {
   systemPackages = lib.concatLists [
    (with pkgs; [
      tree
      parted
      ventoy
    ])
    (with pkgs-unstable; [])
   ];
   shells = with pkgs; [ zsh ];
  };

  boot = {
   loader = {
    systemd-boot = {
     enable = true;
    };
    efi = {
     canTouchEfiVariables = true;
    };
    grub = {
     device = "nodev";
    };
    grub = {
     efiSupport = true;
    };
   };
  };


  networking = {
   networkmanager = {
    enable = true;
   };
  };

  time = {
   timeZone = "Mexico/General";
  };

  i18n = {
   defaultLocale = "en_US.UTF-8";
  };

  console = {
     font = "Lat2-Terminus16";
     useXkbConfig = true; # use xkb.options in tty.
  };

  services = {
   displayManager = {
    defaultSession = "none+bspwm";
    autoLogi = {
     enable = true;
     user = "bryant";
    };
   };
   udisks2 = {
    enable = true;
   };
   ratbagd = {
    enable = true; # needed for piper
   };
   openssh = {
    enable = true;
   };
   pipewire = {
     enable = true;
     pulse = {
      enable = true;
     };
   };
   xserver = {
    enable = true;
    videoDrivers = [ 
     "modesetting"  # intel
    ];
    windowManager = {
     bspwm = {
      enable = true;
     };
    };
    displayManager = {
     startx = {
      enable = true;
     };
     lightdm = {
      enable = false;
     };
    };
    autoRepeatDelay = 200;
    autoRepeatInterval = 30;
    xkb = {
     layout = "bryant-dvorak,bryant-dvorak-itl";

     extraLayouts = { 
      bryant-dvorak = {
       description = "Bryant DVRK";
       languages = ["eng"];
       symbolsFile = /home/bryant/.dotfiles/bryant-dvorak;
      };

      bryant-dvorak-itl = { 
       description = "Bryant DVRK Itl";
       languages = ["eng"];
       symbolsFile = /home/bryant/.dotfiles/bryant-dvorak-itl;
      };
     };
    };
   };
  };
  
  users = {
   defaultUserShell = pkgs.zsh;
   users = {
    bryant = {
     isNormalUser = true;
     extraGroups = [ 
      "wheel"
      "networkmanager" 
      "video"
      "input"
      ];
    }; 
   };
  };

  fonts = {
   enableDefaultPackages = true;
   packages = [
    pkgs.overpass
    pkgs.font-awesome
    pkgs.maple-mono-NF
   ];
   fontconfig = {
    enable = true;
    antialias = true;
    hinting = {
     enable = true;
    };
    defaultFonts = {
     serif = ["Overpass" "DejaVu Serif"];
     sansSerif = ["Overpass" "DevaVu Sans"];
     monospace = ["Maple Mono NF" "DejaVu Sans Mono"];
     emoji = [
     "Font Awesome 6 Free" 
     "Font Awesome 6 Free Solid" 
     "Font Awesome 6 Brands"
     "Maple Mono NF"
     ];
    };
   };
  };

  programs = {
   dconf = {
    enable = true;
   };
  };

  programs = {
   zsh = {
    enable = true;
   }; 
   mtr = {
    enable = true;
   };
   gnupg = {
    agent = {
     enable = true;
     enableSSHSupport = true;
    };
   };
   neovim = {
    enable = true;
    defaultEditor = true;
    configure = {
     customRC = ''
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
   };
  };

  virtualisation = {
   docker = {
    enable = true;
   };
  };

  system.stateVersion = "24.05";
  nix.settings.experimental-features = ["nix-command" "flakes"];
}
