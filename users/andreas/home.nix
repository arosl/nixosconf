{
  config,
  pkgs,
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
in {
  programs.home-manager.enable = true;

  home.username = "andreas";
  home.homeDirectory = "/home/andreas";

  home.stateVersion = "23.05";

  programs.tmux = tmuxConfig.programs.tmux;
  programs.lf = lfConfig.programs.lf;
  programs.git.enable = true;

  home.packages = with pkgs; [
    deco
    #browsers
    google-chrome
    firefox
    #chat
    mattermost-desktop
    telegram-desktop
    element-desktop
    # Terminal essentials
    alacritty
    bat
    eza
    wtf
    ripgrep
    pass
    neofetch
    nix-tree
    xsel
    xclip
    # SysAdmin
    mtr
    whois
    magic-wormhole
    #email
    mutt-wizard
    neomutt
    isync
    #editors
    vscode
    #other
    vlc
    mpv
    gimp
    inkscape
    libreoffice
  ];
}
