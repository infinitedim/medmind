#!/usr/bin/env bash
# tools/generate_isar_schemas.sh
#
# Generates Isar `.g.dart` schema files for all data models in an isolated
# environment, then copies them back into lib/data/models/.
#
# Context: isar_generator 3.x requires build ^2.x which conflicts with the
# main project toolchain (build_runner 2.11+, freezed 3, etc.). This script
# runs build_runner in a temp project that only has isar + isar_generator.
#
# The model files import package:medmind/... — the script rewrites those
# imports to package:isar_gen_helper/... and copies all required files.
#
# Usage:
#   chmod +x tools/generate_isar_schemas.sh
#   ./tools/generate_isar_schemas.sh
#
# Run this whenever you add or modify a file in lib/data/models/.
# Commit the generated *.g.dart files to version control.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MODELS_SRC="$PROJECT_ROOT/lib/data/models"
ENUM_SRC="$PROJECT_ROOT/lib/core/enum/enum_collection.dart"
TMP_DIR="$(mktemp -d)"
HELPER_PKG="isar_gen_helper"

echo "── Isar Schema Generator ─────────────────────────────────────────────────"
echo "Temp dir : $TMP_DIR"
echo "Models   : $MODELS_SRC"
echo ""

# ── 1. Create minimal Flutter helper project ─────────────────────────────────

mkdir -p "$TMP_DIR/lib/data/models"
mkdir -p "$TMP_DIR/lib/core/enum"
mkdir -p "$TMP_DIR/android/app/src/main"

cat > "$TMP_DIR/pubspec.yaml" << EOF
name: $HELPER_PKG
description: Isolated Isar schema generation helper
publish_to: none
version: 0.0.1

environment:
  sdk: '>=2.17.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  isar: ^3.1.0+1
  isar_flutter_libs: ^3.1.0+1

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: '>=2.3.0 <2.9.0'
  isar_generator: ^3.1.0+1
EOF

# Minimal Android files to keep flutter pub get happy
cat > "$TMP_DIR/android/app/src/main/AndroidManifest.xml" << 'EOF'
<manifest xmlns:android="http://schemas.android.com/apk/res/android"/>
EOF

cat > "$TMP_DIR/lib/main.dart" << 'EOF'
void main() {}
EOF

# ── 2. Copy enum file ─────────────────────────────────────────────────────────

cp "$ENUM_SRC" "$TMP_DIR/lib/core/enum/enum_collection.dart"

# ── 3. Copy model files + rewrite imports ────────────────────────────────────

for model_file in "$MODELS_SRC"/*.dart; do
  base="$(basename "$model_file")"
  [[ "$base" == *.g.dart ]] && continue  # skip already-generated files

  dest="$TMP_DIR/lib/data/models/$base"
  cp "$model_file" "$dest"

  # Rewrite package:medmind/ → package:isar_gen_helper/
  sed -i "s|package:medmind/|package:$HELPER_PKG/|g" "$dest"

  # Remove injectable imports (not available in helper project)
  sed -i '/package:injectable\/injectable.dart/d' "$dest"

  echo "  Prepared $base"
done

# ── 4. Run pub get + build_runner ─────────────────────────────────────────────

echo ""
echo "Running flutter pub get in isolated environment..."
cd "$TMP_DIR"
flutter pub get --no-example 2>&1 | grep -v "^$"

echo ""
echo "Running isar_generator..."
dart run build_runner build --delete-conflicting-outputs 2>&1 | \
  grep -E "^\[|Succeeded|Failed|error" || true

# ── 5. Copy generated files back ─────────────────────────────────────────────

GENERATED_COUNT=0
for g_file in "$TMP_DIR/lib/data/models/"*.g.dart; do
  [ -f "$g_file" ] || continue
  base="$(basename "$g_file")"
  dest="$MODELS_SRC/$base"
  cp "$g_file" "$dest"
  echo "  ✓ $base"
  GENERATED_COUNT=$((GENERATED_COUNT + 1))
done

# ── 6. Cleanup ────────────────────────────────────────────────────────────────

cd "$PROJECT_ROOT"
rm -rf "$TMP_DIR"

echo ""
if [ "$GENERATED_COUNT" -gt 0 ]; then
  echo "Done. Generated $GENERATED_COUNT schema file(s) → lib/data/models/"
else
  echo "ERROR: No .g.dart files were generated. Check errors above."
  exit 1
fi
