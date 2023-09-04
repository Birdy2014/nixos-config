# Based on Firejail profile for multimc5

# Persistent local customizations
include prismlauncher.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/PrismLauncher

# Ignore noexec on ${HOME} as MultiMC installs LWJGL native
# libraries in ${HOME}/.local/share/multimc
ignore noexec ${HOME}

# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.local/share/PrismLauncher
whitelist ${HOME}/.local/share/PrismLauncher
include whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
# seccomp

disable-mnt
# private-bin works, but causes weirdness
# private-bin apt-file,awk,bash,chmod,dirname,dnf,grep,java,kdialog,ldd,mkdir,multimc5,pfl,pkgfile,readlink,sort,valgrind,which,yum,zenity,zypper
private-dev
private-tmp

# restrict-namespaces
