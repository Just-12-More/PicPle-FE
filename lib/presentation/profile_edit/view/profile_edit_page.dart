import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:picple/presentation/component/picple_text_field.dart';
import 'package:picple/presentation/theme/picple_colors.dart';
import 'package:picple/presentation/theme/picple_typography.dart';

import '../provider/profile_edit_contract.dart';
import '../provider/profile_edit_notifier.dart';

class ProfileEditPage extends ConsumerStatefulWidget {
  const ProfileEditPage({super.key});

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final nickname = ref.read(profileEditStateProvider).nickname;
    _controller = TextEditingController(text: nickname);
    _controller.addListener(_handleNicknameChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleNicknameChange() {
    final currentNickname = ref.read(profileEditStateProvider).nickname;
    if (_controller.text == currentNickname) return;

    ref.read(profileEditStateProvider.notifier).setNickname(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String>(
      profileEditStateProvider.select((state) => state.nickname),
      (previous, next) {
        if (_controller.text == next) return;
        _controller.value = TextEditingValue(
          text: next,
          selection: TextSelection.collapsed(offset: next.length),
        );
      },
    );

    final isFetching = ref.watch(
      profileEditStateProvider.select((state) => state.isFetching),
    );
    final isSaving = ref.watch(
      profileEditStateProvider.select((state) => state.isSaving),
    );
    final nickname = ref.watch(
      profileEditStateProvider.select((state) => state.nickname),
    );
    final profileImageUrl = ref.watch(
      profileEditStateProvider.select((state) => state.profileImageUrl),
    );
    final imagePath = ref.watch(
      profileEditStateProvider.select((state) => state.imagePath),
    );

    ref.listen<ProfileEditEffect?>(profileEditEffectProvider, (previous, next) {
      if (next == null) return;
      switch (next) {
        case ShowToast():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.message)),
          );
          break;
        case NavigateBack():
          context.pop();
          break;
      }
      ref.read(profileEditEffectProvider.notifier).state = null;
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('프로필 수정', style: PicpleTypography.title1),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isFetching
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 32), // 키보드에 가려지지 않게
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 125,
                            backgroundImage: _buildAvatarImage(imagePath, profileImageUrl),
                            backgroundColor: Colors.grey[200],
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => ref.read(profileEditStateProvider.notifier).changeProfileImage(),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: const Icon(Icons.camera_alt, color: PicpleColors.gray5, size: 28),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '닉네임',
                            style: TextStyle(
                              color: PicpleColors.primary1,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        child: AppTextField(
                          controller: _controller,
                          hintText: '닉네임을 입력하세요',
                          hintStyle: const TextStyle(
                            color: PicpleColors.gray3,
                            fontSize: 18,
                          ),
                          enabled: !isSaving,
                          textColor: Colors.black,
                          borderColor: PicpleColors.gray2,
                          focusedBorderColor: PicpleColors.primary1,
                          enabledBorderColor: PicpleColors.gray2,
                          borderRadius: 12,
                          borderWidth: 1.0,
                          suffixIconAsset:
                              nickname.isNotEmpty
                                  ? 'assets/icons/ic_close.svg'
                                  : null,
                          onSuffixIconPressed:
                              () => ref
                                  .read(profileEditStateProvider.notifier)
                                  .setNickname(''),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: SizedBox(
            height: 48,
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: PicpleColors.primary1,
                disabledBackgroundColor: PicpleColors.gray4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed:
                  isSaving
                      ? null
                      : () => ref.read(profileEditStateProvider.notifier)
                              .saveChanges(),
              child: Text(
                '변경사항 저장',
                style: PicpleTypography.body1SemiBold.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ImageProvider _buildAvatarImage(String? imagePath, String? profileImageUrl) {
    if (imagePath != null && imagePath.isNotEmpty) {
      return FileImage(File(imagePath));
    }

    if (profileImageUrl != null && profileImageUrl.isNotEmpty) {
      return NetworkImage(profileImageUrl);
    }

    return const AssetImage('assets/images/img_profile_placeholder.png');
  }
}
