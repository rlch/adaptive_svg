import 'package:flutter/widgets.dart';

Widget svgString(
  String svg, {
  double? width,
  double? height,
  Key? key,
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
}) {
  throw UnsupportedError('DOM SVG rendering is only available on web');
}
