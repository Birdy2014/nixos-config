{ config, lib, ... }:

{
  config = lib.mkIf config.programs.niri.enable {
    programs.niri.settings = {
      spawn-at-startup = [
        { command = [ "element-desktop" ]; }
        { command = [ "vesktop" ]; }
        { command = [ "thunderbird" ]; }
      ];

      window-rules = [
        {
          matches = [
            {
              app-id = "^.virt-manager-wrapped$";
              title = "^.+ on QEMU/KVM(: .+)?$";
            }
          ];
          default-column-width.proportion = 0.5;
        }
      ];
    };
  };
}
