import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
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
  Key? key,
  bool interactive = true,
  bool interceptPointer = false,
  CrossOrigin? imageCrossOrigin,
}) {
  final viewType =
      'adaptive-svg-${Object.hash(svg, interactive, imageCrossOrigin)}';

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

  final view = SizedBox(
    width: width,
    height: height,
    child: HtmlElementView(viewType: viewType, key: key),
  );

  if (!interceptPointer) return view;

  // On Flutter web, `HtmlElementView` creates a platform view that sits
  // above Flutter's canvas in the DOM. Even with `pointer-events: none`
  // CSS, the platform view "hole" in Flutter's glass pane prevents
  // `GestureDetector` parents from receiving taps. `PointerInterceptor`
  // places a transparent Flutter-controlled HTML overlay above the
  // platform view that forwards pointer events back to Flutter.
  return Stack(
    children: [
      view,
      Positioned.fill(
        child: PointerInterceptor(child: const SizedBox.expand()),
      ),
    ],
  );
}

Widget svgAsset(
  String assetName, {
  double? width,
  double? height,
  AssetBundle? bundle,
  String? package,
  Key? key,
  bool interactive = true,
  bool interceptPointer = false,
  CrossOrigin? imageCrossOrigin,
}) {
  final effectiveBundle = bundle ?? rootBundle;
  final effectiveAssetName =
      package != null ? 'packages/$package/$assetName' : assetName;

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
          key: key,
          interactive: interactive,
          interceptPointer: interceptPointer,
          imageCrossOrigin: imageCrossOrigin,
        );
      },
    ),
  );
}
