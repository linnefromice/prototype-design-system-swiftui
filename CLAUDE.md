# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a SwiftUI-based design system prototype implementing reusable UI components following DADS (Digital Agency Design System) specifications for Japanese government/public sector applications.

**Implementation Status**: 12 / 39 components completed (30.8%)
- **Form**: Button, Checkbox, InputText, RadioButton, SelectBox, TextArea
- **Content**: ChipLabel, ChipTag, UtilityLink
- **Feedback**: Banner (EmergencyBanner + NotificationBanner), ProgressIndicator

Component categories: Content, Form, Feedback, Navigation, Layout, and Table.

## Build & Development

### Opening the Project
```bash
open ProtoDesignSystem.xcodeproj
```

### Building
Build through Xcode IDE - this is an Xcode project (`.xcodeproj`) without Swift Package Manager configuration.

### Component Status Tracking
```bash
# View component implementation summary
make status

# View detailed status by category
make status-detail
```

Component status is tracked in:
- `COMPONENT_STATUS.md` - Visual markdown format with status indicators
- `component_status.csv` - CSV format for spreadsheet editing

## Architecture

### Directory Structure

```
ProtoDesignSystem/Sources/DesignSystem/
├── Components/                 # UI components
│   ├── Banner/                # NotificationBanner, EmergencyBanner (5 statuses, 2 variants, 2 layouts)
│   ├── Button/                # Multiple button variants (SolidFillButton, OutlineButton, TextButton)
│   ├── Checkbox/              # Checkbox with multiple states and sizes
│   ├── Chip/                  # ChipLabel (4 styles, 9 colors), ChipTag (4 states, 5 colors)
│   ├── InputText/             # Single-line text input with error states
│   ├── ProgressIndicator/     # Circular and Linear progress (ProgressViewStyle-based)
│   ├── RadioButton/           # RadioButton & RadioGroup (16 states, 3 layouts)
│   ├── SelectBox/             # Generic dropdown with type safety
│   ├── TextArea/              # Multi-line text input with character counter
│   └── UtilityLink/           # Navigation links
└── Definitions/               # Design tokens and shared constants
    ├── AppColor.swift         # Color palette (Neutral, Primitive, Semantic)
    ├── Size.swift             # BorderRadius values
    └── Typography.swift       # FontSize, FontWeight, FontFamily
```

### Design Tokens

The design system uses centralized token definitions:

**Colors** (`AppColor.swift`):
- `Neutral` - white, black, SolidGray, OpacityGray scales
- `Primitive` - Color scales (Blue, LightBlue, Cyan, Green, Lime, Yellow, Orange, Red, Magenta, Purple)
  - Each scale has 50-1200 values (e.g., `blue50`, `blue100`, ..., `blue1200`)
- `Semantic` - Purpose-based colors (Error, Success, Warning)

**Sizing** (`Size.swift`):
- `BorderRadius` - val4, val6, val8, val12, val16, val24, val32, full (9999)

**Typography** (`Typography.swift`):
- `FontSize` - size14 through size64
- `FontWeight` - regular, bold
- `FontFamily` - sans (Noto Sans JP), mono (Noto Sans Mono)

### Component Patterns

**Variant Pattern**: Components use type-safe enum-based variants for state management.
```swift
// Example: ButtonTypeVariant for button states
enum ButtonTypeVariant: CaseIterable {
    case _default, hover, active, disabled
}

// Example: ButtonSizeVariant for size options
enum ButtonSizeVariant: CaseIterable {
    case small, medium, large
}
```

**Generic Components**: Recent components use Swift generics for type safety.
```swift
// SelectBox supports any Hashable type
public struct SelectBox<T: Hashable>: View {
    @Binding var selection: T
    let options: [T]
    let optionLabel: (T) -> String
    // ...
}
```

**State Props Pattern**: Components receive state as props rather than managing internal state.
- `isFocused: Bool` - Focus state indicator
- `isDisabled: Bool` - Disabled state
- `error: String?` - Error message and state

