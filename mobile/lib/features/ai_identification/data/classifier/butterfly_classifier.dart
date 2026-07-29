import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

/// A single class prediction from the on-device model.
class Classification {
  const Classification({required this.label, required this.confidence});

  /// Species name as written in labels.txt (output order).
  final String label;

  /// Softmax probability in [0, 1].
  final double confidence;
}

/// What the gate concluded about a set of predictions.
enum GateVerdict {
  /// Confidently a butterfly from the known label set.
  butterfly,

  /// Confidently one of the moth classes — not a butterfly.
  moth,

  /// The model could not confidently recognise a butterfly. This is the
  /// verdict for random objects (phones, faces, plants…): a closed-set
  /// classifier always outputs *some* label, so anything that doesn't pass
  /// the strict confidence checks must be treated as "not a butterfly".
  unrecognised,
}

/// ─────────────────────────────────────────────────────────────────────────────
/// BUTTERFLY GATE
/// The bundled TFLite model is a closed-set classifier: it has no "not a
/// butterfly" class and will happily label a phone as a moth. Every consumer
/// of on-device predictions MUST pass them through [evaluate] before showing
/// a species name to the user.
/// ─────────────────────────────────────────────────────────────────────────────
class ButterflyGate {
  ButterflyGate._();

  /// Top-1 softmax probability below which we refuse to claim a butterfly.
  /// Out-of-distribution photos (phones, people, backgrounds) routinely score
  /// 30–60% on a random class, so this must stay well above that band.
  static const double minConfidence = 0.70;

  /// The top prediction must beat the runner-up by this much. Garbage input
  /// produces a flat probability spread; real butterflies dominate.
  static const double minMargin = 0.25;

  /// True when a label from labels.txt is one of the moth classes.
  static bool isMothLabel(String label) =>
      label.toUpperCase().contains('MOTH');

  static GateVerdict evaluate(List<Classification> results) {
    if (results.isEmpty) return GateVerdict.unrecognised;
    final top = results.first;
    final runnerUp = results.length > 1 ? results[1].confidence : 0.0;

    final isConfident = top.confidence >= minConfidence &&
        (top.confidence - runnerUp) >= minMargin;
    if (!isConfident) return GateVerdict.unrecognised;

    return isMothLabel(top.label) ? GateVerdict.moth : GateVerdict.butterfly;
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
/// BUTTERFLY CLASSIFIER (on-device)
/// Runs a bundled TFLite model entirely on the phone — no network, no API quota.
/// Behind an interface so tests can stub it (the native runtime isn't available
/// on the Dart test VM).
/// ─────────────────────────────────────────────────────────────────────────────

abstract class IButterflyClassifier {
  /// True once the model + labels have loaded successfully.
  Future<bool> ensureLoaded();

  /// Top-[topK] predictions, highest confidence first. Throws
  /// [ClassifierUnavailable] if the model/labels couldn't be loaded.
  Future<List<Classification>> classify(File image, {int topK = 3});

  void dispose();
}

class ClassifierUnavailable implements Exception {
  ClassifierUnavailable([this.message = 'On-device model is not installed.']);
  final String message;
  @override
  String toString() => message;
}

class TFLiteButterflyClassifier implements IButterflyClassifier {
  TFLiteButterflyClassifier({
    this.modelAsset = 'assets/models/butterfly_model.tflite',
    this.labelsAsset = 'assets/models/labels.txt',
    this.inputSize = 224,
  });

  final String modelAsset;
  final String labelsAsset;
  final int inputSize;

  Interpreter? _interpreter;
  List<String> _labels = const [];
  bool _triedLoad = false;
  bool _loaded = false;

  @override
  Future<bool> ensureLoaded() async {
    if (_triedLoad) return _loaded;
    _triedLoad = true;
    try {
      _interpreter = await Interpreter.fromAsset(modelAsset);
      final raw = await rootBundle.loadString(labelsAsset);
      _labels = raw
          .split('\n')
          .map((l) => l.trim())
          .where((l) => l.isNotEmpty)
          .toList();
      _loaded = _interpreter != null && _labels.isNotEmpty;
    } catch (_) {
      _loaded = false;
    }
    return _loaded;
  }

  @override
  Future<List<Classification>> classify(File image, {int topK = 3}) async {
    if (!await ensureLoaded()) throw ClassifierUnavailable();
    final interpreter = _interpreter!;

    final input = _imageToInput(await image.readAsBytes());
    final output = [List<double>.filled(_labels.length, 0.0)];
    interpreter.run(input, output);

    final scores = output.first;
    final indices = List<int>.generate(scores.length, (i) => i)
      ..sort((a, b) => scores[b].compareTo(scores[a]));

    return [
      for (final i in indices.take(topK))
        Classification(label: _labels[i], confidence: scores[i]),
    ];
  }

  /// Decode → resize → build a [1, h, w, 3] float32 tensor of RAW RGB 0–255
  /// (the model graph does its own normalization).
  List<List<List<List<double>>>> _imageToInput(Uint8List bytes) {
    final decoded = img.decodeImage(bytes);
    if (decoded == null) throw ClassifierUnavailable('Could not read image.');
    final resized =
        img.copyResize(decoded, width: inputSize, height: inputSize);

    return [
      List.generate(inputSize, (y) {
        return List.generate(inputSize, (x) {
          final p = resized.getPixel(x, y);
          return [p.r.toDouble(), p.g.toDouble(), p.b.toDouble()];
        });
      }),
    ];
  }

  @override
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
  }
}
