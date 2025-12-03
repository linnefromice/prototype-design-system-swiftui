"""Generate a static HTML catalog for UI snapshot images.

This script collects PNG snapshots from the given directory, copies them into
an output folder, and builds a lightweight HTML page to browse them. It is
intended to run in CI for publishing the catalog via GitHub Pages, but can also
be run locally.
"""

from __future__ import annotations

import argparse
import html
from datetime import datetime, timezone
from pathlib import Path
import shutil


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Generate a static HTML catalog for UI snapshot images."
    )
    parser.add_argument(
        "--snapshots",
        type=Path,
        default=Path("ProtoDesignSystemTests/__Snapshots__/PreviewTests.generated"),
        help="Directory containing PNG snapshots to include in the catalog.",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("ProtoDesignSystemTests/__Snapshots__/PreviewTests.generated"),
        help=(
            "Directory where the catalog HTML will be written. Defaults to the "
            "snapshot directory so the assets are reused in place."
        ),
    )
    return parser.parse_args()


def build_cards(image_names: list[str], asset_prefix: str) -> str:
    cards = []
    for name in image_names:
        display_name = name.rsplit(".", 1)[0].replace("_", " ")
        cards.append(
            f"""
            <article class=\"snapshot-card\">
                <div class=\"snapshot-frame\">
                    <img src=\"{html.escape(asset_prefix + name)}\" alt=\"{html.escape(display_name)}\" loading=\"lazy\" />
                </div>
                <h2>{html.escape(display_name)}</h2>
            </article>
            """
        )
    return "\n".join(cards)


def render_html(image_names: list[str], asset_prefix: str) -> str:
    generated_at = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")
    cards = build_cards(image_names, asset_prefix)
    return f"""
<!doctype html>
<html lang=\"en\">
<head>
    <meta charset=\"UTF-8\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
    <title>UI Snapshot Catalog</title>
    <style>
        :root {{
            color-scheme: light dark;
            --bg: #0f172a;
            --panel: rgba(255, 255, 255, 0.06);
            --text: #e2e8f0;
            --accent: #22d3ee;
            --muted: #94a3b8;
        }}
        body {{
            margin: 0;
            font-family: system-ui, -apple-system, "Segoe UI", sans-serif;
            background: linear-gradient(145deg, #0b1224, #111827);
            color: var(--text);
            min-height: 100vh;
        }}
        header {{
            padding: 32px 24px 16px;
            text-align: center;
        }}
        h1 {{
            margin: 0 0 8px;
            font-weight: 700;
            letter-spacing: 0.3px;
        }}
        .intro {{
            margin: 0;
            color: var(--muted);
            font-size: 16px;
        }}
        main {{
            padding: 0 24px 32px;
        }}
        .grid {{
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }}
        .snapshot-card {{
            background: var(--panel);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 16px;
            padding: 16px;
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.3);
            backdrop-filter: blur(6px);
            transition: transform 120ms ease, box-shadow 120ms ease;
        }}
        .snapshot-card:hover {{
            transform: translateY(-3px);
            box-shadow: 0 16px 36px rgba(0, 0, 0, 0.35);
        }}
        .snapshot-frame {{
            border-radius: 12px;
            overflow: hidden;
            background: #0b1224;
            border: 1px solid rgba(255, 255, 255, 0.06);
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 120px;
        }}
        img {{
            width: 100%;
            height: auto;
            display: block;
        }}
        h2 {{
            margin: 12px 0 0;
            font-size: 16px;
            font-weight: 600;
            letter-spacing: 0.2px;
        }}
        footer {{
            text-align: center;
            color: var(--muted);
            padding: 16px 0 32px;
            font-size: 14px;
        }}
        .empty {{
            text-align: center;
            color: var(--muted);
            font-size: 16px;
            grid-column: 1 / -1;
        }}
    </style>
</head>
<body>
    <header>
        <h1>UI Snapshot Catalog</h1>
        <p class=\"intro\">Preview snapshots from ProtoDesignSystem snapshot tests.</p>
    </header>
    <main>
        <section class=\"grid\">
            {cards if cards else '<p class="empty">No snapshots were found.</p>'}
        </section>
    </main>
    <footer>Generated at {generated_at}</footer>
</body>
</html>
"""


def generate_catalog(snapshot_dir: Path, output_dir: Path) -> None:
    snapshot_dir = snapshot_dir.expanduser().resolve()
    output_dir = output_dir.expanduser().resolve()

    if not snapshot_dir.is_dir():
        raise SystemExit(f"Snapshot directory not found: {snapshot_dir}")

    output_dir.mkdir(parents=True, exist_ok=True)

    reuse_assets = snapshot_dir == output_dir
    asset_dir = snapshot_dir if reuse_assets else output_dir / "snapshots"
    asset_prefix = "" if reuse_assets else "snapshots/"

    if not reuse_assets:
        asset_dir.mkdir(exist_ok=True)

    image_files = sorted(p for p in snapshot_dir.glob("*.png") if p.is_file())
    image_names = []
    for src in image_files:
        if not reuse_assets:
            dest = asset_dir / src.name
            shutil.copy2(src, dest)
        image_names.append(src.name)

    index_path = output_dir / "index.html"
    index_path.write_text(render_html(image_names, asset_prefix), encoding="utf-8")

    print(f"Catalog written to {index_path.relative_to(Path.cwd())}")


def main() -> None:
    args = parse_args()
    generate_catalog(args.snapshots, args.output)


if __name__ == "__main__":
    main()
