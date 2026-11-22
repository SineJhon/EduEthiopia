import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

import '../../core/widgets/theme_toggle.dart';

class PdfReaderScreen extends StatefulWidget {
  const PdfReaderScreen({
    required this.title,
    required this.assetPath,
    super.key,
  });

  final String title;
  final String assetPath;

  @override
  State<PdfReaderScreen> createState() => _PdfReaderScreenState();
}

class _PdfReaderScreenState extends State<PdfReaderScreen> {
  static const _downloadChannel = MethodChannel(
    'com.example.eduethiopia/download',
  );

  late final PdfControllerPinch _controller;
  int _pageCount = 0;
  int _currentPage = 1;
  bool _downloading = false;

  @override
  void initState() {
    super.initState();
    _controller = PdfControllerPinch(
      document: PdfDocument.openAsset(widget.assetPath),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _downloadPdf() async {
    if (_downloading) return;
    setState(() => _downloading = true);

    try {
      final data = await rootBundle.load(widget.assetPath);
      final bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      final fileName =
          '${widget.title.replaceAll(RegExp(r'[<>:"/\\\\|?*]'), ' ').trim()}.pdf';

      String message;
      if (Platform.isAndroid) {
        await _downloadChannel.invokeMethod<void>('savePdf', {
          'fileName': fileName,
          'bytes': bytes,
        });
        message = 'Downloaded to device';
      } else {
        final directory =
            await getDownloadsDirectory() ??
            await getApplicationDocumentsDirectory();
        final file = File(
          '${directory.path}${Platform.pathSeparator}$fileName',
        );
        await file.writeAsBytes(bytes, flush: true);
        message = 'Downloaded to ${file.path}';
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not download this PDF')),
      );
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          const ThemeToggle(),
          IconButton(
            tooltip: 'Download PDF',
            onPressed: _downloading ? null : _downloadPdf,
            icon: _downloading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.download_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          PdfViewPinch(
            controller: _controller,
            scrollDirection: Axis.vertical,
            onDocumentLoaded: (document) {
              setState(() => _pageCount = document.pagesCount);
            },
            onPageChanged: (page) {
              setState(() => _currentPage = page);
            },
          ),
          if (_pageCount > 0)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withValues(alpha: 0.96),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: colorScheme.outlineVariant),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.10),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Previous page',
                        onPressed: _currentPage > 1
                            ? () => _controller.previousPage(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOut,
                              )
                            : null,
                        icon: const Icon(Icons.chevron_left_rounded),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '$_currentPage / $_pageCount',
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Next page',
                        onPressed: _currentPage < _pageCount
                            ? () => _controller.nextPage(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOut,
                              )
                            : null,
                        icon: const Icon(Icons.chevron_right_rounded),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
