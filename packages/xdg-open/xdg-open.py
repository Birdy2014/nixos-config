#!/usr/bin/env python

default_terminal = "kitty"

extension_associations: dict[str, str | list[str]] = {
    "stl": "f3d.desktop",
    "obj": "f3d.desktop",
}

import os
import re
import sys
import subprocess
import dbus
from enum import Enum


class OpenSuccess(Enum):
    SUCCESS = 0
    ERROR = 1
    CANCELED = 2


def parse_mime_associations() -> dict[str, list[str]]:
    HOME = os.environ.get("HOME", "")
    XDG_CONFIG_HOME = os.environ.get("XDG_CONFIG_HOME", f"{HOME}/.config")

    mime_associations: dict[str, list[str]] = {}

    association_file = f"{XDG_CONFIG_HOME}/mimeapps_patterns.list"

    if os.path.isfile(association_file):
        with open(association_file, "r") as patterns_file:
            for line in patterns_file:
                pattern, associations = line.strip().split("=")
                mime_associations[pattern] = associations.split(";")

    return mime_associations


mime_associations = parse_mime_associations()


class DesktopEntry:
    _file_path: str
    name: str
    _exec_line: str | None
    _try_exec_line: str | None
    _run_in_terminal: bool | None
    _path: str | None

    def __init__(self, path: str) -> None:
        self._file_path = path
        self.name = path
        self._try_exec_line = None
        self._try_exec_line = None
        self._run_in_terminal = None
        self._path = None

        in_desktop_entry = (
            False  # Differentiate between Desktop Entries and Desktop Actions
        )

        with open(path, "r") as file:
            for line in file.readlines():
                line = line.replace("\n", "")

                if line == "[Desktop Entry]":
                    in_desktop_entry = True

                elif line.startswith("[Desktop Action"):
                    in_desktop_entry = False

                elif in_desktop_entry and line.startswith("Name="):
                    split = line.split("=", 1)

                    if len(split) != 2:
                        continue

                    self.name = split[1]

                elif in_desktop_entry and line.startswith("Exec="):
                    split = line.split("=", 1)

                    if len(split) != 2:
                        continue

                    self._exec_line = split[1]

                elif in_desktop_entry and line.startswith("TryExec="):
                    split = line.split("=", 1)

                    if len(split) != 2:
                        continue

                    self._try_exec_line = split[1]

                elif in_desktop_entry and line.startswith("Terminal="):
                    split = line.split("=")

                    if len(split) != 2:
                        continue

                    if split[1] == "true":
                        self._run_in_terminal = True
                    elif split[1] == "false":
                        self._run_in_terminal = False

                elif in_desktop_entry and line.startswith("Path="):
                    split = line.split("=", 1)

                    if len(split) != 2:
                        continue

                    self._path = split[1]

    def exec(self, args: list[str]) -> None:
        if self._exec_line is None:
            return

        process_cmdline = self._unescape_exec(self._exec_line, args)

        is_tty = sys.stdout.isatty() and sys.stdin.isatty()

        if self._run_in_terminal and is_tty:
            # Terminal application in terminal
            subprocess.run(process_cmdline, cwd=self._path)
            return

        if self._run_in_terminal and not is_tty:
            process_cmdline = [default_terminal] + process_cmdline

        subprocess.Popen(
            ["nohup"] + process_cmdline,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            stdin=subprocess.DEVNULL,
            cwd=self._path,
        )

    def _is_available(self) -> bool:
        if self._try_exec_line is None:
            return True

        return self._get_executable_path(self._try_exec_line) is not None

    def _unescape_exec(self, exec_line: str, args: list[str]) -> list[str]:
        # https://specifications.freedesktop.org/desktop-entry-spec/latest/ar01s07.html

        def remove_scheme(url: str):
            if (match := re.match("(.+)://(.+)", url)) is not None:
                return match[2]
            return url

        process_cmdline: list[str] = []
        index = 0
        tmp_word = ""
        is_in_string = False

        def eol() -> bool:
            return index >= len(exec_line)

        def consume_word():
            word = ""

            while not eol():
                nonlocal index
                c = exec_line[index]
                index += 1
                if c == " " or c == "\\" or c == "$" or c == "%":
                    return word
                word += c

            return word

        while not eol():
            match exec_line[index]:
                case "$":
                    index += 1
                    env_variable = consume_word()
                    tmp_word += os.environ.get(env_variable, "")
                case "\\":
                    index += 1
                    tmp_word += exec_line[index]
                    index += 1
                case '"':
                    is_in_string = not is_in_string
                    index += 1
                case " ":
                    if is_in_string:
                        tmp_word += exec_line[index]
                        index += 1
                        continue
                    process_cmdline.append(tmp_word)
                    tmp_word = ""
                    index += 1
                case "%":
                    index += 1
                    code = exec_line[index]
                    index += 1

                    match code:
                        case "f":
                            tmp_word += remove_scheme(args[0])
                        case "F":
                            process_cmdline += map(remove_scheme, args)
                        case "u":
                            tmp_word += args[0]
                        case "U":
                            process_cmdline += args
                case _:
                    tmp_word += exec_line[index]
                    index += 1

        if tmp_word:
            process_cmdline.append(tmp_word)

        return process_cmdline

    def _get_executable_path(self, executable: str) -> str | None:
        if os.path.isfile(executable):
            return executable

        path_env = os.environ.get("PATH")
        if path_env is None:
            return None

        for path in path_env.split(os.pathsep):
            executable_path = os.path.join(path, executable)
            if os.path.isfile(executable_path):
                return executable_path

        return None

    def __eq__(self, __value: object) -> bool:
        if isinstance(__value, DesktopEntry):
            return self._file_path == __value._file_path

        return False


