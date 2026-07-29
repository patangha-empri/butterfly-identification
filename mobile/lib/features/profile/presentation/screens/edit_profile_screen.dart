import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/theme/typography_tokens.dart';
import '../../../../shared/widgets/buttons/app_button.dart';
import '../../../../shared/widgets/inputs/app_text_field.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_providers.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// EDIT PROFILE SCREEN (/profile/edit)
/// ─────────────────────────────────────────────────────────────────────────────

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _name;
  late final TextEditingController _username;
  late final TextEditingController _bio;
  bool _uploadingAvatar = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    _name = TextEditingController(text: user?.fullName ?? '');
    _username = TextEditingController(text: user?.username ?? '');
    _bio = TextEditingController(text: user?.bio ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _username.dispose();
    _bio.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    final ok = await ref.read(editProfileNotifierProvider.notifier).save(
          fullName: _name.text.trim(),
          username: _username.text.trim(),
          bio: _bio.text.trim(),
        );
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated.')),
      );
      context.pop();
    }
  }

  Future<void> _pickAvatar() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;

    final picked =
        await ImagePicker().pickImage(source: source, imageQuality: 90);
    if (picked == null) return;

    setState(() => _uploadingAvatar = true);
    final ok = await ref
        .read(editProfileNotifierProvider.notifier)
        .uploadAvatar(File(picked.path));
    if (!mounted) return;
    setState(() => _uploadingAvatar = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? 'Avatar updated.' : 'Could not update avatar.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editProfileNotifierProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit profile')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          SpaceTokens.lg,
          SpaceTokens.lg,
          SpaceTokens.lg,
          SpaceTokens.lg + MediaQuery.viewPaddingOf(context).bottom,
        ),
        children: [
          Center(child: _AvatarEditor(
            avatarUrl: user?.profileImageUrl,
            initials: user?.initials ?? '',
            uploading: _uploadingAvatar,
            onTap: _uploadingAvatar ? null : _pickAvatar,
          )),
          const SizedBox(height: SpaceTokens.xl),
          AppTextField(
            label: 'Full name',
            controller: _name,
            textInputAction: TextInputAction.next,
            errorText: state.fieldErrors['fullName'],
          ),
          const SizedBox(height: SpaceTokens.base),
          AppTextField(
            label: 'Username',
            controller: _username,
            prefixIcon: Icons.alternate_email,
            textInputAction: TextInputAction.next,
            errorText: state.fieldErrors['username'],
          ),
          const SizedBox(height: SpaceTokens.base),
          AppTextField(
            label: 'Bio',
            controller: _bio,
            maxLines: 4,
            maxLength: 500,
            hint: 'Tell the community about yourself',
          ),
          if (state.status == EditStatus.error &&
              state.fieldErrors.isEmpty &&
              state.error != null) ...[
            const SizedBox(height: SpaceTokens.sm),
            Text(state.error!,
                style: TypographyTokens.textTheme.bodySmall
                    ?.copyWith(color: ColorTokens.error)),
          ],
          const SizedBox(height: SpaceTokens.xl),
          AppButton(
            label: 'Save changes',
            onPressed: state.isSaving ? null : _save,
            isLoading: state.isSaving,
          ),
        ],
      ),
    );
  }
}

class _AvatarEditor extends StatelessWidget {
  const _AvatarEditor({
    required this.avatarUrl,
    required this.initials,
    required this.uploading,
    required this.onTap,
  });
  final String? avatarUrl;
  final String initials;
  final bool uploading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 52,
            backgroundColor: ColorTokens.brandPrimary.withValues(alpha: 0.15),
            backgroundImage: (avatarUrl != null && avatarUrl!.isNotEmpty)
                ? CachedNetworkImageProvider(
                    avatarUrl!,
                    maxWidth: (104 *
                            (MediaQuery.maybeOf(context)?.devicePixelRatio ?? 2.0))
                        .round(),
                  )
                : null,
            child: uploading
                ? const CircularProgressIndicator()
                : (avatarUrl == null || avatarUrl!.isEmpty)
                    ? Text(initials,
                        style: TypographyTokens.textTheme.headlineMedium
                            ?.copyWith(color: ColorTokens.brandPrimary))
                    : null,
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: ColorTokens.brandPrimary,
              shape: BoxShape.circle,
              border: Border.all(color: Theme.of(context).colorScheme.surface, width: 2),
            ),
            child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
