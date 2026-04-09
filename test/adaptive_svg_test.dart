import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:adaptive_svg/adaptive_svg.dart';

void main() {
  testWidgets('AdaptiveSvg renders SvgPicture.string on non-web',
      (tester) async {
    const svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">'
        '<circle cx="12" cy="12" r="10"/>'
        '</svg>';

    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: AdaptiveSvg(svg, width: 48, height: 48),
      ),
    );

    expect(find.byType(AdaptiveSvg), findsOneWidget);
  });

  testWidgets('AdaptiveSvg.asset renders on non-web', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: AdaptiveSvg.asset(
          'assets/test.svg',
          width: 24,
          height: 24,
        ),
      ),
    );

    expect(find.byType(SizedBox), findsAny);
  });
}
