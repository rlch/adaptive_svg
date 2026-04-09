import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'cross_origin.dart';
import 'svg_web_stub.dart' if (dart.library.js_interop) 'svg_web.dart'
    as platform;

export 'cross_origin.dart';

/// Renders SVGs using the browser's native `<svg>` element on web,
/// and [flutter_svg] on all other platforms.
///
/// ## Web-only options
///
/// On web, the SVG is injected into an `HtmlElementView` via a DOM
/// `<div>`. Two optional parameters tune how the resulting element
/// interacts with the host page:
///
/// - [interactive] (default `true`): when `false`, applies
///   `pointer-events: none` to the container so taps / hovers flow
///   through to the Flutter widget layer underneath. Useful for static
///   thumbnails that sit inside a `GestureDetector`.
///
/// - [imageCrossOrigin]: when set, applies the `crossorigin` attribute
///   to every `<image>` child before inserting the SVG. Forces the
///   browser to use a CORS-mode image fetch, which is required under
///   `Cross-Origin-Embedder-Policy: require-corp` if the image server
///   only sends `Access-Control-Allow-Origin` (and not
///   `Cross-Origin-Resource-Policy`).
///
/// On native both parameters are silently ignored — `flutter_svg`
/// renders through Flutter's canvas with no pointer interception and
/// does not load external `<image>` resources.
class AdaptiveSvg extends StatelessWidget {
  /// Raw SVG markup string.
  final String svgString;

  final double? width;
  final double? height;
  final BoxFit fit;
  final ColorFilter? colorFilter;

  /// Whether the rendered SVG should receive pointer events.
  ///
  /// Web only. On native, `flutter_svg` is always non-interactive.
  final bool interactive;

  /// `crossorigin` attribute applied to every `<image>` child of the
  /// parsed SVG on web.
  ///
  /// Web only. On native, ignored.
  final CrossOrigin? imageCrossOrigin;

  const AdaptiveSvg(
    this.svgString, {
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.colorFilter,
    this.interactive = true,
    this.imageCrossOrigin,
    super.key,
  });

  /// Load SVG from an asset path.
  ///
  /// On web, the asset is loaded and rendered as a DOM `<svg>` element.
  /// On native, delegates to [SvgPicture.asset].
  static Widget asset(
    String assetName, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    ColorFilter? colorFilter,
    AssetBundle? bundle,
    String? package,
    bool interactive = true,
    CrossOrigin? imageCrossOrigin,
    Key? key,
  }) {
    if (kIsWeb) {
      return platform.svgAsset(
        assetName,
        width: width,
        height: height,
        bundle: bundle,
        package: package,
        interactive: interactive,
        imageCrossOrigin: imageCrossOrigin,
        key: key,
      );
    }
    return SvgPicture.asset(
      assetName,
      width: width,
      height: height,
      fit: fit,
      colorFilter: colorFilter,
      bundle: bundle,
      package: package,
      key: key,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return platform.svgString(
        svgString,
        width: width,
        height: height,
        interactive: interactive,
        imageCrossOrigin: imageCrossOrigin,
        key: key,
      );
    }
    return SvgPicture.string(
      svgString,
      width: width,
      height: height,
      fit: fit,
      colorFilter: colorFilter,
    );
  }
}
