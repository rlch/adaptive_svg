## 0.5.0

### New: `borderRadius` parameter

- `borderRadius` — rounds the corners of the rendered SVG.
- On web, applied as CSS `border-radius` + `overflow: hidden` on the
  wrapper `<div>` that hosts the platform view. Flutter's `ClipRRect`
  doesn't reliably clip `HtmlElementView` content, so the rounding is
  baked into the DOM container directly.
- On native, falls back to wrapping the rendered widget in a
  `ClipRRect`.
- Available on both `AdaptiveSvg(...)` and `AdaptiveSvg.asset(...)`.

## 0.4.0

### New: built-in gesture handling

- `gestures` (default `false`) — when `true`, wires up gesture handling that
  works the same on web and native. On web, the widget stacks a
  `PointerInterceptor` + `GestureDetector` above the platform view so
  pointer events route back into Flutter's gesture system; on native it
  just wraps the SVG with a `GestureDetector`. When `false`, no gesture
  widgets are built at all.
- New callbacks (only fire when `gestures: true`): `onTap`, `onTapDown`,
  `onLongPress`, `onSecondaryTap`, `onHover`.
- New `mouseCursor` parameter — defaults to `SystemMouseCursors.click` when
  `onTap` is provided, otherwise `MouseCursor.defer`.

### Breaking: `interceptPointer` removed

- The previous `interceptPointer` parameter overlaid an empty
  `PointerInterceptor` that captured pointer events without forwarding them
  anywhere — it blocked the platform-view "hole" but had no gesture handler
  inside, so ancestor `GestureDetector` / `InkWell` widgets still never
  received taps. The new `gestures: true` API replaces it.
- Migration: replace `AdaptiveSvg(svg, interceptPointer: true)` with
  `AdaptiveSvg(svg, gestures: true, onTap: ...)`.

## 0.3.0

### New: `interceptPointer` option (removed in 0.4.0)

- Added an `interceptPointer` parameter that overlaid a `PointerInterceptor`
  on top of the `HtmlElementView`. Removed in 0.4.0 in favor of
  `gestures: true` — see above.

### Dependency

- Added `pointer_interceptor: ^0.10.1` as a dependency.

## 0.2.0

### Web rendering fixes

- **Parse SVG with `DOMParser('image/svg+xml')`** instead of `div.innerHTML = svg`.
  `innerHTML` parses input as HTML — SVG namespaces on child elements were
  inconsistently preserved, and `<image href>` elements could be misparsed
  as HTML `<img>` fallbacks (which silently dropped cross-origin loads).
  DOMParser parses the input as real XML, preserves every namespace, and
  exposes parse errors through a `<parsererror>` element.
- **Cache `HtmlElementView` view factories** keyed by
  `(svg, interactive, imageCrossOrigin)`. Previously every widget rebuild
  incremented a global `_viewId` counter and registered a brand-new platform
  view, leaking a factory per frame on any list / scroll-based UI.

### New web-only options

- `interactive` (default `true`) — when `false`, applies
  `pointer-events: none` to both the container `<div>` and the injected
  `<svg>` root so taps and hovers flow through to the Flutter widget layer
  underneath. Useful for static thumbnails inside a `GestureDetector`.
- `imageCrossOrigin` (default `null`) — when set to `CrossOrigin.anonymous`
  or `CrossOrigin.useCredentials`, applies the `crossorigin` attribute to
  every `<image>` child of the parsed SVG. Required for cross-origin images
  to load under `Cross-Origin-Embedder-Policy: require-corp` (used by apps
  that need `SharedArrayBuffer`, including Flutter Rust Bridge's threaded
  wasm mode) when the origin server only sends `Access-Control-Allow-Origin`
  and not `Cross-Origin-Resource-Policy`.

Both parameters are web-only and silently ignored on native platforms.

## 0.1.0

- Initial release
- DOM `<svg>` rendering on web
- `flutter_svg` delegation on native platforms
