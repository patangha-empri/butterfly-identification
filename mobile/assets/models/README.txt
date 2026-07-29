On-device butterfly classifier assets.

Place the two files produced by mobile/ml/train_butterfly_tflite.py here:

  butterfly_model.tflite   (input 1x224x224x3 float32 raw RGB 0-255, output 1xN softmax)
  labels.txt               (N lines, one species name per line, in output order)

Until these exist, on-device identification reports "model unavailable" and the
app falls back gracefully. This README keeps the assets/models/ directory valid
for the Flutter build.
