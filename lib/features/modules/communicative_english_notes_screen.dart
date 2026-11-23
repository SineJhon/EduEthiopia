import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/widgets/theme_toggle.dart';

class CommunicativeEnglishNotesScreen extends StatefulWidget {
  const CommunicativeEnglishNotesScreen({
    this.assetPath = 'assets/content/communicative_english_1/notes.json',
    this.appBarTitle = 'Communicative English',
    this.courseCode = 'FLEn 1011',
    super.key,
  });

  final String assetPath;
  final String appBarTitle;
  final String courseCode;

  @override
  State<CommunicativeEnglishNotesScreen> createState() =>
      _CommunicativeEnglishNotesScreenState();
}

class _CommunicativeEnglishNotesScreenState
    extends State<CommunicativeEnglishNotesScreen> {
  Map<String, dynamic>? _content;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    try {
      final source = await rootBundle.loadString(widget.assetPath);
      final decoded = jsonDecode(source);
      if (!mounted) return;
      setState(() {
        _content = Map<String, dynamic>.from(decoded as Map);
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not load the study notes.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.appBarTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: const [ThemeToggle(), SizedBox(width: 8)],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(_error!, textAlign: TextAlign.center),
              ),
            )
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              children: [
                Text(
                  (_content!['subjectTitle'] as String),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.courseCode,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (_content!['guideDescription'] is String) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colorScheme.outlineVariant),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.auto_stories_rounded, color: colorScheme.primary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _content!['guideDescription'] as String,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.4,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                for (final unitValue in _content!['units'] as List<dynamic>)
                  _UnitCard(unit: Map<String, dynamic>.from(unitValue as Map)),
              ],
            ),
    );
  }
}

class _UnitCard extends StatelessWidget {
  const _UnitCard({required this.unit});

  final Map<String, dynamic> unit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final topics = (unit['topics'] as List<dynamic>)
        .map((value) => Map<String, dynamic>.from(value as Map))
        .toList();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: ExpansionTile(
        initiallyExpanded: false,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        title: Text(
          unit['title'] as String,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          unit['sourcePages'] is String
              ? '${topics.length} topics  •  Module pp. ${unit['sourcePages']}'
              : '${topics.length} topics',
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
        children: [
          for (final topic in topics) _TopicCard(topic: topic),
        ],
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  const _TopicCard({required this.topic});

  final Map<String, dynamic> topic;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final sections = (topic['sections'] as List<dynamic>)
        .map((value) => Map<String, dynamic>.from(value as Map))
        .toList();

    return Card(
      margin: const EdgeInsets.only(top: 8),
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              topic['title'] as String,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            for (final section in sections) ...[
              _Section(section: section),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.section});

  final Map<String, dynamic> section;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final heading = section['heading'] as String?;
    final paragraphs = (section['paragraphs'] as List<dynamic>?)
            ?.map((value) => value as String)
            .toList() ??
        const <String>[];
    final bullets = (section['bullets'] as List<dynamic>?)
            ?.map((value) => value as String)
            .toList() ??
        const <String>[];
    final tableValue = section['table'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (heading != null) ...[
          Text(
            heading,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 6),
        ],
        for (final paragraph in paragraphs) ...[
          Text(
            paragraph,
            style: const TextStyle(height: 1.45),
          ),
          const SizedBox(height: 6),
        ],
        for (final bullet in bullets)
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(color: colorScheme.primary)),
                Expanded(
                  child: Text(bullet, style: const TextStyle(height: 1.4)),
                ),
              ],
            ),
          ),
        if (tableValue != null)
          _Table(table: Map<String, dynamic>.from(tableValue as Map)),
      ],
    );
  }
}

class _Table extends StatelessWidget {
  const _Table({required this.table});

  final Map<String, dynamic> table;

  @override
  Widget build(BuildContext context) {
    final headers = (table['headers'] as List<dynamic>)
        .map((value) => value as String)
        .toList();
    final rows = (table['rows'] as List<dynamic>)
        .map(
          (row) =>
              (row as List<dynamic>).map((value) => value as String).toList(),
        )
        .toList();
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.only(top: 6),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Table(
          defaultColumnWidth: const IntrinsicColumnWidth(),
          border: TableBorder.symmetric(
            inside: BorderSide(color: colorScheme.outlineVariant),
          ),
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(9),
                ),
              ),
              children: headers
                  .map(
                    (header) => Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        header,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            for (final row in rows)
              TableRow(
                children: row
                    .map(
                      (cell) => Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(cell),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}
