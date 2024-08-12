{
  description = "Nix expressions for tools for the reMarkable tablet";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    inputs.mxc_epdc_fb_damage = {
      url = "github:peter-sa/mxc_epdc_fb_damage/v0.0.1";
      flake = false;
    };
    inputs.rM-vnc-server = {
      url = "github:peter-sa/rM-vnc-server/v0.0.1";
      flake = false;
    };
    inputs.gst-libvncclient-rfbsrc = {
      url = "github:peter-sa/gst-libvncclient-rfbsrc/v0.0.1";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: let
      srcs = builtins.mapAttrs (k: v: v // {drv = v + "/derivation.nix";}) inputs;
      rmPkgs = import ./rM {inherit srcs hostPkgs;};
      hostPkgs = import ./host {inherit srcs rmPkgs;};
    in {
      packages-linux = {
        inherit (rmPkgs.linuxPackages) mxc_epdc_fb_damage;
        inherit (rmPkgs) rM-vnc-server chessmarkable retris evkill;
        inherit (rmPkgs) remarkable_news;
        inherit (rmPkgs) remarkable-fractals;
        inherit (hostPkgs) gst-libvncclient-rfbsrc;
      };

      overlay = final: prev: {
        inherit rmPkgs hostPkgs;
      };
    });
}
