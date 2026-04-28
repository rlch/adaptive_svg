import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

import 'cross_origin.dart';

/// Registry of platform-view factories we've already installed, keyed by
/// `viewType`. Registering the same type twice throws, so we track them.
final Set<String> _registered = <String>{};

/// Inject raw SVG markup into a DOM `<div>` wrapped in an `HtmlElementView`.
///
/// Uses `DOMParser('image/svg+xml')` rather than `div.innerHTML = ...` so the
/// SVG's XML namespace is preserved on every descendant. This is the only
/// reliable way to embed `<image href>` elements whose cross-origin images
/// need to resolve via the real SVG image loader — not an HTML `<img>`
/// fallback.
///
/// One view factory is registered per unique
/// `(svg, interactive, imageCrossOrigin)` triple. Previously this file
/// incremented a global `_viewId` counter on every call, leaking a new
/// factory on every widget rebuild.
Widget svgString(
  String svg, {
  double? width,
  double? height,
  bool interactive = true,
  CrossOrigin? imageCrossOrigin,
  BorderRadius? borderRadius,
}) {
  // Include `borderRadius` in the view-type key so each radius gets its own
  // factory — radii are baked into the container's CSS at registration time.
  final viewType =
      'adaptive-svg-${Object.hash(svg, interactive, imageCrossOrigin, borderRadius)}';

  if (!_registered.contains(viewType)) {
    _registered.add(viewType);
    ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
      final container = web.document.createElement('div') as web.HTMLDivElement;
      container.style
        ..width = '100%'
        ..height = '100%'
        ..display = 'flex'
        ..alignItems = 'center'
        ..justifyContent = 'center';
      if (borderRadius != null) {
        // Clip the platform view at the DOM layer. Flutter's `ClipRRect`
        // doesn't reliably clip `HtmlElementView` content (the platform view
        // sits in a DOM hole above Flutter's canvas), so we apply the
        // rounding via CSS `border-radius` + `overflow: hidden` directly on
        // the wrapper `<div>` that hosts the SVG.
        container.style
          ..borderTopLeftRadius = '${borderRadius.topLeft.x}px'
          ..borderTopRightRadius = '${borderRadius.topRight.x}px'
          ..borderBottomLeftRadius = '${borderRadius.bottomLeft.x}px'
          ..borderBottomRightRadius = '${borderRadius.bottomRight.x}px'
          ..overflow = 'hidden';
      }
      if (!interactive) {
        container.style.pointerEvents = 'none';
      }

      final parser = web.DOMParser();
      final doc = parser.parseFromString(svg.toJS, 'image/svg+xml');
      final root = doc.documentElement;
      if (root == null) {
        // Parser returned an empty document — nothing to render.
        return container;
      }

      // Clone so mutations don't touch the parser's internal Document.
      final cloned = root.cloneNode(true) as web.Element;
      cloned.setAttribute('width', '100%');
      cloned.setAttribute('height', '100%');
      if (!interactive) {
        cloned.setAttribute('style', 'pointer-events: none;');
      }

      if (imageCrossOrigin != null) {
        // Apply `crossorigin` to every `<image>` child. This forces the
        // browser to upgrade those fetches to CORS mode, which is required
        // under `Cross-Origin-Embedder-Policy: require-corp` to display
        // cross-origin images whose servers only send
        // `Access-Control-Allow-Origin` (not `Cross-Origin-Resource-Policy`).
        final images = cloned.getElementsByTagName('image');
        for (var i = 0; i < images.length; i++) {
          images.item(i)?.setAttribute('crossorigin', imageCrossOrigin.value);
        }
      }

      container.appendChild(cloned);
      return container;
    });
  }

  return SizedBox(
    width: width,
    height: height,
    child: HtmlElementView(viewType: viewType),
  );
}

Widget svgAsset(
  String assetName, {
  double? width,
  double? height,
  AssetBundle? bundle,
  String? package,
  bool interactive = true,
  CrossOrigin? imageCrossOrigin,
  BorderRadius? borderRadius,
}) {
  final effectiveBundle = bundle ?? rootBundle;
  final effectiveAssetName = package != null
      ? 'packages/$package/$assetName'
      : assetName;

  return SizedBox(
    width: width,
    height: height,
    child: FutureBuilder<String>(
      future: effectiveBundle.loadString(effectiveAssetName),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        return svgString(
          snapshot.data!,
          width: width,
          height: height,
          interactive: interactive,
          imageCrossOrigin: imageCrossOrigin,
          borderRadius: borderRadius,
        );
      },
    ),
  );
}
