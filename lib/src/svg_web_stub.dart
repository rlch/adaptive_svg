import 'package:flutter/widgets.dart';

import 'cross_origin.dart';

Widget svgString(
  String svg, {
  double? width,
  double? height,
  Key? key,
  bool interactive = true,
  CrossOrigin? imageCrossOrigin,
}) {
  throw UnsupportedError('DOM SVG rendering is only available on web');
}

Widget svgAsset(
  String assetName, {
  double? width,
  double? height,
  AssetBundle? bundle,
  String? package,
  Key? key,
  bool interactive = true,
  CrossOrigin? imageCrossOrigin,
}) {
  throw UnsupportedError('DOM SVG rendering is only available on web');
}
