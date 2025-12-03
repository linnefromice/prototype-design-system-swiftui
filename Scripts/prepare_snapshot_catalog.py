"""Prepare assets and data for the Hugo-based UI snapshot catalog."""

from __future__ import annotations

import argparse
import json
import re
from datetime import datetime, timezone
from pathlib import Path
import shutil
from typing import Iterable


DEFAULT_SNAPSHOT_DIR = Path("ProtoDesignSystemTests/__Snapshots__/PreviewTests.generated")
DEFAULT_STATIC_DIR = Path("docs/static/snapshots")
DEFAULT_DATA_FILE = Path("docs/data/snapshots.json")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Copy snapshot PNGs into docs/static and emit Hugo data."
    )
    parser.add_argument(
        "--snapshots",
        type=Path,
        default=DEFAULT_SNAPSHOT_DIR,
        help="Directory containing PNG snapshots to include in the catalog.",
    )
    parser.add_argument(
        "--static-dir",
        type=Path,
        default=DEFAULT_STATIC_DIR,
        help="Destination for copied snapshot assets inside the Hugo site.",
    )
    parser.add_argument(
        "--data-file",
        type=Path,
        default=DEFAULT_DATA_FILE,
        help="Path to the Hugo data JSON file to generate.",
    )
    parser.add_argument(
        "--clean",
        action="store_true",
        help="Remove existing PNGs from the static directory before copying.",
    )
    return parser.parse_args()


def to_title(filename: str) -> str:
    base = filename.rsplit(".", 1)[0]
    words = [segment for segment in re.split(r"[_\-]+", base) if segment]
    if not words:
        return base
    return " ".join(words)


def build_tags(title: str) -> list[str]:
    tokens = {token.lower() for token in re.split(r"\s+", title) if token}
    return sorted(tokens)


def clean_static_dir(static_dir: Path) -> None:
    if not static_dir.exists():
        return
    for png in static_dir.glob("*.png"):
        png.unlink()


def copy_snapshots(snapshot_dir: Path, static_dir: Path) -> list[Path]:
    static_dir.mkdir(parents=True, exist_ok=True)
    image_files = sorted(p for p in snapshot_dir.glob("*.png") if p.is_file())

    copied: list[Path] = []
    for src in image_files:
        dest = static_dir / src.name
        shutil.copy2(src, dest)
        copied.append(dest)

    return copied


def write_data_file(dest: Path, images: Iterable[Path]) -> None:
    dest.parent.mkdir(parents=True, exist_ok=True)
    entries = []
    for image in images:
        title = to_title(image.name)
        entries.append(
            {
                "file": image.name,
                "title": title,
                "tags": build_tags(title),
            }
        )

    payload = {
        "generated_at": datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC"),
        "snapshots": entries,
    }
    dest.write_text(json.dumps(payload, indent=2), encoding="utf-8")


def main() -> None:
    args = parse_args()

    snapshot_dir = args.snapshots.expanduser().resolve()
    static_dir = args.static_dir.expanduser().resolve()
    data_file = args.data_file.expanduser().resolve()

    if not snapshot_dir.is_dir():
        raise SystemExit(f"Snapshot directory not found: {snapshot_dir}")

    if args.clean:
        clean_static_dir(static_dir)

    images = copy_snapshots(snapshot_dir, static_dir)
    write_data_file(data_file, images)
    print(f"Copied {len(images)} snapshots to {static_dir}")
    print(f"Wrote data file to {data_file}")


if __name__ == "__main__":
    main()
