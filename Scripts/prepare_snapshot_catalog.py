"""Prepare assets and data for the Hugo-based UI snapshot catalog."""

from __future__ import annotations

import argparse
import json
import re
from datetime import datetime, timezone
from pathlib import Path
import shutil
from typing import Iterable, TypedDict


DEFAULT_SNAPSHOT_DIR = Path("ProtoDesignSystemTests/__Snapshots__/PreviewTests.generated")
DEFAULT_STATIC_DIR = Path("docs/static/snapshots")
DEFAULT_DATA_FILE = Path("docs/data/snapshots.json")

# Component category mapping based on CLAUDE.md
COMPONENT_CATEGORIES = {
    "Banner": "Feedback",
    "NotificationBanner": "Feedback",
    "EmergencyBanner": "Feedback",
    "ProgressIndicator": "Feedback",
    "Button": "Form",
    "SolidFillButton": "Form",
    "OutlineButton": "Form",
    "TextButton": "Form",
    "Checkbox": "Form",
    "InputText": "Form",
    "RadioButton": "Form",
    "SelectBox": "Form",
    "SearchBox": "Form",
    "TextArea": "Form",
    "ChipLabel": "Content",
    "ChipTag": "Content",
    "UtilityLink": "Content",
}


class SnapshotMetadata(TypedDict):
    """Metadata extracted from snapshot filename and component info."""
    file: str
    title: str
    tags: list[str]
    component: str
    category: str
    variant: str | None
    state: str | None


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
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would be done without actually doing it.",
    )
    return parser.parse_args()


def extract_metadata(filename: str) -> SnapshotMetadata:
    """
    Extract structured metadata from snapshot filename.

    Filename patterns:
    - ComponentName_0.1.png (current simple format)
    - ComponentName_variant_state_0.1.png (future extended format)

    Examples:
    - Button_0.1.png -> component: Button, variant: None, state: None
    - Button_small_hover_0.1.png -> component: Button, variant: small, state: hover
    """
    base = filename.rsplit(".", 1)[0]  # Remove .png extension

    # Remove version suffix (e.g., _0.1)
    version_pattern = r"_\d+\.\d+$"
    base = re.sub(version_pattern, "", base)

    # Split by underscore
    parts = base.split("_")

    # First part is always the component name
    component = parts[0] if parts else base

    # Determine category
    category = COMPONENT_CATEGORIES.get(component, "Other")

    # Extract variant and state from remaining parts
    variant = None
    state = None

    # Known states (from DADS design system)
    known_states = {"default", "hover", "active", "disabled", "focus", "error", "success"}
    # Known size variants
    known_sizes = {"small", "medium", "large", "xs", "sm", "md", "lg", "xl"}

    if len(parts) > 1:
        # Try to identify variant and state from parts[1:]
        remaining_parts = parts[1:]

        for part in remaining_parts:
            part_lower = part.lower()
            if part_lower in known_states:
                state = part
            elif part_lower in known_sizes:
                variant = part
            elif variant is None:  # First unrecognized part becomes variant
                variant = part

    # Build human-readable title
    title_parts = [component]
    if variant:
        title_parts.append(variant)
    if state:
        title_parts.append(state)
    title = " ".join(title_parts)

    # Build tags for search/filtering
    tags = [component.lower(), category.lower()]
    if variant:
        tags.append(variant.lower())
    if state:
        tags.append(state.lower())

    return SnapshotMetadata(
        file=filename,
        title=title,
        tags=sorted(set(tags)),
        component=component,
        category=category,
        variant=variant,
        state=state,
    )


def clean_static_dir(static_dir: Path, dry_run: bool = False) -> None:
    """Remove existing PNG files from static directory."""
    if not static_dir.exists():
        return
    for png in static_dir.glob("*.png"):
        if dry_run:
            print(f"[DRY RUN] Would delete: {png}")
        else:
            png.unlink()


def copy_snapshots(snapshot_dir: Path, static_dir: Path, dry_run: bool = False) -> list[Path]:
    """Copy snapshot PNGs from test directory to Hugo static directory."""
    static_dir.mkdir(parents=True, exist_ok=True)
    image_files = sorted(p for p in snapshot_dir.glob("*.png") if p.is_file())

    copied: list[Path] = []
    for src in image_files:
        dest = static_dir / src.name
        if dry_run:
            print(f"[DRY RUN] Would copy: {src.name} -> {dest}")
        else:
            shutil.copy2(src, dest)
        copied.append(dest)

    return copied


def write_data_file(dest: Path, images: Iterable[Path], dry_run: bool = False) -> None:
    """Generate Hugo data JSON file with extracted metadata."""
    dest.parent.mkdir(parents=True, exist_ok=True)
    entries = []

    for image in images:
        metadata = extract_metadata(image.name)
        entries.append(dict(metadata))

    # Group by category for better organization
    categories = {}
    for entry in entries:
        cat = entry["category"]
        if cat not in categories:
            categories[cat] = []
        categories[cat].append(entry)

    payload = {
        "generated_at": datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC"),
        "total_snapshots": len(entries),
        "categories": {cat: len(items) for cat, items in categories.items()},
        "snapshots": entries,
        "by_category": categories,
    }

    json_content = json.dumps(payload, indent=2, ensure_ascii=False)

    if dry_run:
        print(f"[DRY RUN] Would write to: {dest}")
        print("\nPreview of generated data:")
        print(json_content[:500] + "..." if len(json_content) > 500 else json_content)
    else:
        dest.write_text(json_content, encoding="utf-8")


def main() -> None:
    args = parse_args()

    snapshot_dir = args.snapshots.expanduser().resolve()
    static_dir = args.static_dir.expanduser().resolve()
    data_file = args.data_file.expanduser().resolve()

    if not snapshot_dir.is_dir():
        raise SystemExit(f"Snapshot directory not found: {snapshot_dir}")

    if args.dry_run:
        print("=" * 60)
        print("DRY RUN MODE - No files will be modified")
        print("=" * 60)

    if args.clean:
        clean_static_dir(static_dir, dry_run=args.dry_run)

    images = copy_snapshots(snapshot_dir, static_dir, dry_run=args.dry_run)
    write_data_file(data_file, images, dry_run=args.dry_run)

    if not args.dry_run:
        print(f"✓ Copied {len(images)} snapshots to {static_dir}")
        print(f"✓ Wrote data file to {data_file}")
    else:
        print(f"\n✓ Would process {len(images)} snapshots")


if __name__ == "__main__":
    main()
