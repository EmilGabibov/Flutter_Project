import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../database/database.dart';
import '../theme/app_theme.dart';
import 'user_avatar.dart';

class AchievementSharePreview extends ConsumerStatefulWidget {
  final User user;
  final List<AchievementUnlock> achievements;

  const AchievementSharePreview({
    super.key,
    required this.user,
    required this.achievements,
  });

  @override
  ConsumerState<AchievementSharePreview> createState() =>
      _AchievementSharePreviewState();
}

class _AchievementSharePreviewState
    extends ConsumerState<AchievementSharePreview> {
  final GlobalKey _repaintBoundaryKey = GlobalKey();
  bool _isSharing = false;

  Future<void> _shareCard() async {
    if (_isSharing) return;
    setState(() {
      _isSharing = true;
    });

    try {
      final boundary = _repaintBoundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();

      if (pngBytes == null) return;

      if (!mounted) return;

      final box = context.findRenderObject() as RenderBox?;
      final offset = box?.localToGlobal(Offset.zero);
      final size = box?.size;
      Rect? rect;
      if (offset != null && size != null) {
        rect = offset & size;
      }

      if (kIsWeb) {
        final xFile = XFile.fromData(
          pngBytes,
          mimeType: 'image/png',
          name: 'hable_achievement.png',
        );
        await Share.shareXFiles(
          [xFile],
          text: 'Check out my progress on Hable! 🚀',
          sharePositionOrigin: rect,
        );
      } else {
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/hable_achievement.png');
        await file.writeAsBytes(pngBytes);
        
        await Share.shareXFiles(
          [XFile(file.path)],
          text: 'Check out my progress on Hable! 🚀',
          sharePositionOrigin: rect,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  String _achievementLabel(String id) {
    if (id == 'first_habit_completed') return 'First Habit';
    if (id == 'seven_day_streak') return '7 Day Streak';
    if (id == 'first_challenge_completed') return 'First Challenge';
    return id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Achievement'),
        actions: [
          if (_isSharing)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.ios_share_rounded),
              onPressed: _shareCard,
            ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: RepaintBoundary(
            key: _repaintBoundaryKey,
            child: Card(
              color: AppTheme.surface,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(
                  color: AppTheme.sageGreen.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Avatar and Name
                    UserAvatar(
                      avatarUrl: widget.user.avatarUrl,
                      username: widget.user.username,
                      radius: 40,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.user.username,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.deepCharcoal,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.sageGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.user.levelName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.sageGreen,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Score
                    Text(
                      '${widget.user.totalScore}',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: AppTheme.sageGreen,
                          ),
                    ),
                    Text(
                      'Total Points',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.warmGray,
                            letterSpacing: 1.2,
                          ),
                    ),
                    const SizedBox(height: 32),

                    // Badges
                    if (widget.achievements.isNotEmpty) ...[
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: widget.achievements
                            .take(4) // Show up to 4 recent badges
                            .map((a) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.completionGreen
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: AppTheme.completionGreen
                                          .withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Text(
                                    '🏆 ${_achievementLabel(a.achievementId)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.completionGreen,
                                        ),
                                  ),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 32),
                    ],

                    // Branding
                    const Divider(),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.eco_rounded,
                          color: AppTheme.sageGreen,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Hable',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.warmGray,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
