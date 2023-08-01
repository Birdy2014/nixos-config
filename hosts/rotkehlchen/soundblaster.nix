{ pkgs, ... }:

{
  # Workaround for Creative Sound BlasterX G6
  systemd = let
    # Wait until wireplumber has set the alsa options. This takes a while especially after suspend.
    amixerWaitScript = ''
      ${pkgs.coreutils-full}/bin/sleep 10
    '';

    alsaOptionsScript = ''
      ${pkgs.alsaUtils}/bin/amixer -D hw:G6 sset 'PCM Capture Source' 'External Mic'
      ${pkgs.alsaUtils}/bin/amixer -D hw:G6 sset 'External Mic',0 Capture cap
      ${pkgs.alsaUtils}/bin/amixer -D hw:G6 sset 'External Mic',0 Capture 9dB
      ${pkgs.alsaUtils}/bin/amixer -D hw:G6 sset 'Line In',0 Capture nocap
      ${pkgs.alsaUtils}/bin/amixer -D hw:G6 sset 'S/PDIF In',0 Capture nocap
      ${pkgs.alsaUtils}/bin/amixer -D hw:G6 sset 'What U Hear',0 Capture nocap

      ${pkgs.alsaUtils}/bin/amixer -D hw:G6 sset 'Line In',0 Playback mute
      ${pkgs.alsaUtils}/bin/amixer -D hw:G6 sset 'External Mic',0 Playback mute
      ${pkgs.alsaUtils}/bin/amixer -D hw:G6 sset 'S/PDIF In',0 Playback mute
    '';
  in {
    services.soundblaster-reset-usb = {
      script =
        "${pkgs.usb-modeswitch}/bin/usb_modeswitch -v 0x041e -p 0x3256 --reset-usb";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = { Type = "oneshot"; };
    };

    user.services.soundblaster-set-alsa-options = {
      script = alsaOptionsScript;
      preStart = amixerWaitScript;
      wantedBy = [ "pipewire.service" ];
      after = [ "pipewire.service" "wireplumber.service" ];
      serviceConfig = { Type = "oneshot"; };
    };

    services.soundblaster-set-alsa-options = {
      script = alsaOptionsScript;
      preStart = amixerWaitScript;
      wantedBy = [
        "suspend.target"
        "hibernate.target"
        "hybrid-sleep.target"
        "suspend-then-hibernate.target"
      ];
      serviceConfig = {
        Type = "oneshot";
        User = "moritz";
        Group = "users";
      };
    };
  };

  boot.extraModprobeConfig = ''
    options snd_usb_audio id=G6 index=0
    options snd_hda_intel id=HDMI,Generic index=1,2 enable=0,0
  '';
}
