import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

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

  MethodChannel? _readerChannel;
  String? _filePath;
  int _pageCount = 0;
  int _currentPage = 1;
  bool _downloading = false;
  bool _preparing = true;

  @override
  void initState() {
    super.initState();
    _preparePdf();
  }

  Future<void> _preparePdf() async {
    try {
      final data = await rootBundle.load(widget.assetPath);
      final bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      final directory = Platform.isAndroid
          ? await getApplicationCacheDirectory()
          : await getApplicationSupportDirectory();
      final fileName =
          '${widget.title.replaceAll(RegExp(r'[<>:"/\\\\|?*]'), ' ').trim()}.pdf';
      final file = File('${directory.path}${Platform.pathSeparator}$fileName');
      await file.writeAsBytes(bytes, flush: true);
      if (!mounted) return;
      setState(() {
        _filePath = file.path;
        _preparing = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _preparing = false);
    }
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

      if (Platform.isAndroid) {
        await _downloadChannel.invokeMethod<void>('savePdf', {
          'fileName': fileName,
          'bytes': bytes,
        });
      } else if (Platform.isIOS) {
        await _downloadChannel.invokeMethod<void>('savePdf', {
          'fileName': fileName,
          'bytes': bytes,
        });
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Downloaded to device')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not download this PDF')),
      );
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  void _onPlatformViewCreated(int viewId) {
    _readerChannel = MethodChannel(
      'com.example.eduethiopia/pdf_viewer/$viewId',
    );
    _readerChannel?.setMethodCallHandler((call) async {
      if (!mounted) return;
      if (call.method == 'documentLoaded') {
        setState(() => _pageCount = call.arguments['pageCount'] as int);
      } else if (call.method == 'pageChanged') {
        setState(() => _currentPage = call.arguments['pageNumber'] as int);
      }
    });
  }

  Future<void> _previousPage() async {
    await _readerChannel?.invokeMethod('previousPage');
  }

  Future<void> _nextPage() async {
    await _readerChannel?.invokeMethod('nextPage');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final nativeSupported = Platform.isAndroid || Platform.isIOS;

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
            icon: _downloadingIcon,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          if (_preparing)
            const Center(child: CircularProgressIndicator())
          else if (!nativeSupported)
            const Center(
              child: Text('Native PDF reading is available on mobile devices'),
            )
          else if (_filePath == null)
            const Center(child: Text('Could not prepare this PDF'))
          else
            Platform.isAndroid
                ? AndroidView(
                    viewType: 'eduethiopia/pdf_viewer',
                    onPlatformViewCreated: _onPlatformViewCreated,
                    creationParams: {'filePath': _filePath},
                    creationParamsCodec: const StandardMessageCodec(),
                  )
                : UiKitView(
                    viewType: 'eduethiopia/pdf_viewer',
                    onPlatformViewCreated: _onPlatformViewCreated,
                    creationParams: {'filePath': _filePath},
                    creationParamsCodec: const StandardMessageCodec(),
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
                        onPressed: _currentPage > 1 ? _previousPage : null,
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
                        onPressed: _currentPage < _pageCount ? _nextPage : null,
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

  Widget get _downloadingIcon => _downloading
      ? const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        )
      : const Icon(Icons.download_rounded);
}
