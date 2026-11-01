import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:share_plus/share_plus.dart';

import 'widgets.dart';

void openDocument(BuildContext context, String title, String asset) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => DocumentScreen(title: title, asset: asset),
    ),
  );
}

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key, required this.title, required this.asset});
  final String title, asset;
  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  bool sharing = false;
  Future<void> share(BuildContext buttonContext) async {
    final box = buttonContext.findRenderObject() as RenderBox?;
    final origin = box == null
        ? null
        : box.localToGlobal(Offset.zero) & box.size;
    setState(() => sharing = true);
    try {
      final bytes = await rootBundle.load(widget.asset);
      final pdf = widget.asset.toLowerCase().endsWith('.pdf');
      final extension = widget.asset.split('.').last.toLowerCase();
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(
              bytes.buffer.asUint8List(
                bytes.offsetInBytes,
                bytes.lengthInBytes,
              ),
              mimeType: pdf
                  ? 'application/pdf'
                  : extension == 'png'
                  ? 'image/png'
                  : extension == 'webp'
                  ? 'image/webp'
                  : 'image/jpeg',
            ),
          ],
          fileNameOverrides: [widget.asset.split('/').last],
          subject: widget.title,
          sharePositionOrigin: origin,
        ),
      );
    } catch (_) {
      if (mounted) {
        notice(context, 'Could not share this document. Please try again.');
      }
    } finally {
      if (mounted) setState(() => sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.title),
      actions: [
        Builder(
          builder: (buttonContext) => IconButton(
            tooltip: 'Share or save document',
            onPressed: sharing ? null : () => share(buttonContext),
            icon: sharing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.ios_share),
          ),
        ),
      ],
    ),
    body: SafeArea(
      child: widget.asset.toLowerCase().endsWith('.pdf')
          ? PdfViewer.asset(widget.asset)
          : InteractiveViewer(
              minScale: .5,
              maxScale: 5,
              child: Center(
                child: PortfolioImage(
                  widget.asset,
                  fit: BoxFit.contain,
                  label: widget.title,
                ),
              ),
            ),
    ),
  );
}
