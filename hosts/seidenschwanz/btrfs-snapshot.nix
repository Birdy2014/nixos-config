{ ... }:

{
  my.btrfs-snapshot = {
    enable = true;
    settings = [
      {
        base_path = "/";
        snapshot_path = "/snapshots";
      }
    ];
  };
}
