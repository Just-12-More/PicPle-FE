import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:picple/presentation/theme/picple_colors.dart';
import 'package:picple/presentation/theme/picple_typography.dart';
import '../provider/profile_edit_notifier.dart';
import '../provider/profile_edit_contract.dart';
import 'package:picple/presentation/component/picple_text_field.dart';

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
    _controller.addListener(() {
      if (_controller.text != ref.read(profileEditStateProvider).nickname) {
        ref.read(profileEditStateProvider.notifier).setNickname(_controller.text);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileEditStateProvider);

    if (_controller.text != state.nickname) {
      _controller.text = state.nickname;
      _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
    }

    ref.listen<ProfileEditEffect?>(profileEditEffectProvider, (previous, next) {
      if (next == null) return;
      switch (next) {
        case ShowToast():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.message)),
          );
          break;
        case NavigateTo():
          context.push(next.route);
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
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: state.isLoading
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
                            backgroundImage: state.imagePath != null ?
                            FileImage(File(state.imagePath!)) :
                            state.profileImageUrl != null ?
                            NetworkImage(state.profileImageUrl!) :
                            const AssetImage('assets/images/default_profile.png'),
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
                          enabled: !state.isLoading,
                          textColor: Colors.black,
                          borderColor: PicpleColors.gray2,
                          focusedBorderColor: PicpleColors.primary1,
                          enabledBorderColor: PicpleColors.gray2,
                          borderRadius: 12,
                          borderWidth: 1.0,
                          suffixIconAsset:
                              state.nickname.isNotEmpty
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
                  state.isLoading
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
}
