# adaptive_svg

[![pub package](https://img.shields.io/pub/v/adaptive_svg.svg)](https://pub.dev/packages/adaptive_svg)
[![pub points](https://img.shields.io/pub/points/adaptive_svg)](https://pub.dev/packages/adaptive_svg/score)
[![CI](https://github.com/rlch/adaptive_svg/actions/workflows/publish.yml/badge.svg)](https://github.com/rlch/adaptive_svg/actions/workflows/publish.yml)
[![license](https://img.shields.io/github/license/rlch/adaptive_svg)](https://github.com/rlch/adaptive_svg/blob/main/LICENSE)

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
  adaptive_svg: ^0.3.0
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

### Gesture handling

On web, the SVG is rendered inside an `HtmlElementView`. Platform views punch a hole in Flutter's glass pane, so ancestor `GestureDetector` / `InkWell` widgets do **not** receive taps on the SVG region.

Set `gestures: true` and pass the callbacks you need — the widget stacks a `PointerInterceptor` + `GestureDetector` overlay on web (and just wraps with `GestureDetector` on native):

```dart
AdaptiveSvg(
  svgMarkup,
  gestures: true,
  onTap: () => print('tapped'),
  onLongPress: () => print('long press'),
  onHover: (hovering) => print('hover: $hovering'),
)
```

When `gestures: false` (default) no gesture widgets are built — the rendered tree is just the bare SVG with zero overhead.

### Rounded corners

```dart
AdaptiveSvg(
  svgMarkup,
  width: 200,
  height: 120,
  borderRadius: BorderRadius.circular(16),
)
```

On native, the rendered SVG is wrapped in a `ClipRRect`. On web, CSS `border-radius` + `overflow: hidden` is applied to the wrapper `<div>` that hosts the platform view — Flutter's `ClipRRect` doesn't reliably clip `HtmlElementView` content, so the rounding is baked into the DOM container directly.

### Web-only options

```dart
// Disable pointer events (useful for static thumbnails in a GestureDetector)
AdaptiveSvg(svgMarkup, interactive: false)

// Enable CORS for external <image> elements
AdaptiveSvg(svgMarkup, imageCrossOrigin: CrossOrigin.anonymous)
```

## Example

The `example/` app renders 25+ SVG test cases side-by-side (AdaptiveSvg vs flutter_svg) across 15 categories. Run it on web to see the differences:

```bash
cd example
flutter run -d chrome
```

## License

MIT
