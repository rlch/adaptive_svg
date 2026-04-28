import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import 'cross_origin.dart';
import 'svg_web_stub.dart'
    if (dart.library.js_interop) 'svg_web.dart'
    as platform;

export 'cross_origin.dart';

/// Renders SVGs using the browser's native `<svg>` element on web,
/// and [flutter_svg] on all other platforms.
///
/// ## Gesture handling
///
/// On web, [AdaptiveSvg] is rendered through an [HtmlElementView] platform
/// view. Platform views punch a "hole" in Flutter's glass pane, which means
/// ancestor [GestureDetector] / [InkWell] widgets do **not** receive taps on
/// the SVG region — even when the SVG itself has `pointer-events: none`.
///
/// Set [gestures] to `true` and pass any of [onTap], [onTapDown],
/// [onLongPress], [onSecondaryTap] or [onHover] to wire up gesture handling
/// that Just Works on both web and native:
///
/// ```dart
/// AdaptiveSvg(
///   svg,
///   gestures: true,
///   onTap: () => print('tapped'),
/// )
/// ```
///
/// On web this stacks a [PointerInterceptor] containing a [GestureDetector]
/// above the platform view, forwarding pointer events back to Flutter's
/// gesture system. On native it just wraps the SVG with a [GestureDetector].
///
/// When [gestures] is `false` (the default), no gesture widgets are built at
/// all — the rendered tree is just the bare SVG.
///
/// ## Web-only options
///
/// - [interactive] (default `true`): when `false`, applies
///   `pointer-events: none` to the container so taps / hovers flow
///   through to the Flutter widget layer underneath. Mostly superseded by
///   [gestures] — use that instead.
///
/// - [imageCrossOrigin]: when set, applies the `crossorigin` attribute
///   to every `<image>` child before inserting the SVG. Forces the
///   browser to use a CORS-mode image fetch, which is required under
///   `Cross-Origin-Embedder-Policy: require-corp` if the image server
///   only sends `Access-Control-Allow-Origin` (and not
///   `Cross-Origin-Resource-Policy`).
class AdaptiveSvg extends StatelessWidget {
  /// Raw SVG markup string.
  final String svgString;

  final double? width;
  final double? height;
  final BoxFit fit;
  final ColorFilter? colorFilter;

  /// When `true`, wraps the rendered SVG in a [GestureDetector] (native) or
  /// in a [PointerInterceptor] + [GestureDetector] overlay (web) so the
  /// gesture callbacks below fire reliably across platforms.
  ///
  /// When `false` (default), no gesture widgets are built — the rendered
  /// tree is just the bare SVG.
  final bool gestures;

  /// Fires on a primary-button tap. Requires [gestures] to be `true`.
  final GestureTapCallback? onTap;

  /// Fires when the primary pointer goes down. Requires [gestures] to be `true`.
  final GestureTapDownCallback? onTapDown;

  /// Fires on a long-press. Requires [gestures] to be `true`.
  final GestureLongPressCallback? onLongPress;

  /// Fires on a secondary-button tap (right-click on web/desktop).
  /// Requires [gestures] to be `true`.
  final GestureTapCallback? onSecondaryTap;

  /// Fires `true` when the pointer enters the SVG bounds and `false` when it
  /// exits. Requires [gestures] to be `true`.
  final ValueChanged<bool>? onHover;

  /// Mouse cursor shown over the SVG region. Only applied when [gestures] is
  /// `true`. Defaults to [SystemMouseCursors.click] when [onTap] is non-null,
  /// otherwise [MouseCursor.defer].
  final MouseCursor? mouseCursor;

  /// Whether the rendered SVG should receive pointer events.
  ///
  /// Web only. On native, `flutter_svg` is always non-interactive.
  final bool interactive;

  /// `crossorigin` attribute applied to every `<image>` child of the
  /// parsed SVG on web.
  ///
  /// Web only. On native, ignored.
  final CrossOrigin? imageCrossOrigin;

  /// Rounded-corner clip applied to the rendered SVG.
  ///
  /// On web this is applied as CSS `border-radius` + `overflow: hidden` on
  /// the wrapper `<div>` that hosts the platform view, because Flutter's
  /// `ClipRRect` does not reliably clip `HtmlElementView` content. On native
  /// it falls back to wrapping the rendered SVG in a `ClipRRect`.
  final BorderRadius? borderRadius;

