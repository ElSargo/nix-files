{ pkgs, palette, terminal, ... }:
let pk = name: "${pkgs.${name}}/bin/${name}";
in {
  home.packages = with pkgs; [ networkmanagerapplet ];
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = {
      mainbar = {
        spacing = 4;
        modules-left = [ "wlr/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [
          "custom/eye_saver"
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "battery"
          "custom/logout"
          "tray"
        ];
        "custom/eye_saver" = {
          format = "👁";
          on-click = "${pk "fish"} -c toggle_eye_saver";
        };
        "custom/logout" = {
          format = "⏼";
          on-click = "${pk "wlogout"}";
        };
        "custom/gttfg" = { format = "Go to the fucking gym!"; };
        "wlr/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          sort-by-number = true;
        };
        "clock" = {
          interval = 1;
          format = "{:%T}";
        };
        "cpu" = {
          format = " {usage}%";
          tooltip = false;
          on-click = "${terminal} -e htop";
        };
        "memory" = {
          format = " {}%";
          on-click = "${terminal} -e htop";
        };
        "battery" = {
          states = {
            good = 95;
            warning = 30;
            critical = 1;
          };
          format = "{capacity}% {icon} ";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = [ "" "" "" "" "" ];
        };
        "network" = {
          format-wifi = "";
          format-ethernet = "";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          on-click = "nm-connection-editor";
        };
        "pulseaudio" = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
          on-click = "${pk "pavucontrol"}";
        };
      };
    };
    style = # css
      ''
        @define-color base      rgba(0.15625, 0.15625, 0.15625, 0.85);
        @define-color base2     rgba(0.2352 , 0.2196 , 0.2118 ,  1.0);/*${palette.br_bg};*/
        @define-color text      ${palette.br_fg};
        @define-color green     ${palette.br_green};
        @define-color yellow    ${palette.br_yellow};
        @define-color red       ${palette.br_red};


        * {
            font-family: JetBrainsMono Nerd Font;
            font-size: 15px;
            transition: all 0.1s cubic-bezier(.55,-0.68,.48,1.68);
        }

        #workspaces {
          border-radius: 0.5rem;
          background-color: @base2;
        }

        #workspaces button {
          color: @yellow;
          border-radius: 0.5rem;
          background-color: transparent;
        }
        #workspaces button.active {
          color: @red;
          border-radius: 0.5rem;
        }
        #workspaces button.focus {
          color: @red;
          border-radius: 0.5rem;
        }
        #workspaces button:hover {
          color: @red;
          border-radius: 0.5rem;
        }

        #cpu,
        #memory,
        #label
        #tray,
        #network,
        #backlight,
        #clock,
        #battery,
        #pulseaudio,
        #idle_inhibitor,
        #custom-eye_saver,
        #custom-gttfg,
        #custom-lock,
        #custom-logout,
        #custom-power {
          margin: 3px 5px 5px 3px ;
          padding: 2px;
          border-radius: 0.5rem;
          background-color: @base2;
          color: @yellow;
        }

        window > box {
        	margin: 5px 7px 0px 7px;
          background: @base;
          padding: 0px;
          border-radius: 0.5rem;
        }

        window#waybar {
          background: transparent
        }


        #idle_inhibitor{
          color: @text;
        }

        #clock {
          color: @yellow;
        }
        #battery {
          color: @yellow;
        }
        #battery.charging {
          color: @green;
        }
        #battery.warning:not(.charging) {
          color: @red;
        }
        #network {
            color: @yellow;
        }
        #backlight {
          color: @yellow;
        }
        #pulseaudio {
          color: @yellow;
        }
        #pulseaudio.muted {
            color: @red;
        }
        #custom-power {
            border-radius: 0.5rem;
            color: @yellow;
            margin-bottom: 0.5rem;
        }
        #tray {
          border-radius: 0.5rem;
        }
        tooltip {
            background: @base;
            border: 1px solid @yellow;
        }
        tooltip label {
            color: @yellow;
        }
      '';
  };
}
