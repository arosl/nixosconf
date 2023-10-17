{
  config,
  pkgs,
  ...
}: let
  tmuxConfig = import ./tmux.nix {
    inherit pkgs;
  };
  lfConfig = import ./lf.nix {
    inherit pkgs config ;
  };
in {
  programs.home-manager.enable = true;

  home.username = "andreas";
  home.homeDirectory = "/home/andreas";

  home.stateVersion = "23.05";

  programs.tmux = tmuxConfig.programs.tmux;
  programs.lf = lfConfig.programs.lf;
  programs.git.enable = true;
  programs.neovim = {
    
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      plenary-nvim
      gruvbox-material
      mini-nvim
    ];
    
    extraConfig = 
      ''
      set number
      set listchars=tab:→\ ,space:·,nbsp:␣,trail:•,eol:¶,precedes:«,extends:»
      '';
  };

  home.packages = with pkgs; [
    #browsers
    google-chrome
    firefox
    #chat
    mattermost-desktop
    telegram-desktop
    # Terminal essentials
    alacritty
    bat
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