home_path = os.path.expanduser("~")
data_home = os.environ.get("XDG_DATA_HOME") or f"{home_path}/.local/share"
config_home = os.environ.get("XDG_CONFIG_HOME") or f"{home_path}/.config"

application_paths = [
    f"{data_home}/applications",
    "/usr/share/applications",
]

if data_dirs := os.environ.get("XDG_DATA_DIRS"):
    for data_dir in data_dirs.split(":"):
        application_dir = data_dir + "/applications"
        if os.path.isdir(application_dir):
            application_paths.append(application_dir)

mimeapps_path = f"{config_home}/mimeapps.list"


def main(args):
    should_only_use_portal = os.environ.get(
        "NIXOS_XDG_OPEN_USE_PORTAL", "0"
    ) == "1" or os.path.isfile("/.flatpak-info")

    for arg in args[1:]:
        if not should_only_use_portal:
            if open_directly(arg) in [OpenSuccess.SUCCESS, OpenSuccess.CANCELED]:
                continue
        open_xdg_portal(arg)


def open_directly(arg: str) -> OpenSuccess:
    desktop_entries = get_file_associations(arg)
    if len(desktop_entries) == 0:
        send_notification(
            "Failed to open file", f"Could not find association for {arg}"
        )
        return OpenSuccess.ERROR

    selected_entry = (
        show_menu(desktop_entries) if len(desktop_entries) > 1 else desktop_entries[0]
    )

    if selected_entry is None:
        send_notification("Failed to open file", f"Nothing selected")
        return OpenSuccess.CANCELED

    selected_entry.exec([arg])
    return OpenSuccess.SUCCESS


# TODO: Check if open was successfull to only display an error if both methods were unsuccessfull
def open_xdg_portal(arg: str) -> OpenSuccess:
    session_bus = dbus.SessionBus()
    proxy = session_bus.get_object(
        "org.freedesktop.portal.Desktop", "/org/freedesktop/portal/desktop"
    )

    arg = strip_file_scheme(arg)

    if re.match("(.+)://", arg) is not None:
        proxy.OpenURI("", arg, {}, dbus_interface="org.freedesktop.portal.OpenURI")
    else:
        # Use OpenFile for files and directories, because OpenDirectory doesn't respect the
        # inode/directory mime type for some reason.
        fd = os.open(arg, os.O_RDONLY)
        proxy.OpenFile(
            "",
            dbus.types.UnixFd(fd),
            {},
            dbus_interface="org.freedesktop.portal.OpenURI",
        )
        os.close(fd)
    return OpenSuccess.SUCCESS


def strip_file_scheme(uri: str) -> str:
    if (match := re.match("(.+)://(.+)", uri)) is not None:
        scheme = match.group(1)
        if scheme == "file":
            return match.group(2)
    return uri


def get_file_associations(arg: str) -> list[DesktopEntry]:
    desktop_entries: list[DesktopEntry] = []

    def add_desktop_entry(desktop_file: str):
        desktop_entry = resolve_desktop_entry(desktop_file)
        if desktop_entry is not None and desktop_entry not in desktop_entries:
            desktop_entries.append(desktop_entry)

    # Match File Extensions
    for file_extension, desktop_file in extension_associations.items():
        if arg.endswith(file_extension):
            if isinstance(desktop_file, str):
                add_desktop_entry(desktop_file)
            elif isinstance(desktop_file, list):
                for file in desktop_file:
                    add_desktop_entry(file)

    # Match Scheme
    if (match := re.match("(.+)://", arg)) is not None:
        arg_scheme = match.group(1)
        arg_mime_type = f"x-scheme-handler/{arg_scheme}"
    else:
        # Match MIME Type
        completed = subprocess.run(
            ["xdg-mime", "query", "filetype", os.path.realpath(arg)],
            capture_output=True,
        )
        if completed.returncode != 0:
            return []
        arg_mime_type = completed.stdout.decode().strip()

    for mime_type_pattern, desktop_file in mime_associations.items():
        if (mime_type_pattern == arg_mime_type) or (
            mime_type_pattern[-1] == "/" and arg_mime_type.startswith(mime_type_pattern)
        ):
            for file in desktop_file:
                add_desktop_entry(file)
    return desktop_entries


def resolve_desktop_entry(desktop_file: str) -> DesktopEntry | None:
    for application_path in application_paths:
        desktop_file_path = os.path.join(application_path, desktop_file)
        if os.path.exists(desktop_file_path):
            entry = DesktopEntry(desktop_file_path)
            if entry._is_available():
                return entry


def send_notification(summary: str, body: str) -> None:
    subprocess.Popen(["notify-send", "-u", "normal", summary, body])


def show_menu(desktop_entries: list[DesktopEntry]) -> DesktopEntry | None:
    entry_names = {entry.name: entry for entry in desktop_entries}
    completed = subprocess.run(
        ["rofi", "-dmenu"],
        capture_output=True,
        input=str.encode("\n".join(entry_names.keys())),
    )
    return entry_names.get(completed.stdout.decode("utf-8")[:-1])


if __name__ == "__main__":
    main(sys.argv)
