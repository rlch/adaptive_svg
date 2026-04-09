import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

int _viewId = 0;

Widget svgString(
  String svg, {
  double? width,
  double? height,
  Key? key,
}) {
  final viewType = 'adaptive-svg-${_viewId++}';
  ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
    final container = web.document.createElement('div') as web.HTMLDivElement;
    container.innerHTML = svg.toJS;
    container.style
      ..width = '100%'
      ..height = '100%'
      ..display = 'flex'
      ..alignItems = 'center'
      ..justifyContent = 'center';
    // Ensure the <svg> element fills its container.
    final svgEl = container.querySelector('svg');
    if (svgEl != null) {
      svgEl as web.HTMLElement;
      svgEl.style
        ..width = '100%'
        ..height = '100%';
    }
    return container;
  });

  return SizedBox(
    width: width,
    height: height,
    child: HtmlElementView(viewType: viewType, key: key),
  );
}

Widget svgAsset(
  String assetName, {
  double? width,
  double? height,
  AssetBundle? bundle,
  String? package,
  Key? key,
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
        );
      },
    ),
  );
}
