# adaptive_svg

Platform-adaptive SVG rendering for Flutter. DOM `<svg>` on web, `flutter_svg` on native.

## Build & Test

```bash
# Get dependencies
flutter pub get

# Run analysis
just analyze

# Run tests
just test

# Run example on web
cd example && flutter run -d chrome

# Dry-run publish
just publish-dry
```

## Publishing

1. Bump version in `pubspec.yaml` and update `CHANGELOG.md`
2. Commit and tag: `git tag v<version>`
3. Push: `git push && git push --tags`
4. GitHub Actions publishes to pub.dev via OIDC (configured on pub.dev admin)

## Layout

- `lib/src/adaptive_svg.dart` — `AdaptiveSvg` widget + `.asset()` constructor
- `lib/src/svg_web.dart` — DOM `<svg>` rendering (web only, conditional import)
- `lib/src/svg_web_stub.dart` — Stub that throws on non-web platforms
- `example/` — Side-by-side comparison app (AdaptiveSvg vs flutter_svg)
- `example/lib/svg_samples.dart` — 25+ SVG test cases across 15 categories

## Key Design Decisions

- This is a **routing layer**, not a renderer. Web delegates to the browser's native SVG engine, native delegates to `flutter_svg`.
- Conditional import via `dart.library.js_interop` to split web/native code paths
- `HtmlElementView` embeds raw `<svg>` elements in the DOM on web
- SVG element width/height must be set via `setAttribute`, not `.style` — SVG elements are `SVGElement`, not `HTMLElement`
- `flutter_svg` limitations (filters, animations, CSS, foreignObject, external images, nested SVGs) are the motivation — the example app demonstrates all of these

## Publisher

Published to pub.dev under `rjmath.com`. OIDC automated publishing is configured for `rlch/adaptive_svg` with tag pattern `v{{version}}`.
