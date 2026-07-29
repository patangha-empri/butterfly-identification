"""
═══════════════════════════════════════════════════════════════════════════════
 BUTTERFLY CLASSIFIER — TFLite training script (run in Google Colab, free GPU)
═══════════════════════════════════════════════════════════════════════════════

WHAT THIS PRODUCES
  - butterfly_model.tflite   input  : 1 x 224 x 224 x 3  float32, RAW RGB 0–255
                             output : 1 x N              softmax probabilities
                             (ALL preprocessing is baked into the graph, so the
                              Flutter app just feeds raw pixels — it can't get
                              normalization wrong.)
  - labels.txt               N lines, one species name per line, in output order.

Drop BOTH files into:  mobile/assets/models/

───────────────────────────────────────────────────────────────────────────────
HOW TO RUN (≈30–45 min, completely free)
  1. Open https://colab.research.google.com  → New notebook.
  2. Runtime ▸ Change runtime type ▸ Hardware accelerator = GPU (T4). Save.
  3. Get a Kaggle API token: kaggle.com ▸ Account ▸ "Create New API Token"
     → downloads kaggle.json.
  4. Paste this whole file into ONE Colab cell and run it. When prompted, upload
     kaggle.json.
  5. When it finishes, the Files panel (left) will have butterfly_model.tflite and
     labels.txt — download both.

You can swap DATASET for any Kaggle dataset whose images are laid out as
  <root>/<split>/<class_name>/*.jpg
The script auto-detects the train/validation folders.
───────────────────────────────────────────────────────────────────────────────
"""

# ── 0. Config ──────────────────────────────────────────────────────────────────
# Popular, free, well-labelled options (pick one slug):
#   "phucthaiv02/butterfly-image-classification"            (~75 classes)
#   "gpiosenka/butterfly-images40-species"                  (~100 classes)
DATASET = "gpiosenka/butterfly-images40-species"
IMG_SIZE = 224
BATCH = 32
EPOCHS_HEAD = 8        # train new classifier head
EPOCHS_FINETUNE = 5    # then fine-tune top of the backbone
SEED = 1337

# ── 1. Install + Kaggle auth ─────────────────────────────────────────────────────
import os, subprocess, sys, glob, json, pathlib

def _sh(cmd): subprocess.run(cmd, shell=True, check=True)

try:
    import kaggle  # noqa
except Exception:
    _sh("pip -q install kaggle")

# Upload kaggle.json once (Colab only).
if not os.path.exists("/root/.kaggle/kaggle.json"):
    try:
        from google.colab import files  # type: ignore
        print("Upload your kaggle.json …")
        files.upload()
        os.makedirs("/root/.kaggle", exist_ok=True)
        _sh("cp kaggle.json /root/.kaggle/kaggle.json && chmod 600 /root/.kaggle/kaggle.json")
    except Exception:
        print("Not on Colab — make sure ~/.kaggle/kaggle.json exists.")

# ── 2. Download + unzip dataset ──────────────────────────────────────────────────
DATA_DIR = "/content/butterfly_data"
if not os.path.isdir(DATA_DIR):
    os.makedirs(DATA_DIR, exist_ok=True)
    _sh(f"kaggle datasets download -d {DATASET} -p {DATA_DIR} --unzip")

# Auto-detect train/valid directories (a dir whose children are class folders).
def _find_split(name_options):
    for opt in name_options:
        hits = glob.glob(f"{DATA_DIR}/**/{opt}", recursive=True)
        for h in hits:
            if os.path.isdir(h) and any(os.path.isdir(os.path.join(h, c))
                                        for c in os.listdir(h)):
                return h
    return None

train_dir = _find_split(["train", "Train", "training"])
valid_dir = _find_split(["valid", "validation", "Valid", "test", "Test"])
assert train_dir, "Could not find a train folder of class subdirectories."
print("train:", train_dir, "\nvalid:", valid_dir)

