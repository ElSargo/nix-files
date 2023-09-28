{ pkgs, ... }: {
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
  environment.systemPackages = with pkgs; [
    webp-pixbuf-loader
    poppler
    ffmpegthumbnailer
  ];
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];
  };

}
