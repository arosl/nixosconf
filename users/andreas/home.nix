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
  programs = {
    home-manager.enable = true;
    tmux = tmuxConfig.programs.tmux;
    lf = lfConfig.programs.lf;
    git.enable = true;
  };

  home = {
    username = "andreas";
    homeDirectory = "/home/andreas";
    stateVersion = "23.05";
    packages = with pkgs; [
      alacritty
      bat
      deco
      dig
      element-desktop
      eza
      file
      firefox
      gimp
      google-chrome
      inkscape
      isync
      libreoffice
      magic-wormhole
      manix
      mattermost-desktop
      mpv
      mtr
      mutt-wizard
      neofetch
      neomutt
      nix-tree
      pass
      ripgrep
      telegram-desktop
      tree
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
