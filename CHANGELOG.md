## 0.3.0

### New: `interceptPointer` option

- `interceptPointer` (default `true`) — when `true`, overlays a transparent
  `PointerInterceptor` on top of the `HtmlElementView`. On Flutter web,
  platform views sit above Flutter's canvas in the DOM and swallow pointer
  events even with `pointer-events: none` CSS — the platform view "hole" in
  Flutter's glass pane prevents parent `GestureDetector` widgets from
  receiving taps. `interceptPointer` places a Flutter-controlled HTML overlay
  above the platform view so events route back through Flutter's gesture
  system.

  Use this when the SVG is a non-interactive thumbnail inside a clickable
  parent (e.g. `GestureDetector`, `InkWell`). Web-only; ignored on native.

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
