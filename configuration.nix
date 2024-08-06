{ config, lib, pkgs, pkgs-unstable, ... }:

{
  imports =
  [ 
   ./hardware-configuration.nix
  ];

  environment = {
   systemPackages = lib.concatLists [
    (with pkgs; [
      parted
      ventoy
      neovim
      killall
    ])
    (with pkgs-unstable; [
    ])
   ];
   shells = with pkgs; [ zsh ];
   variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";   
   };
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
   extraLocaleSettings =  {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
   };
  };
  console = {
     font = "Lat2-Terminus16";
     useXkbConfig = true; # use xkb.options in tty.
  };
  services = {
   displayManager = {
    defaultSession = "none+bspwm";
    autoLogin = {
     enable = true;
     user = "bryant";
    };
   };
   udisks2 = {
    enable = true; # needed for udiskie
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
     useDefaultShell = true;
     isNormalUser = true;
     extraGroups = [ 
      "wheel"
      "networkmanager" 
      "docker"
      ];
    }; 
   };
  };

  fonts = {
   enableDefaultPackages = true;
   packages = [
    pkgs.font-awesome
    pkgs.font-awesome
    pkgs.maple-mono-NF
    pkgs.overpass
    pkgs.noto-fonts
    pkgs.noto-fonts-cjk-sans
   ];
   fontconfig = {
    enable = true;
    antialias = true;
    hinting = {
     enable = true;
    };
    defaultFonts = {
     serif = [
     "Overpass"
     "Noto Sans"
     "Noto Sans CJK KR"
     "Noto Sans CJK JP"
     "Noto Sans CJK SC"
     "Noto Sans CJK TC"
     "Noto Sans Arabic"
     ];
     sansSerif = [
     "Overpass"
     ];
     monospace = ["Maple Mono NF"];
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
   zsh = { 
    enable = true;
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
   dconf = {
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
  };
  virtualisation = {
   docker = {
    enable = true;
    rootless = {
    enable = true;
    setSocketVariable = true;
    };
   };
  };

  system.stateVersion = "24.05";
  nix.settings.experimental-features = ["nix-command" "flakes"];
}
