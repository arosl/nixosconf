{config, pkgs, ...}:
let
  tmuxConfig = import ./tmux.nix {
    inherit pkgs;
  };
in
{
  programs.home-manager.enable = true;

  home.username = "andreas";
  home.homeDirectory = "/home/andreas";
  
  home.stateVersion = "23.05";

  programs.tmux = tmuxConfig.programs.tmux;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  home.packages = with pkgs; [
    #browsers
    google-chrome firefox
    #chat
    mattermost-desktop telegram-desktop
    # Terminal essentials
    alacritty bat git ripgrep pass lf
    # SysAdmin
    mtr whois magic-wormhole
    #email
    mutt-wizard neomutt isync
    #editors
    vscode
  ];
}
