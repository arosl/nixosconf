# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  sops-nix,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    sops-nix.nixosModules.sops
  ];

  #sops setup
  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = "/home/andreas/.config/sops/age/keys.txt";

  sops.secrets.wireguard_13_priv = {};

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable flakes
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = ["nix-command" "flakes"];
    warn-dirty = false;
  };
  nix.package = pkgs.nixFlakes;

  # Boot parameters
  boot = {
    # Bopiotloader.
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Run latest kernel
    kernelPackages = pkgs.linuxPackages_latest;
  };
  # Define your ho# Define your hostname.stname.
  networking.hostName = "phantom";

  # Enable networkmanager
  networking.networkmanager.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall = {
    allowedUDPPorts = [51820];
    # if packets are still dropped, they will show up in dmesg
    logReversePathDrops = true;
    # wireguard trips rpfilter up suposedly
    extraCommands = ''
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 1199 -j RETURN
    '';
    extraStopCommands = ''
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 1199 -j RETURN || true
    '';
  };

  # currently routing everything to oslo as the routing with just subnets does not work
  # The problems is related to how routes is added in nixos (probably whats called loop routing)
  # And that the current setup with DNS just adds them to resolv.conf
  networking.wg-quick.interfaces = {
    wg0 = {
      address = ["10.17.150.13/24"];
      dns = ["10.47.47.50" "10.47.47.51"];
      privateKeyFile = "${config.sops.secrets.wireguard_13_priv.path}";
      peers = [
        {
          publicKey = "NcjDKFH7CEJg8PXbxZQTQmFXlax9x8+ao1/ZNXU0Rno=";
          allowedIPs = ["0.0.0.0/0" "::/0"];
          endpoint = "178.255.144.49:1199";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  # Set your time zone.
  time.timeZone = "America/Cancun";

  # Select internationalisation propertes.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = ["all"];
  #console.font = "JetBrainsMono";

  # List services that you want to enable:
  services = {
    # enable tailscale
    #tailscale.enable = true;
    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      # Enable the Gnome Desktop Environment.
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      windowManager = {
        awesome = {
          enable = true;
          luaModules = with pkgs.luaPackages; [
            luarocks # is the package manager for Lua modules
            luadbi-mysql # Database abstraction layer
          ];
        };
        xmonad = {
          enable = true;
          enableContribAndExtras = true;
        };
      };
      # Configure keymap in X11
      xkbOptions = "caps:none,caps:level3";
      extraLayouts.us-norwegian = {
        description = "English (US with Norwegian Special)";
        languages = ["eng"];
        symbolsFile = builtins.toFile "us-norwegian" ''
          default partial alphanumeric_keys
          xkb_symbols "us-norwegian" {
            include "us(basic)"            // includes the base US keys

            key <AC10> { [ semicolon, colon, oslash, Oslash ] };
            key <AC11> { [ apostrophe, quotedbl, ae, AE] };
            key <AD11> { [ bracketleft, braceleft, aring, Aring ] };
          };
        '';
      };
      layout = "us-norwegian";
      libinput.enable = true;

      # Load nvidia driver for Xorg and Wayland
      videoDrivers = ["nvidia"];
    };

    picom.enable = true;

    # Enable pipewire sound
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Enable the OpenSSH daemon.
    openssh.enable = true;

    gnome.gnome-keyring.enable = true;
    upower.enable = true;

    # Enable bluetooth service
    blueman.enable = true;
  };

  #Set console keyboard to XkbConfig
  console.useXkbConfig = true;

  # exclude some gnome packages
  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-photos
      gnome-tour
    ])
    ++ (with pkgs.gnome; [
      atomix # puzzle game
      cheese # webcam tool
      epiphany # web browser
      evince # document viewer
      geary # email reader
      gedit # text editor
      gnome-characters
      gnome-music
      gnome-terminal
      hitori # sudoku game
      iagno # go game
      tali # poker game
      totem # video player
    ]);

  # Enable sound with pipewire.
  sound.enable = true;
  security.rtkit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.andreas = {
    isNormalUser = true;
    description = "andreas";
    extraGroups = ["networkmanager" "wheel"];
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK9WYZgphn4uQ5ZqBkTwbSIk2htGe74EiANdItjgWlrM andreas@ros.land"];
    shell = pkgs.zsh;
  };
  users.users.romy = {
    isNormalUser = true;
    description = "romy";
    extraGroups = ["networkmanager"];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    age
    mosh
    pciutils
    restic
    sops
  ];
  environment.shells = with pkgs; [zsh];

  # configure different programs with options
  programs = {
    ssh.startAgent = true;
    zsh = {
      enable = true;
      ohMyZsh = {
        enable = true;
        plugins = ["git"];
        theme = "robbyrussell";
      };
    };
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      # enableSSHSupport = true;
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["FiraCode" "DroidSansMono" "JetBrainsMono"];})
    dina-font
    liberation_ttf
    mplus-outline-fonts.githubRelease
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    proggyfonts
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  # T480 hardware configs
  hardware = {
    # Enable bluetooth
    bluetooth.enable = true;
    # Use pipewire not pulse
    pulseaudio.enable = false;
    # Enable OpenGL
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    # Nvidia settings
    nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      powerManagement.enable = false;
      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Do not disable this unless your GPU is unsupported or if you have a good reason to.
      # mx150 not on the list, set to false
      open = false;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        # Make sure to use the correct Bus ID values for your system!
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
}
