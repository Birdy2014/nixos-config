private ${HOME}/.local/share/steam

# This is executed on the original and the fake home directory.
# That doesn't make sense, as it is only needed on the original home directory,
# so it is probably not the correct command.
# https://github.com/netblue30/firejail/issues/903
mkdir ${HOME}/.local/share/steam

caps.drop all
nogroups
nonewprivs
noroot
private-dev
private-tmp

whitelist /run/current-system
whitelist /run/booted-system
whitelist /run/opengl-driver
whitelist /run/opengl-driver-32

whitelist /run/media/moritz/games/Steam-Linux
whitelist /run/media/moritz/games/Steam-Images
