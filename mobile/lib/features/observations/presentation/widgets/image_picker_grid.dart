import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/theme/typography_tokens.dart';
import '../../../../core/utils/a11y.dart';
import '../../../../shared/widgets/overlays/app_bottom_sheet.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// IMAGE PICKER GRID
/// Multi-image picker (camera + gallery via image_picker). First image is the
/// primary. Long-press to remove.
/// ─────────────────────────────────────────────────────────────────────────────

class ImagePickerGrid extends StatelessWidget {
  const ImagePickerGrid({
    super.key,
    required this.images,
    required this.onChanged,
    this.maxImages = 5,
  });

  final List<File> images;
  final ValueChanged<List<File>> onChanged;
  final int maxImages;

  Future<void> _pick(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    try {
      if (source == ImageSource.gallery) {
        final picked = await picker.pickMultiImage(imageQuality: 95);
        if (picked.isEmpty) return;
        final files = picked.map((x) => File(x.path)).toList();
        onChanged([...images, ...files].take(maxImages).toList());
      } else {
        final picked =
            await picker.pickImage(source: source, imageQuality: 95);
        if (picked == null) return;
        onChanged([...images, File(picked.path)].take(maxImages).toList());
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not access photos.')),
        );
      }
    }
  }

  void _showSourceSheet(BuildContext context) {
    AppBottomSheet.show(
      context,
      title: 'Add photo',
      scrollable: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt_outlined),
            title: const Text('Take a photo'),
            onTap: () {
              // The sheet lives on the root navigator (AppBottomSheet).
              Navigator.of(context, rootNavigator: true).pop();
              _pick(context, ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text('Choose from gallery'),
            onTap: () {
              Navigator.of(context, rootNavigator: true).pop();
              _pick(context, ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  void _remove(int index) {
    final next = [...images]..removeAt(index);
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: SpaceTokens.sm,
      mainAxisSpacing: SpaceTokens.sm,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (var i = 0; i < images.length; i++)
          _Thumb(
            file: images[i],
            isPrimary: i == 0,
            onRemove: () => _remove(i),
          ),
        if (images.length < maxImages)
          _AddTile(
            label: images.isEmpty ? 'Add photo' : 'Add',
            onTap: () => _showSourceSheet(context),
          ),
      ],
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({
    required this.file,
    required this.isPrimary,
    required this.onRemove,
  });

  final File file;
  final bool isPrimary;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(RadiusTokens.md),
          child: Image.file(file, fit: BoxFit.cover),
        ),
        if (isPrimary)
          Positioned(
            left: 4,
            bottom: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: ColorTokens.brandPrimary,
                borderRadius: RadiusTokens.pillBR,
              ),
              child: Text('Primary',
                  style: TypographyTokens.rarityLabel
                      .copyWith(color: Colors.white, fontSize: 8)),
            ),
          ),
        Positioned(
          top: 2,
          right: 2,
          child: Material(
            color: Colors.black54,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                Haptics.selection();
                onRemove();
              },
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.close, size: 14, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AddTile extends StatelessWidget {
  const _AddTile({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(RadiusTokens.md),
      child: DottedBorderBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_a_photo_outlined,
                color: ColorTokens.brandPrimary),
            const SizedBox(height: SpaceTokens.xs),
            Text(label,
                style: TypographyTokens.textTheme.labelSmall
                    ?.copyWith(color: ColorTokens.brandPrimary)),
          ],
        ),
      ),
    );
  }
}

class DottedBorderBox extends StatelessWidget {
  const DottedBorderBox({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorTokens.brandPrimary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(RadiusTokens.md),
        border: Border.all(
          color: ColorTokens.brandPrimary.withValues(alpha: 0.4),
        ),
      ),
      child: child,
    );
  }
}
