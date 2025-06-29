#!/usr/bin/env python

import argparse
import subprocess
import os
import sys
import signal
import dataclasses
import enum


class BindType(enum.Enum):
    RO = 0
    RW = 1
    DEV = 2
    TMP = 3
    ENV = 4


@dataclasses.dataclass
class Bind:
    bind_type: BindType
    required: bool
    src: str
    dest: str | None


def build_bwrap_bind_args(bind_args: list[Bind]) -> list[str]:
    args: list[str] = []
    for bind_arg in bind_args:
        match (bind_arg.bind_type, bind_arg.required):
            case (BindType.RO, False):
                args.append("--ro-bind-try")
            case (BindType.RO, True):
                args.append("--ro-bind")
            case (BindType.RW, False):
                args.append("--bind-try")
            case (BindType.RW, True):
                args.append("--bind")
            case (BindType.DEV, False):
                args.append("--dev-bind-try")
            case (BindType.DEV, True):
                args.append("--dev-bind")
            case (BindType.TMP, _):
                args.append("--perms")
                args.append("0700")
                args.append("--tmpfs")
            case (BindType.ENV, _):
                args.append("--setenv")

        match bind_arg.bind_type:
            case BindType.TMP:
                assert bind_arg.dest is None
                args.append(bind_arg.src)
            case BindType.ENV:
                args.append(bind_arg.src)
                if bind_arg.dest is None:
                    args.append(os.getenv(bind_arg.src) or "")
                else:
                    args.append(bind_arg.dest)
            case _:
                args.append(bind_arg.src)
                args.append(bind_arg.dest or bind_arg.src)

    return args


def build_wineprefix(wineprefix):
    os.makedirs(args.wineprefix, exist_ok=True)

    user_dirs = ["Desktop", "Documents", "Downloads", "Music", "Pictures", "Videos"]
    user_base_path = os.path.join(wineprefix, "drive_c", "users", os.environ["USER"])
    for dir in user_dirs:
        try:
            os.makedirs(os.path.join(user_base_path, dir))
            os.mknod(os.path.join(user_base_path, dir, ".keep"))
        except FileExistsError:
            # Directory or file already exists, nothing to do here
            pass


parser = argparse.ArgumentParser()
parser.add_argument(
    "-p",
    "--prefix",
    "--pfx",
    required=os.environ.get("WINEPREFIX") is None,
    default=os.environ.get("WINEPREFIX"),
    dest="wineprefix",
)
parser.add_argument("-d", "--dir", dest="bind_dir")
parser.add_argument("-n", "--allow-network", action="store_true", dest="allow_network")
parser.add_argument("-w", "--cwd", dest="cwd", default=os.getcwd())
parser.add_argument("command", nargs="...")

args = parser.parse_args()

# -- bwrap args
home = os.getenv("HOME") or exit(1)
xdg_runtime_dir = os.getenv("XDG_RUNTIME_DIR") or exit(1)
wayland_display = os.getenv("WAYLAND_DISPLAY") or exit(1)

bwrap_args = [
    "--proc",
    "/proc",
    "--dev",
    "/dev",
    "--clearenv",
    "--unshare-all",
    "--chdir",
    os.path.abspath(args.cwd),
] + build_bwrap_bind_args(
    [
        Bind(BindType.RO, True, "/nix", None),
        Bind(BindType.RO, True, "/etc", None),
        Bind(BindType.RO, True, "/run/systemd/resolve", None),
        Bind(BindType.TMP, True, "/tmp", None),
        Bind(BindType.ENV, True, "PATH", None),
        Bind(BindType.ENV, True, "LANG", None),
        # home
        Bind(BindType.ENV, True, "HOME", os.path.abspath(args.cwd)),
        # desktop
        Bind(BindType.ENV, True, "XDG_RUNTIME_DIR", None),
        Bind(BindType.ENV, True, "XDG_SESSION_TYPE", None),
        Bind(BindType.ENV, True, "XDG_DATA_DIRS", None),
        Bind(BindType.TMP, True, xdg_runtime_dir, None),
        # wayland
        Bind(BindType.RO, True, f"{xdg_runtime_dir}/{wayland_display}", None),
        Bind(BindType.ENV, True, "WAYLAND_DISPLAY", None),
        # xorg
        Bind(BindType.RO, True, "/tmp/.X11-unix", None),
        Bind(BindType.ENV, True, "DISPLAY", None),
        # sound
        Bind(BindType.RO, False, f"{xdg_runtime_dir}/pulse/native", None),
        Bind(BindType.RO, False, f"{home}/.config/pulse/cookie", None),
        Bind(BindType.RO, False, f"{xdg_runtime_dir}/pipewire-0", None),
        # gpu
        Bind(BindType.DEV, True, "/dev/dri", None),
        Bind(BindType.RO, True, "/sys", None),
        # gpu drivers
        Bind(BindType.RO, True, "/run/opengl-driver", None),
        Bind(BindType.RO, True, "/run/opengl-driver-32", None),
    ]
)

if args.allow_network:
    bwrap_args += ["--share-net"]

# --- wine command
wine_command: list[str] = args.command
bind_dir = os.path.abspath(args.bind_dir) if args.bind_dir is not None else None

if wine_command[0] not in ("winecfg", "winetricks"):
    program_executable = os.path.abspath(wine_command[0])
    if not os.path.isfile(program_executable):
        print(f"Executable '{program_executable}' doesn't exist.", file=sys.stderr)
        exit(1)
    if bind_dir is None:
        bind_dir = os.path.dirname(program_executable)
    wine_command[0] = program_executable
    wine_command = ["wine"] + wine_command

if bind_dir is not None:
    bwrap_args += build_bwrap_bind_args([Bind(BindType.RW, True, bind_dir, None)])


# -- wine
wineprefix = os.path.abspath(args.wineprefix)
build_wineprefix(wineprefix)

# Disable creation of file associations
winedlloverrides = "winemenubuilder.exe=d"
# Disable wine-mono prompt
winedlloverrides += ";mscoree=d;mshtml=d"

bwrap_args += build_bwrap_bind_args(
    [
        Bind(BindType.RW, True, wineprefix, None),
        Bind(BindType.ENV, True, "WINEPREFIX", wineprefix),
        Bind(BindType.ENV, True, "WINEDLLOVERRIDES", winedlloverrides),
    ]
)

print(f"Executing '{wine_command}' in wineprefix '{wineprefix}'")

with subprocess.Popen(
    ["bwrap"] + bwrap_args + wine_command, process_group=0
) as process:
    signal.signal(
        signal.SIGINT,
        lambda signum, frame: os.killpg(os.getpgid(process.pid), signal.SIGINT),
    )
