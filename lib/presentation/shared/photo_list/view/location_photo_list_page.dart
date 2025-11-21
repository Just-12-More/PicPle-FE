import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/photo_list_by_location_provider.dart';
import '../provider/photo_list_contract.dart';
import 'photo_list_page.dart';

class LocationPhotoListPage extends StatelessWidget {
  final String location;

  const LocationPhotoListPage({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return LocationPhotoListScreen(location: location);
  }
}

class LocationPhotoListScreen extends ConsumerWidget {
  final String location;

  const LocationPhotoListScreen({super.key, required this.location});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(photoListByLocationStateProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(photoListByLocationStateProvider.notifier)
          .fetchPhotosByLocation(location);
    });

    ref.listen<PhotoListEffect?>(
      photoListByLocationEffectProvider,
      (previous, next) {
        if (next == null) return;

        if (next is ShowToast) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.message)),
          );
        }

        ref.read(photoListByLocationEffectProvider.notifier).state = null;
      },
    );

    return PhotoListScaffold(
      state: state,
      onToggleLike: (photoId) => ref
          .read(photoListByLocationStateProvider.notifier)
          .toggleLikePhoto(photoId),
      initialTitle: location,
    );
  }
}
