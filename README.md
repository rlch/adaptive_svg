# adaptive_svg

Platform-adaptive SVG rendering for Flutter. Uses the browser's native `<svg>` element on web, and [flutter_svg](https://pub.dev/packages/flutter_svg) on all other platforms.

## Why?

`flutter_svg` renders SVGs by parsing them into Flutter `Path` objects via Skia/Impeller. This works well for simple icons, but silently drops many SVG features:

| Feature | Browser DOM | flutter_svg |
|---|---|---|
| Filters (blur, shadow, color matrix) | Yes | No |
| CSS animations / `@keyframes` | Yes | No |
| SMIL `<animate>` / `<animateTransform>` | Yes | No |
| `<style>` block with class selectors | Yes | Partial |
| `:hover`, `:focus` pseudo-classes | Yes | No |
| `<foreignObject>` (HTML in SVG) | Yes | No |
| Nested `<svg>` elements | Yes | No |
| External image URLs in `<image>` | Yes | No (data URI only) |
| `letter-spacing` / `word-spacing` | Yes | No |
| Complex masks with gradients | Yes | Partial |

`adaptive_svg` gives you full SVG spec coverage on web by delegating to the DOM, while keeping `flutter_svg` for native where it works well.

## Install

```yaml
dependencies:
  adaptive_svg: ^0.1.0
```

## Usage

```dart
import 'package:adaptive_svg/adaptive_svg.dart';

// From a string
AdaptiveSvg(svgMarkup, width: 48, height: 48)

// From an asset
AdaptiveSvg.asset('assets/icon.svg', width: 24, height: 24)
```

On web, both render inline `<svg>` elements in the DOM. On iOS, Android, macOS, Windows, and Linux, they delegate to `SvgPicture.string` / `SvgPicture.asset` from `flutter_svg`.

## Example

The `example/` app renders 25+ SVG test cases side-by-side (AdaptiveSvg vs flutter_svg) across 15 categories. Run it on web to see the differences:

```bash
cd example
flutter run -d chrome
```

## License

MIT