**Focus State Handling** (see `Docs/Design/FocusState.md`):
1. Single form items: Parent view applies `.focused()`
2. Complex forms: Pass `FocusState.Binding` to components for internal focus management
3. Visual feedback: Components handle focus-based styling when receiving `isFocused: Bool`

**Accessibility**: Components include proper accessibility labels, values, and hints.
```swift
.accessibilityLabel(placeholder)
.accessibilityValue(optionLabel(selection))
.accessibilityHint(error ?? "")
```

**Custom SwiftUI Styles**: Some components extend SwiftUI's native style protocols.
```swift
// ProgressIndicator uses ProgressViewStyle for consistent API
public struct DADSCircularProgressViewStyle: ProgressViewStyle {
    public func makeBody(configuration: Configuration) -> some View {
        // Custom circular progress rendering
        let progress = configuration.fractionCompleted ?? 0
        // ...
    }
}

// Extension for convenience
extension ProgressViewStyle where Self == DADSCircularProgressViewStyle {
    public static var dadsCircular: DADSCircularProgressViewStyle {
        DADSCircularProgressViewStyle()
    }
}

// Usage
ProgressView("Loading", value: 0.5)
    .progressViewStyle(.dadsCircular(size: 48))
```

### Preview Strategy

All components include comprehensive SwiftUI Previews demonstrating:
- All variant combinations (type × size)
- All states (default, hover, focus, error, disabled)
- Multiple widths/sizes
- Both focused and unfocused states

Example preview pattern:
```swift
#Preview {
    @Previewable @State var selectedOption = "オプション1"

    ScrollView {
        VStack {
            // Default state
            // Hover state
            // Focus state
            // Error state
            // Disabled state
        }
    }
}
```

## Component Implementation Workflow

1. Check `COMPONENT_STATUS.md` for component status and reference paths
2. Reference design specs in `Docs/Components/` if available
3. Use design tokens from `Definitions/` directory
4. Follow variant pattern for states (default, hover, active, disabled)
5. Include comprehensive preview with all states
6. Add accessibility support (labels, values, hints)
7. **Update `COMPONENT_STATUS.md`** when implementation is complete:
   - Change status from 🔴 (Not Started) or 🟡 (In Progress) to 🟢 (Completed)
   - Add file path in the "パス" column (e.g., `ProtoDesignSystem/Sources/DesignSystem/Components/ComponentName`)
   - Add entry to "更新履歴" (Update History) section at the top:
     ```
     - YYYY-MM-DD: ComponentName実装完了（key features）
     ```
   - Example entry: `- 2025-11-30: SelectBoxをリファクタリング（ジェネリック型サポート、エラー状態、アクセシビリティ対応を追加）`

## Git Operations Policy

**IMPORTANT**: Do NOT commit, push, or create pull requests unless explicitly requested by the user.

- Wait for explicit instructions like:
  - "コミットしてください" / "commit this"
  - "プルリクエストを作成してください" / "create a pull request"
  - "push してください" / "push to remote"
- After completing implementation or fixes, inform the user and wait for their decision
- Exception: Only proceed with git operations when the user provides clear instructions

## Design Guidelines

- **Focus Indicators**: Black outer border (4px) + Yellow inner border (2px, `yellow300`)
- **Error States**: Red border and text (`Semantic.Error.error1`)
- **Disabled States**: Gray fill background + lighter gray borders/text
- **Border Radius**: Use `Size.BorderRadius.val8` (8px) for most components
- **Padding**: Components use size-specific padding (varies by ButtonSizeVariant, etc.)

## Documentation and Project Organization

### Documentation Locations

- **`docs/`** - Hugo site for UI Snapshot Catalog (GitHub Pages)
  - **IMPORTANT**: This directory is for Hugo view files only (content, layouts, static assets)
  - Do NOT place implementation plans or documentation markdown files here
  - Contains: `content/`, `data/`, `layouts/`, `static/`, `hugo.toml`

