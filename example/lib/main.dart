import 'package:adaptive_svg/adaptive_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'svg_samples.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AdaptiveSvg vs flutter_svg',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const ComparisonPage(),
    );
  }
}

class ComparisonPage extends StatefulWidget {
  const ComparisonPage({super.key});

  @override
  State<ComparisonPage> createState() => _ComparisonPageState();
}

class _ComparisonPageState extends State<ComparisonPage> {
  String? _selectedCategory;

  List<String> get _categories =>
      svgSamples.map((s) => s.category).toSet().toList();

  List<SvgSample> get _filteredSamples => _selectedCategory == null
      ? svgSamples
      : svgSamples.where((s) => s.category == _selectedCategory).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdaptiveSvg vs flutter_svg'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  selected: _selectedCategory == null,
                  onSelected: () =>
                      setState(() => _selectedCategory = null),
                ),
                for (final cat in _categories)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: _FilterChip(
                      label: cat,
                      selected: _selectedCategory == cat,
                      onSelected: () =>
                          setState(() => _selectedCategory = cat),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredSamples.length,
        separatorBuilder: (_, _) => const SizedBox(height: 24),
        itemBuilder: (context, index) {
          final sample = _filteredSamples[index];
          return _ComparisonCard(sample: sample);
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  final SvgSample sample;

  const _ComparisonCard({required this.sample});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: sample.flutterSvgSupported
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.errorContainer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        sample.label,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        sample.category,
                        style: theme.textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
                if (sample.notes != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    sample.notes!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: sample.flutterSvgSupported
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onErrorContainer,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Side-by-side renders
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // AdaptiveSvg (DOM on web)
                Expanded(
                  child: _RenderPane(
                    title: 'AdaptiveSvg (DOM)',
                    child: AdaptiveSvg(sample.svg),
                  ),
                ),
                const VerticalDivider(width: 1),
                // flutter_svg
                Expanded(
                  child: _RenderPane(
                    title: 'flutter_svg',
                    child: SvgPicture.string(sample.svg),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RenderPane extends StatelessWidget {
  final String title;
  final Widget child;

  const _RenderPane({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            title,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Divider(height: 8),
        Container(
          height: 200,
          padding: const EdgeInsets.all(12),
          alignment: Alignment.center,
          child: child,
        ),
      ],
    );
  }
}
