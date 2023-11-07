{
  config,
  pkgs,
  nix-colors,
  ...
}: let
  tmuxConfig = import ./tmux.nix {
    inherit pkgs;
  };
  lfConfig = import ./lf.nix {
    inherit pkgs config;
  };
  deco = import ./deco/default.nix {
    inherit pkgs;
  };
  alacrittyConf = import ./features/alacritty.nix {
    inherit pkgs config;
  };
  imports = [
    nix-colors.HomeManagerModules.default
  ];
  config.colorScheme = nix-colors.colorSchemes.catppuccin-mocha;
in {
  programs = {
    home-manager.enable = true;
    alacritty = alacrittyConf.programs.alacritty;
    neomutt.enable = true; # needs config
    mbsync.enable = true; # needs config
    tmux = tmuxConfig.programs.tmux;
    lf = lfConfig.programs.lf;
    git.enable = true;
    rofi = {
      enable = true;
      terminal = "${pkgs.alacritty}/bin/alacritty";
      #theme = ./theme.rafi;
    };
  };

  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome3.adwaita-icon-theme;
      size = "16x16";
    };
    settings = {
      global = {
        monitor = 0;
        geometry = "600x50-50+65";
        shrink = "yes";
        transparency = 10;
        padding = 16;
        horizontal_padding = 16;
        font = "JetBrainsMono Nerd Font 10";
        line_height = 4;
        format = ''<b>%s</b>\n%b'';
      };
    };
  };

  home = {
    username = "andreas";
    homeDirectory = "/home/andreas";
    stateVersion = "23.05";
    packages = with pkgs; [
      bat-extras.batdiff
      bat-extras.batgrep
      bat-extras.batpipe
      bat-extras.batwatch
      bat-extras.prettybat
      brightnessctl
      comma
      deco
      dig
      element-desktop
      eww
      eza
      feh
      file
      firefox
      gimp
      google-chrome
      inkscape
      isync
      jq
      libreoffice
      magic-wormhole
      maim
      manix
      mattermost-desktop
      mpv
      mtr
      neofetch
      nix-tree
      pass
      picom
      playerctl
      ripgrep
      spotify
      telegram-desktop
      tint2
      tree
      unclutter
      unzip
      vlc
      vscode
      whois
      wtf
      xclip
      xsel
      xxd
    ];
  };
}
