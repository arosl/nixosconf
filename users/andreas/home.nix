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
      comment-nvim
    ];

    extraLuaConfig = ''
      vim.g.mapleader = ' '
      vim.g.maplocalleader = ' '

      vim.o.clipboard = 'unnamedplus'
      vim.o.relativenumber = true
      vim.o.signcolumn = 'yes'

      vim.o.tabstop = 4
      vim.o.shiftwith = 4

      vim.o.updatetime = 300

      vim.o.termguicolors = true

      vim.o.mouse = 'a'

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
