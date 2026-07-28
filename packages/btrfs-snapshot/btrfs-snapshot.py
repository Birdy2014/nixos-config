#!/usr/bin/env python

import dataclasses
import datetime
import os
import re
import subprocess
import json


DATE_FORMAT = "%Y%m%dT%H%M"


@dataclasses.dataclass
class Config:
    base_path: str
    snapshot_path: str
    preserve_hourly: int
    preserve_daily: int
    preserve_min_hours: int

    def basename(self) -> str:
        return os.path.basename(self.base_path.rstrip("/")) or "ROOT"

    @classmethod
    def parse(cls, raw: dict) -> "Config":
        return cls(
            base_path=raw["base_path"],
            snapshot_path=raw["snapshot_path"],
            preserve_hourly=raw["preserve_hourly"],
            preserve_daily=raw["preserve_daily"],
            preserve_min_hours=raw["preserve_min_hours"],
        )


class Snapshot:
    base_path: str
    path: str
    id: int

    def __repr__(self) -> str:
        return f"Snapshot(id={self.id}, base_path={self.base_path}, path={self.path})"

    def time(self) -> datetime.datetime:
        return datetime.datetime.strptime(self.path[-13:], DATE_FORMAT)


def get_snapshots(config: Config) -> list[Snapshot] | None:
    process = subprocess.run(
        ["btrfs", "subvolume", "list", "-s", "--sort=path", config.base_path],
        capture_output=True,
    )
    if process.returncode != 0:
        return None

    def parse_line(line: str) -> Snapshot:
        words = line.split(" ")
        snapshot = Snapshot()
        snapshot.base_path = config.base_path

        skip = 0
        for i, word in enumerate(words):
            if skip > 0:
                skip -= 1
                continue

            match word:
                case "ID":
                    snapshot.id = int(words[i + 1])
                    skip = 1

                case "path":
                    snapshot.path = words[i + 1]
                    skip = 1

        return snapshot

    def is_valid(snapshot: Snapshot) -> bool:
        return (
            re.fullmatch(
                f"(.*/)?{config.basename()}\\.[0-9]{{8}}T[0-9]{{4}}",
                snapshot.path,
            )
            is not None
        )

    snapshots = filter(
        is_valid,
        map(parse_line, process.stdout.decode("utf-8").splitlines()),
    )

    return list(snapshots)


def do_snapshot(config: Config):
    current_time = datetime.datetime.now().strftime(DATE_FORMAT)
    destination = f"{config.snapshot_path}/{config.basename()}.{current_time}"

    process = subprocess.run(
        ["btrfs", "subvolume", "snapshot", "-r", config.base_path, destination]
    )
    if process.returncode != 0:
        raise Exception()
    print(f"Created snapshot of {config.base_path} at {destination}")


def delete_snapshot(snapshot: Snapshot):
    process = subprocess.run(
        [
            "btrfs",
            "subvolume",
            "delete",
            "--subvolid",
            str(snapshot.id),
            snapshot.base_path,
        ]
    )
    if process.returncode != 0:
        raise Exception()
    print(f"Deleted snapshot: {snapshot}")


def delete_old_snapshots(config: Config, snapshots: list[Snapshot]):
    now = datetime.datetime.now()
    snapshots = list(
        filter(
            lambda snapshot: (now - snapshot.time()).total_seconds() / 3600
            > config.preserve_min_hours,
            snapshots,
        )
    )

    def get_firsts_in_interval(datetime_format: str) -> list[Snapshot]:
        collected: list[Snapshot] = []
        snapshots_per_interval: dict[str, list[Snapshot]] = {}
        for snapshot in snapshots:
            key = snapshot.time().strftime(datetime_format)
            if key not in snapshots_per_interval:
                snapshots_per_interval[key] = [snapshot]
            else:
                snapshots_per_interval[key].append(snapshot)

        for key in snapshots_per_interval:
            collected.append(snapshots_per_interval[key][0])

        return collected

    snapshots_to_keep: list[Snapshot] = []

    hourly_snapshots = get_firsts_in_interval("%Y%m%dT%H")
    snapshots_to_keep += hourly_snapshots[-config.preserve_hourly :]

    daily_snapshots = get_firsts_in_interval("%Y%m%d")
    snapshots_to_keep += daily_snapshots[-config.preserve_daily :]

    for snapshot in filter(lambda s: s not in snapshots_to_keep, snapshots):
        delete_snapshot(snapshot)


if __name__ == "__main__":
    config_path = os.environ["CONFIG"]
    with open(config_path, "r") as file:
        content = file.read()
    parsed = json.loads(content)

    for raw_config in parsed:
        config = Config.parse(raw_config)
        snapshots = get_snapshots(config)
        assert snapshots is not None
        delete_old_snapshots(config, snapshots)
        do_snapshot(config)
