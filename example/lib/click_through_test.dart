// Demonstrates gesture handling on `AdaptiveSvg`.
//
// On web, `HtmlElementView` punches a "hole" in Flutter's glass pane that
// swallows taps before they reach ancestor `GestureDetector` / `InkWell`
// widgets. The `gestures: true` flag opts into a `PointerInterceptor` +
// `GestureDetector` overlay that fixes this.

import 'package:adaptive_svg/adaptive_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const String _sampleSvg = '''
<svg width="200" height="120" xmlns="http://www.w3.org/2000/svg">
  <rect width="200" height="120" fill="#e0f2fe"/>
  <circle cx="100" cy="60" r="40" fill="#0284c7"/>
  <text x="100" y="65" font-size="16" fill="white" text-anchor="middle">SVG</text>
</svg>''';

class ClickThroughTestPage extends StatefulWidget {
  const ClickThroughTestPage({super.key});

  @override
  State<ClickThroughTestPage> createState() => _ClickThroughTestPageState();
}

class _ClickThroughTestPageState extends State<ClickThroughTestPage> {
  final Map<String, int> _taps = <String, int>{};

  void _registerTap(String key) {
    setState(() => _taps[key] = (_taps[key] ?? 0) + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Click-through test')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _Instructions(),
          const SizedBox(height: 16),
          _TestRow(
            title: 'Bare AdaptiveSvg (gestures: false, default)',
            expectation:
                'On web, the parent GestureDetector does NOT receive taps on '
                'the SVG region — the platform view captures them.',
            count: _taps['bare'] ?? 0,
            onTap: () => _registerTap('bare'),
            child: AdaptiveSvg(_sampleSvg, width: 200, height: 120),
          ),
          _TestRow(
            title: 'AdaptiveSvg with gestures: true + onTap',
            expectation:
                'Tapping on the SVG fires the inner onTap. Tapping the rest '
                "of the row reaches the parent's GestureDetector.",
            count: _taps['gesture'] ?? 0,
            onTap: () => _registerTap('gesture'),
            child: AdaptiveSvg(
              _sampleSvg,
              width: 200,
              height: 120,
              gestures: true,
              onTap: () => _registerTap('gesture'),
            ),
          ),
          _InkWellRow(
            title: 'InkWell ancestor of AdaptiveSvg(gestures: false)',
            expectation:
                'The platform-view hole still swallows taps on the SVG. The '
                "ink ripple won't trigger when clicking directly on the SVG.",
            count: _taps['inkwell-bare'] ?? 0,
            onTap: () => _registerTap('inkwell-bare'),
            child: AdaptiveSvg(_sampleSvg, width: 200, height: 120),
          ),
          _TestRow(
            title: 'Baseline: flutter_svg (Flutter-rendered)',
            expectation: 'Baseline: taps always reach parent.',
            count: _taps['baseline'] ?? 0,
            onTap: () => _registerTap('baseline'),
            child: SvgPicture.string(_sampleSvg, width: 200, height: 120),
          ),
          _TestRow(
            title: 'borderRadius: BorderRadius.circular(24)',
            expectation:
                'The SVG corners are clipped via CSS border-radius on web '
                '(or ClipRRect on native).',
            count: _taps['radius'] ?? 0,
            onTap: () => _registerTap('radius'),
            child: AdaptiveSvg(
              _sampleSvg,
              width: 200,
              height: 120,
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          _TestRow(
            title: 'borderRadius + gestures: true + onTap',
            expectation:
                'Rounded SVG with a working onTap. Tapping the SVG region '
                'fires the inner onTap.',
            count: _taps['radius-tap'] ?? 0,
            onTap: () => _registerTap('radius-tap'),
            child: AdaptiveSvg(
              _sampleSvg,
              width: 200,
              height: 120,
              gestures: true,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              onTap: () => _registerTap('radius-tap'),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: FilledButton(
              onPressed: () => setState(_taps.clear),
              child: const Text('Reset counters'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Instructions extends StatelessWidget {
  const _Instructions();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Padding(
        padding: EdgeInsets.all(12),
        child: Text(
          'Each row has an ancestor tap handler wrapping an SVG. Click '
          'directly on the SVG pixels and watch the counter. Rows that need '
          'gesture handling should use AdaptiveSvg(gestures: true).',
        ),
      ),
    );
  }
}

class _TestRow extends StatelessWidget {
  const _TestRow({
    required this.title,
    required this.expectation,
    required this.count,
    required this.onTap,
    required this.child,
  });

  final String title;
  final String expectation;
  final int count;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      expectation,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Taps registered: $count',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: count > 0
                            ? Colors.green.shade700
                            : theme.colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 200,
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(4),
                ),
                clipBehavior: Clip.antiAlias,
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InkWellRow extends StatelessWidget {
  const _InkWellRow({
    required this.title,
    required this.expectation,
    required this.count,
    required this.onTap,
    required this.child,
  });

  final String title;
  final String expectation;
  final int count;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      expectation,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Taps registered: $count',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: count > 0
                            ? Colors.green.shade700
                            : theme.colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 200,
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(4),
                ),
                clipBehavior: Clip.antiAlias,
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
