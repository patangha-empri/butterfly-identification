import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// IMAGE HELPER
/// Compresses/resizes picked images before upload to keep payloads small.
/// Heavy decode/encode runs in a background isolate via [compute].
/// ─────────────────────────────────────────────────────────────────────────────

abstract class ImageHelper {
  static const int maxDimension = 1600;
  static const int jpegQuality = 82;

  /// Compresses [source] and writes the result to a temp file, returning it.
  /// Falls back to the original file if compression fails.
  static Future<File> compress(File source) async {
    try {
      final bytes = await source.readAsBytes();
      final compressed = await compute(_compressBytes, bytes);
      if (compressed == null) return source;

      final dir = await getTemporaryDirectory();
      final name = 'cmp_${DateTime.now().microsecondsSinceEpoch}_'
          '${p.basenameWithoutExtension(source.path)}.jpg';
      final out = File(p.join(dir.path, name));
      await out.writeAsBytes(compressed, flush: true);
      return out;
    } catch (_) {
      return source;
    }
  }

  /// Compresses many images, preserving order.
  static Future<List<File>> compressAll(List<File> sources) async {
    final results = <File>[];
    for (final s in sources) {
      results.add(await compress(s));
    }
    return results;
  }
}

/// Top-level isolate entry point: decode → resize → JPEG-encode.
Uint8List? _compressBytes(Uint8List bytes) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return null;

  img.Image resized = decoded;
  final longest =
      decoded.width > decoded.height ? decoded.width : decoded.height;
  if (longest > ImageHelper.maxDimension) {
    if (decoded.width >= decoded.height) {
      resized = img.copyResize(decoded, width: ImageHelper.maxDimension);
    } else {
      resized = img.copyResize(decoded, height: ImageHelper.maxDimension);
    }
  }

  return Uint8List.fromList(
    img.encodeJpg(resized, quality: ImageHelper.jpegQuality),
  );
}
