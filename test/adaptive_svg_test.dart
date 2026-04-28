import 'package:adaptive_svg/adaptive_svg.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _sampleSvg =
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">'
    '<circle cx="12" cy="12" r="10"/>'
    '</svg>';

Widget _wrap(Widget child) => MaterialApp(
  home: Scaffold(body: Center(child: child)),
);

void main() {
  group('AdaptiveSvg rendering', () {
    testWidgets('renders SvgPicture.string on non-web', (tester) async {
      await tester.pumpWidget(
        _wrap(const AdaptiveSvg(_sampleSvg, width: 48, height: 48)),
      );

      expect(find.byType(AdaptiveSvg), findsOneWidget);
    });

    testWidgets('AdaptiveSvg.asset returns a sized widget', (tester) async {
      await tester.pumpWidget(
        _wrap(AdaptiveSvg.asset('assets/test.svg', width: 24, height: 24)),
      );

      expect(find.byType(SizedBox), findsWidgets);
    });
  });

  group('gestures: false (default)', () {
    testWidgets('does not build a GestureDetector inside AdaptiveSvg', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const AdaptiveSvg(_sampleSvg, width: 48, height: 48)),
      );

      expect(
        find.descendant(
          of: find.byType(AdaptiveSvg),
          matching: find.byType(GestureDetector),
        ),
        findsNothing,
      );
    });

    testWidgets('callbacks alone do not opt into gesture handling', (
      tester,
    ) async {
      // gestures defaults to false; passing callbacks alone shouldn't wire
      // anything up — the user must opt in via gestures: true.
      await tester.pumpWidget(
        _wrap(AdaptiveSvg(_sampleSvg, width: 48, height: 48, onTap: () {})),
      );

      expect(
        find.descendant(
          of: find.byType(AdaptiveSvg),
          matching: find.byType(GestureDetector),
        ),
        findsNothing,
      );
    });
  });

  group('borderRadius (native)', () {
    testWidgets('does not wrap in ClipRRect when borderRadius is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const AdaptiveSvg(_sampleSvg, width: 48, height: 48)),
      );

      expect(
        find.descendant(
          of: find.byType(AdaptiveSvg),
          matching: find.byType(ClipRRect),
        ),
        findsNothing,
      );
    });

    testWidgets('wraps in ClipRRect with the given radius', (tester) async {
      const radius = BorderRadius.all(Radius.circular(16));
      await tester.pumpWidget(
        _wrap(
          const AdaptiveSvg(
            _sampleSvg,
            width: 48,
            height: 48,
            borderRadius: radius,
          ),
        ),
      );

      final clip = tester.widget<ClipRRect>(
        find
            .descendant(
              of: find.byType(AdaptiveSvg),
              matching: find.byType(ClipRRect),
            )
            .first,
      );
      expect(clip.borderRadius, radius);
    });

    testWidgets('AdaptiveSvg.asset wraps in ClipRRect with the given radius', (
      tester,
    ) async {
      const radius = BorderRadius.all(Radius.circular(8));
      await tester.pumpWidget(
        _wrap(
          AdaptiveSvg.asset(
            'assets/test.svg',
            width: 24,
            height: 24,
            borderRadius: radius,
          ),
        ),
      );

      final clip = tester.widget<ClipRRect>(
        find
            .descendant(
              of: find.byType(KeyedSubtree),
              matching: find.byType(ClipRRect),
            )
            .first,
      );
      expect(clip.borderRadius, radius);
    });

    testWidgets('borderRadius composes with gestures: true', (tester) async {
      const radius = BorderRadius.all(Radius.circular(12));
      await tester.pumpWidget(
        _wrap(
          AdaptiveSvg(
            _sampleSvg,
            width: 48,
            height: 48,
            gestures: true,
            onTap: () {},
            borderRadius: radius,
          ),
        ),
      );

      // ClipRRect still wraps the rendered SVG, and the gesture overlay is
      // present on top.
      expect(
        find.descendant(
          of: find.byType(AdaptiveSvg),
          matching: find.byType(ClipRRect),
        ),
        findsWidgets,
      );
      expect(
        find.descendant(
          of: find.byType(AdaptiveSvg),
          matching: find.byType(GestureDetector),
        ),
        findsWidgets,
      );
    });
  });

  group('gestures: true', () {
    testWidgets('fires onTap when the SVG region is tapped', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _wrap(
          AdaptiveSvg(
            _sampleSvg,
            width: 48,
            height: 48,
            gestures: true,
            onTap: () => taps++,
          ),
        ),
      );

      await tester.tap(find.byType(AdaptiveSvg));
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('fires onLongPress', (tester) async {
      var longPresses = 0;
      await tester.pumpWidget(
        _wrap(
          AdaptiveSvg(
            _sampleSvg,
            width: 48,
            height: 48,
            gestures: true,
            onLongPress: () => longPresses++,
          ),
        ),
      );

      await tester.longPress(find.byType(AdaptiveSvg));
      await tester.pump();

      expect(longPresses, 1);
    });

    testWidgets('fires onTapDown with details', (tester) async {
      TapDownDetails? captured;
      await tester.pumpWidget(
        _wrap(
          AdaptiveSvg(
            _sampleSvg,
            width: 48,
            height: 48,
            gestures: true,
            onTapDown: (details) => captured = details,
          ),
        ),
      );

      await tester.tap(find.byType(AdaptiveSvg));
      await tester.pump();

      expect(captured, isNotNull);
    });

    testWidgets('fires onHover true on enter, false on exit', (tester) async {
      final events = <bool>[];
      await tester.pumpWidget(
        _wrap(
          AdaptiveSvg(
            _sampleSvg,
            width: 48,
            height: 48,
            gestures: true,
            onHover: events.add,
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();

      await gesture.moveTo(tester.getCenter(find.byType(AdaptiveSvg)));
      await tester.pump();
      await gesture.moveTo(const Offset(1000, 1000));
      await tester.pump();

      expect(events, [true, false]);
    });

    testWidgets('builds GestureDetector and MouseRegion', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AdaptiveSvg(
            _sampleSvg,
            width: 48,
            height: 48,
            gestures: true,
            onTap: () {},
          ),
        ),
      );

      expect(find.byType(GestureDetector), findsWidgets);
      expect(find.byType(MouseRegion), findsWidgets);
    });

    testWidgets('mouseCursor defaults to click when onTap is set', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          AdaptiveSvg(
            _sampleSvg,
            width: 48,
            height: 48,
            gestures: true,
            onTap: () {},
          ),
        ),
      );

      // The outermost MouseRegion under AdaptiveSvg should carry the cursor.
      final region = tester.widget<MouseRegion>(
        find
            .descendant(
              of: find.byType(AdaptiveSvg),
              matching: find.byType(MouseRegion),
            )
            .first,
      );
      expect(region.cursor, SystemMouseCursors.click);
    });

    testWidgets('mouseCursor defers when no onTap is set', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AdaptiveSvg(
            _sampleSvg,
            width: 48,
            height: 48,
            gestures: true,
            onLongPress: () {},
          ),
        ),
      );

      final region = tester.widget<MouseRegion>(
        find
            .descendant(
              of: find.byType(AdaptiveSvg),
              matching: find.byType(MouseRegion),
            )
            .first,
      );
      expect(region.cursor, MouseCursor.defer);
    });

    testWidgets('respects an explicit mouseCursor override', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AdaptiveSvg(
            _sampleSvg,
            width: 48,
            height: 48,
            gestures: true,
            onTap: () {},
            mouseCursor: SystemMouseCursors.help,
          ),
        ),
      );

      final region = tester.widget<MouseRegion>(
        find
            .descendant(
              of: find.byType(AdaptiveSvg),
              matching: find.byType(MouseRegion),
            )
            .first,
      );
      expect(region.cursor, SystemMouseCursors.help);
    });
  });
}
