{
  default = (
    final: prev:
    builtins.foldl' (a: b: a // b) { } [
      (import ./lf final prev)
      (import ./paperless-ngx final prev)
      (import ./trash-cli final prev)
    ]
  );
}
