import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'skeletons.dart';

class AvatarPickerSheet extends ConsumerStatefulWidget {
  const AvatarPickerSheet({super.key});

  @override
  ConsumerState<AvatarPickerSheet> createState() => _AvatarPickerSheetState();
}

class _AvatarPickerSheetState extends ConsumerState<AvatarPickerSheet> {
  bool _isLoading = false;

  final List<String> characters = [
    '👾',
    '🤖',
    '👽',
    '👻',
    '👹',
    '👺',
    '💀',
    '💩',
    '🐱',
  ];

  final List<String> emojis = [
    '🤡',
    '🤪',
    '🤓',
    '😎',
    '🥸',
    '🤯',
    '🥶',
    '🥵',
    '🤢',
    '🤮',
    '🤠',
    '🥳',
    '🤫',
    '🤭',
    '🫢',
    '🫣',
    '🫠',
    '🫡',
    '🥴',
    '🤤',
  ];

  Future<void> _selectAvatar(String emoji) async {
    setState(() => _isLoading = true);
    final success = await ref.read(authProvider.notifier).updateAvatar(emoji);
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Avatar updated successfully')));
      Navigator.of(context).pop();
    } else {
      final error = ref.read(authProvider).error ?? 'Failed to update avatar';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        height: 400,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const Text(
              'Select Profile Picture',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const TabBar(
              labelColor: AppTheme.sageGreen,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppTheme.sageGreen,
              tabs: [
                Tab(text: 'Characters'),
                Tab(text: 'Emojis'),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? _buildLoadingGrid()
                  : TabBarView(
                      children: [_buildGrid(characters), _buildGrid(emojis)],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(List<String> items) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final emoji = items[index];
        return InkWell(
          onTap: () => _selectAvatar(emoji),
          borderRadius: BorderRadius.circular(50),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.sageGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 32)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        return const HableSkeletonCircle(size: 48);
      },
    );
  }
}