# ── 3. Datasets ──────────────────────────────────────────────────────────────────
import tensorflow as tf

train_ds = tf.keras.utils.image_dataset_from_directory(
    train_dir, image_size=(IMG_SIZE, IMG_SIZE), batch_size=BATCH,
    label_mode="categorical", shuffle=True, seed=SEED)
class_names = train_ds.class_names
NUM_CLASSES = len(class_names)
print("classes:", NUM_CLASSES)

if valid_dir:
    val_ds = tf.keras.utils.image_dataset_from_directory(
        valid_dir, image_size=(IMG_SIZE, IMG_SIZE), batch_size=BATCH,
        label_mode="categorical", shuffle=False)
else:
    # carve 15% off train for validation
    val_batches = max(1, int(0.15 * tf.data.experimental.cardinality(train_ds).numpy()))
    val_ds = train_ds.take(val_batches)
    train_ds = train_ds.skip(val_batches)

AUTOTUNE = tf.data.AUTOTUNE
train_ds = train_ds.prefetch(AUTOTUNE)
val_ds = val_ds.prefetch(AUTOTUNE)

# ── 4. Model — preprocessing BAKED IN (input = raw RGB 0–255) ────────────────────
from tensorflow.keras import layers, Model
from tensorflow.keras.applications import MobileNetV2
from tensorflow.keras.applications.mobilenet_v2 import preprocess_input

inputs = layers.Input(shape=(IMG_SIZE, IMG_SIZE, 3), name="image")  # raw 0–255
aug = tf.keras.Sequential([
    layers.RandomFlip("horizontal"),
    layers.RandomRotation(0.1),
    layers.RandomZoom(0.1),
], name="augment")
x = aug(inputs)
x = layers.Lambda(preprocess_input, name="preprocess")(x)  # → [-1, 1] for MobileNetV2
base = MobileNetV2(include_top=False, weights="imagenet",
                   input_shape=(IMG_SIZE, IMG_SIZE, 3), pooling="avg")
base.trainable = False
x = base(x, training=False)
x = layers.Dropout(0.2)(x)
outputs = layers.Dense(NUM_CLASSES, activation="softmax", name="probs")(x)
model = Model(inputs, outputs)

model.compile(optimizer=tf.keras.optimizers.Adam(1e-3),
              loss="categorical_crossentropy", metrics=["accuracy"])
model.fit(train_ds, validation_data=val_ds, epochs=EPOCHS_HEAD)

# ── 5. Fine-tune the top of the backbone ─────────────────────────────────────────
base.trainable = True
for layer in base.layers[:-30]:
    layer.trainable = False
model.compile(optimizer=tf.keras.optimizers.Adam(1e-5),
              loss="categorical_crossentropy", metrics=["accuracy"])
model.fit(train_ds, validation_data=val_ds, epochs=EPOCHS_FINETUNE)

# ── 6. Export TFLite (float16 → smaller, still float input) ──────────────────────
# Build an inference-only model WITHOUT the augmentation layers.
infer_in = layers.Input(shape=(IMG_SIZE, IMG_SIZE, 3), name="image")
y = layers.Lambda(preprocess_input, name="preprocess")(infer_in)
y = base(y, training=False)
y = model.get_layer("probs")(y)
infer_model = Model(infer_in, y)

converter = tf.lite.TFLiteConverter.from_keras_model(infer_model)
converter.optimizations = [tf.lite.Optimize.DEFAULT]
converter.target_spec.supported_types = [tf.float16]
tflite = converter.convert()

with open("butterfly_model.tflite", "wb") as f:
    f.write(tflite)
with open("labels.txt", "w") as f:
    f.write("\n".join(class_names))

print(f"\n✅ Done. {NUM_CLASSES} classes. "
      f"Model size: {len(tflite)/1e6:.1f} MB")
print("Download butterfly_model.tflite + labels.txt and put them in "
      "mobile/assets/models/")
