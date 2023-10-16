{
  config,
  pkgs,
  ...
}: {
  programs.home-manager.enable = true;

  home.username = "romy";
  home.homeDirectory = "/home/romy";

  home.stateVersion = "23.05";

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  home.packages = with pkgs; [
    #browsers
    google-chrome
    firefox
    #chat
    telegram-desktop
    #editors
    vscode
    #3d printing
    prusa-slicer
    super-slicer
    cura
  ];
}