- **`Prompts/`** - AI coding assistant workspace (Git-ignored except for Plan/)
  - `Prompts/Plan/` - Implementation plans and design documents (Git-tracked)
    - Example: `Implementation-Plan-Snapshot-Catalog-Improvements.md`
    - Example: `Prefire-Configuration.md`
  - Other files in `Prompts/` are temporary and Git-ignored
  - Maintained by `.gitkeep` to preserve directory structure

- **`Scripts/`** - Build and deployment scripts with documentation
  - `Scripts/README.md` - Script usage and customization guide

### When to Create Implementation Plans

When creating implementation plan markdown files, always place them in `Prompts/Plan/`:

```bash
# Correct location
Prompts/Plan/Implementation-Plan-Feature-Name.md
Prompts/Plan/Component-Specification.md

# Incorrect locations (do NOT use)
Docs/Plan-*.md  # docs/ is for Hugo only
./Plan-*.md     # root directory should be clean
```

## UI Snapshot Catalog

### Overview

The project maintains an automated UI snapshot catalog built with Hugo and deployed to GitHub Pages. Snapshot PNGs from SwiftUI Preview tests are automatically converted to a searchable web gallery.

### Workflow

```
1. SwiftUI Preview (#Preview macro)
   ↓
2. Prefire detects previews (.prefire.yml configuration)
   ↓
3. Generate PreviewTests.generated.swift
   ↓
4. Run tests in Xcode
   ↓
5. Output PNGs to ProtoDesignSystemTests/__Snapshots__/
   ↓
6. Run Scripts/prepare_snapshot_catalog.py
   ↓
7. Copy to docs/static/snapshots/ + Generate docs/data/snapshots.json
   ↓
8. Hugo builds catalog site → GitHub Pages
```

### Key Files

- **`.prefire.yml`** - Prefire configuration for snapshot test generation
  - Defines snapshot devices (iPhone 14, iPad)
  - Specifies preview source paths
  - See `Prompts/Plan/Prefire-Configuration.md` for details

- **`Scripts/prepare_snapshot_catalog.py`** - Snapshot processing script
  - **Metadata extraction**: Parses filenames like `Button_small_hover_0.1.png`
    - Extracts: component, category, variant, state
  - **Category mapping**: Auto-categorizes (Form/Content/Feedback/Other)
  - **Grouped JSON output**: `by_category` for organized display
  - Options: `--clean`, `--dry-run`
  - See `Scripts/README.md` for usage

- **`Scripts/test_metadata_extraction.py`** - Test suite for metadata extraction
  - 6 test cases covering various filename patterns
  - Run: `python Scripts/test_metadata_extraction.py`

### Snapshot Filename Convention

For optimal metadata extraction, name previews with this pattern:

```swift
#Preview("ComponentName_variant_state") {
    Button(label: "ボタン", size: .small, state: .hover)
}
```

Results in filename: `Button_small_hover_0.1.png`

Extracted metadata:
- `component`: "Button"
- `category`: "Form" (from COMPONENT_CATEGORIES mapping)
- `variant`: "small"
- `state`: "hover"

### Running Locally

```bash
# Generate snapshot data with metadata extraction
python Scripts/prepare_snapshot_catalog.py --clean

# Preview changes without modifying files
python Scripts/prepare_snapshot_catalog.py --dry-run

# Start Hugo dev server
cd docs && hugo server
```

### Implementation Plans

Snapshot catalog improvements are tracked in:
- `Prompts/Plan/Implementation-Plan-Snapshot-Catalog-Improvements.md`
- `Prompts/Plan/Snapshot-Metadata-Extraction-Implementation.md` (Phase 2 complete)
- `Prompts/Plan/Phase1-Prefire-Configuration-Summary.md` (Phase 1 complete)
