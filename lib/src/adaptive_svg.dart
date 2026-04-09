import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'svg_web_stub.dart' if (dart.library.js_interop) 'svg_web.dart'
    as platform;

/// Renders SVGs using the browser's native `<svg>` element on web,
/// and [flutter_svg] on all other platforms.
class AdaptiveSvg extends StatelessWidget {
  /// Raw SVG markup string.
  final String svgString;

  final double? width;
  final double? height;
  final BoxFit fit;
  final ColorFilter? colorFilter;

  const AdaptiveSvg(
    this.svgString, {
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.colorFilter,
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
    Key? key,
  }) {
    if (kIsWeb) {
      return platform.svgAsset(
        assetName,
        width: width,
        height: height,
        bundle: bundle,
        package: package,
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
