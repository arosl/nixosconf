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
      unzip
      file
      # SysAdmin
      mtr
      whois
      magic-wormhole
      xxd
      tree
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
  };
}
