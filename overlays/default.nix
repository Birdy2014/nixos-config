{
  default = (final: prev:
    builtins.foldl' (a: b: a // b) { } [
      (import ./blocky final prev)
      (import ./imv final prev)
      (import ./lf final prev)
      (import ./swayidle final prev)
    ]);
}
