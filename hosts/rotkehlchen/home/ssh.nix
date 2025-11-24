{ ... }:

{
  programs.ssh = {
    enable = true;

    serverAliveInterval = 20;

    matchBlocks = {
      seidenschwanz = {
        hostname = "fd00:90::10";
        user = "root";
      };

      seidenschwanz-initrd = {
        hostname = "fd00:90::10";
        user = "root";
        port = 2222;
      };

      buntspecht = {
        hostname = "2a01:4f8:c012:2dfe::1";
        user = "root";
        port = 46773;
      };

      zilpzalp = {
        hostname = "zilpzalp.local";
        user = "moritz";
      };

      # Needed for dircolors to work in foot when connecting over ssh
      "*".sendEnv = [ "COLORTERM" ];
    };
  };
}