  const AdaptiveSvg(
    this.svgString, {
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.colorFilter,
    this.gestures = false,
    this.onTap,
    this.onTapDown,
    this.onLongPress,
    this.onSecondaryTap,
    this.onHover,
    this.mouseCursor,
    this.interactive = true,
    this.imageCrossOrigin,
    this.borderRadius,
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
    bool gestures = false,
    GestureTapCallback? onTap,
    GestureTapDownCallback? onTapDown,
    GestureLongPressCallback? onLongPress,
    GestureTapCallback? onSecondaryTap,
    ValueChanged<bool>? onHover,
    MouseCursor? mouseCursor,
    bool interactive = true,
    CrossOrigin? imageCrossOrigin,
    BorderRadius? borderRadius,
    Key? key,
  }) {
    Widget child;
    if (kIsWeb) {
      child = platform.svgAsset(
        assetName,
        width: width,
        height: height,
        bundle: bundle,
        package: package,
        interactive: interactive,
        imageCrossOrigin: imageCrossOrigin,
        borderRadius: borderRadius,
      );
    } else {
      child = SvgPicture.asset(
        assetName,
        width: width,
        height: height,
        fit: fit,
        colorFilter: colorFilter,
        bundle: bundle,
        package: package,
      );
      if (borderRadius != null) {
        child = ClipRRect(borderRadius: borderRadius, child: child);
      }
    }

    if (!gestures) return KeyedSubtree(key: key, child: child);

    return _wrapGestures(
      key: key,
      width: width,
      height: height,
      onTap: onTap,
      onTapDown: onTapDown,
      onLongPress: onLongPress,
      onSecondaryTap: onSecondaryTap,
      onHover: onHover,
      mouseCursor: mouseCursor,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (kIsWeb) {
      child = platform.svgString(
        svgString,
        width: width,
        height: height,
        interactive: interactive,
        imageCrossOrigin: imageCrossOrigin,
        borderRadius: borderRadius,
      );
    } else {
      child = SvgPicture.string(
        svgString,
        width: width,
        height: height,
        fit: fit,
        colorFilter: colorFilter,
      );
      if (borderRadius != null) {
        child = ClipRRect(borderRadius: borderRadius!, child: child);
      }
    }

    if (!gestures) return child;

    return _wrapGestures(
      width: width,
      height: height,
      onTap: onTap,
      onTapDown: onTapDown,
      onLongPress: onLongPress,
      onSecondaryTap: onSecondaryTap,
      onHover: onHover,
      mouseCursor: mouseCursor,
      child: child,
    );
  }
}

/// Wraps [child] so the gesture callbacks fire on both web and native.
///
/// On web, [HtmlElementView] platform views capture pointer events at the
/// DOM level — ancestor [GestureDetector] widgets never see them. We work
/// around this by stacking a [PointerInterceptor] above the SVG with its
/// own [GestureDetector] inside, which puts a Flutter-controlled HTML
/// element above the platform view and routes events back into Flutter.
///
/// On native we just wrap the SVG with a [MouseRegion] + [GestureDetector],
/// equivalent to what callers would write themselves.
Widget _wrapGestures({
  Key? key,
  double? width,
  double? height,
  GestureTapCallback? onTap,
  GestureTapDownCallback? onTapDown,
  GestureLongPressCallback? onLongPress,
  GestureTapCallback? onSecondaryTap,
  ValueChanged<bool>? onHover,
  MouseCursor? mouseCursor,
  required Widget child,
}) {
  final cursor =
      mouseCursor ??
      (onTap != null ? SystemMouseCursors.click : MouseCursor.defer);

  final hitTarget = MouseRegion(
    cursor: cursor,
    onEnter: onHover != null ? (_) => onHover(true) : null,
    onExit: onHover != null ? (_) => onHover(false) : null,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      onTapDown: onTapDown,
      onLongPress: onLongPress,
      onSecondaryTap: onSecondaryTap,
    ),
  );

  if (kIsWeb) {
    return SizedBox(
      key: key,
      width: width,
      height: height,
      child: Stack(
        children: [
          Positioned.fill(child: child),
          Positioned.fill(child: PointerInterceptor(child: hitTarget)),
        ],
      ),
    );
  }

  // Native: no platform-view hole, so the gesture detector can simply wrap
  // the SVG. Wrapping in MouseRegion preserves hover behavior on desktop.
  return MouseRegion(
    key: key,
    cursor: cursor,
    onEnter: onHover != null ? (_) => onHover(true) : null,
    onExit: onHover != null ? (_) => onHover(false) : null,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      onTapDown: onTapDown,
      onLongPress: onLongPress,
      onSecondaryTap: onSecondaryTap,
      child: child,
    ),
  );
}
