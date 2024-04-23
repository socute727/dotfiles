# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Yekaterinburg";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  #services.xserver.displayManager.sddm.enable = true;
  #services.xserver.displayManager.sddm.wayland.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  #services.xserver.displayManager.plasma5.enable = true;
  #services.xserver.defaultSession = "plasma";

  # Kde setup
  #environment.plasma5.excludePackages = with pkgs.libsForQt5; [
  #    plasma-browser-integration
  #    konsole
  #    oxygen
  #];
  
  # Zsh
   programs.zsh.enable = true;
   users.defaultUserShell = pkgs.zsh;
  
  # Hyprland
   programs.hyprland.enable = true;
   environment.sessionVariables = rec {
       WLR_NO_HARDWARE_CURSORS = "1";
   };
                               
  # Nvidia
   nixpkgs.config.allowUnfree = true;
   hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;
   hardware.nvidia = {

   # Modesetting is required.
   modesetting.enable = true;

   # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
   # Enable this if you have graphical corruption issues or application crashes after waking
   # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
   # of just the bare essentials.
   #powerManagement.enable = false;

   # Fine-grained power management. Turns off GPU when not in use.
   # Experimental and only works on modern Nvidia GPUs (Turing or newer).
   #powerManagement.finegrained = false;

   # Use the NVidia open source kernel module (not to be confused with the
   # independent third-party "nouveau" open source driver).
   # Support is limited to the Turing and later architectures. Full list of 
   # supported GPUs is at: 
   # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
   # Only available from driver 515.43.04+
   # Currently alpha-quality/buggy, so false is currently the recommended setting.
   #open = false;

   # Enable the Nvidia settings menu,
        # accessible via `nvidia-settings`.
   nvidiaSettings = true;

   # Optionally, you may need to select the appropriate driver version for your specific GPU.
   #package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

  
  # Enable OpenGL
   hardware.opengl = {
     enable = true;
     driSupport = true;
     driSupport32Bit = true;
   };

  # Configure keymap in X11
   services.xserver.xkb.layout = "us, ru";
   services.xserver.xkb.options = "eurosign:shifts";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
   sound.enable = true;
   hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.uwu = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
       firefox
       tree
     ];
   };
  
  # Fonts
  fonts.packages = with pkgs; [
     noto-fonts
     noto-fonts-cjk
     noto-fonts-emoji
     liberation_ttf
     fira-code
     office-code-pro
     font-awesome
     fira-code-symbols
     mplus-outline-fonts.githubRelease
     dina-font
     proggyfonts
  ];
 
 # List packages installed in system profile. To search, run:  
 # $ nix search wget
   environment.systemPackages = with pkgs; [
     vim 
     wget
     hyprland
     kitty
     wofi
     waybar
     telegram-desktop
     gnome.nautilus
     steam
    # Idk but it seems that discord only works if gl is turned on lol
    # I don't like this mess over here btw 
    (pkgs.writeShellApplication {
      name = "discord";
      text = "${pkgs.discord}/bin/discord --use-gl=desktop";
    })
    (pkgs.makeDesktopItem {
      name = "discord";
      exec = "discord";
      desktopName = "Discord";
    })
     vscode
     python3
     gcc
     pipx
     obs-studio
     grimblast
     hyprpaper
     oh-my-zsh
     zsh
     neofetch
     pamixer
     cava
     pavucontrol
     htop
     jre8
     jdk21
   ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

