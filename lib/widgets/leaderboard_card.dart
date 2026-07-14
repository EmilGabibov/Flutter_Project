import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import 'user_avatar.dart';

class LeaderboardEntry {
  final String userId;
  final String userName;
  final String? avatarUrl;
  final String? levelName;
  final int rank;
  final int score;

  const LeaderboardEntry({
    required this.userId,
    required this.userName,
    required this.rank,
    required this.score,
    this.avatarUrl,
    this.levelName,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json, int rank) {
    return LeaderboardEntry(
      userId: _readString(json, 'id') ?? _readString(json, 'user_id') ?? '',
      userName: _readString(json, 'username') ?? '',
      avatarUrl: _readString(json, 'avatar_url'),
      levelName: _readString(json, 'level_name') ?? _readString(json, 'level'),
      rank: rank,
      score: _readInt(json, 'total_score'),
    );
  }

  String get scoreLabel => _formatNumber(score);

  String bylineLabel(AppLocalizations loc) {
    if (levelName != null && levelName!.trim().isNotEmpty) {
      return loc.profileFriendLevel(levelName!);
    }
    return loc.leaderboardLifetimeScoreByline;
  }

  static String? _readString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static int _readInt(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is int) return value;
    if (value is num) return value.round();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class LeaderboardCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String scopeLabel;
  final List<LeaderboardEntry> rankings;
  final String? currentUserId;
  final int defaultPageSize;

  const LeaderboardCard({
    super.key,
    this.title = 'Leaderboard',
    this.subtitle = 'Ranked by lifetime score',
    this.scopeLabel = 'Global',
    required this.rankings,
    this.currentUserId,
    this.defaultPageSize = 10,
  });

  @override
  State<LeaderboardCard> createState() => _LeaderboardCardState();
}

class _LeaderboardCardState extends State<LeaderboardCard> {
  late int _visibleCount;

  @override
  void initState() {
    super.initState();
    _visibleCount = widget.defaultPageSize;
  }

  @override
  void didUpdateWidget(covariant LeaderboardCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rankings.length != widget.rankings.length ||
        oldWidget.defaultPageSize != widget.defaultPageSize) {
      _visibleCount = widget.defaultPageSize;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final visibleRankings = widget.rankings.take(_visibleCount).toList();
    final podiumRankings = widget.rankings.take(3).toList();
    final hasMore = widget.rankings.length > visibleRankings.length;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.warmGray.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.deepCharcoal.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LeaderboardHeader(
            title: widget.title,
            subtitle: widget.subtitle,
            scopeLabel: widget.scopeLabel,
          ),
          const SizedBox(height: 22),
          _LeaderboardPodium(
            rankings: podiumRankings,
            currentUserId: widget.currentUserId,
          ),
          const SizedBox(height: 22),
          Text(
            loc.leaderboardRankingsTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppTheme.deepCharcoal,
            ),
          ),
          const SizedBox(height: 10),
          for (final entry in visibleRankings) ...[
            _RankingRow(
              entry: entry,
              isCurrentUser: entry.userId == widget.currentUserId,
            ),
            const SizedBox(height: 8),
          ],
          if (hasMore)
            Center(
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    _visibleCount = (_visibleCount + widget.defaultPageSize)
                        .clamp(0, widget.rankings.length);
                  });
                },
                icon: const Icon(Icons.expand_more_rounded),
                label: Text(
                  loc.leaderboardShowMore(
                    widget.rankings.length - visibleRankings.length,
                  ),
                ),
              ),
            )
          else if (widget.rankings.length > widget.defaultPageSize)
            Center(
              child: Text(
                loc.leaderboardShowingAll(widget.rankings.length),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.warmGray,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LeaderboardHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String scopeLabel;

  const _LeaderboardHeader({
    required this.title,
    required this.subtitle,
    required this.scopeLabel,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppTheme.deepCharcoal,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.warmGray,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppTheme.warmGray.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                scopeLabel == loc.socialLeaderboardScopeFriends
                    ? Icons.group_rounded
                    : Icons.public_rounded,
                size: 16,
                color: AppTheme.sageGreen,
              ),
              const SizedBox(width: 6),
              Text(
                scopeLabel,
                style: const TextStyle(
                  color: AppTheme.deepCharcoal,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LeaderboardPodium extends StatelessWidget {
  final List<LeaderboardEntry> rankings;
  final String? currentUserId;

  const _LeaderboardPodium({
    required this.rankings,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    if (rankings.isEmpty) return const SizedBox.shrink();

    final first = rankings.first;
    final second = rankings.length > 1 ? rankings[1] : null;
    final third = rankings.length > 2 ? rankings[2] : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: second == null
              ? const SizedBox.shrink()
              : _PodiumPlace(
                  entry: second,
                  height: 96,
                  avatarRadius: 23,
                  accent: const Color(0xFFB7B7B7),
                  isCurrentUser: second.userId == currentUserId,
                ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _PodiumPlace(
            entry: first,
            height: 124,
            avatarRadius: 29,
            accent: AppTheme.skipAmber,
            isCurrentUser: first.userId == currentUserId,
            emphasize: true,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: third == null
              ? const SizedBox.shrink()
              : _PodiumPlace(
                  entry: third,
                  height: 82,
                  avatarRadius: 21,
                  accent: const Color(0xFFB7794A),
                  isCurrentUser: third.userId == currentUserId,
                ),
        ),
      ],
    );
  }
}

class _PodiumPlace extends StatelessWidget {
  final LeaderboardEntry entry;
  final double height;
  final double avatarRadius;
  final Color accent;
  final bool isCurrentUser;
  final bool emphasize;

  const _PodiumPlace({
    required this.entry,
    required this.height,
    required this.avatarRadius,
    required this.accent,
    required this.isCurrentUser,
    this.emphasize = false,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final displayName = entry.userName.isEmpty
        ? loc.leaderboardUnknownUser
        : entry.userName;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: UserAvatar(
                avatarUrl: entry.avatarUrl,
                username: displayName,
                radius: avatarRadius,
                backgroundColor: accent.withValues(alpha: 0.16),
              ),
            ),
            Positioned(
              top: 0,
              child: _RankBadge(rank: entry.rank, color: accent, compact: true),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          displayName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppTheme.deepCharcoal,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: height,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: emphasize ? 0.24 : 0.16),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            border: Border.all(color: accent.withValues(alpha: 0.28)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                entry.rank == 1
                    ? Icons.emoji_events_rounded
                    : Icons.military_tech_rounded,
                color: accent,
                size: emphasize ? 28 : 24,
              ),
              const SizedBox(height: 6),
              FittedBox(
                child: Text(
                  entry.scoreLabel,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppTheme.deepCharcoal,
                  ),
                ),
              ),
              if (isCurrentUser) ...[
                const SizedBox(height: 4),
                Text(
                  loc.leaderboardYou,
                  style: TextStyle(
                    color: AppTheme.sageGreen,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RankingRow extends StatelessWidget {
  final LeaderboardEntry entry;
  final bool isCurrentUser;

  const _RankingRow({required this.entry, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final accent = _rankAccent(entry.rank);
    final displayName = entry.userName.isEmpty
        ? loc.leaderboardUnknownUser
        : entry.userName;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? AppTheme.sageGreen.withValues(alpha: 0.12)
            : AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrentUser
              ? AppTheme.sageGreen.withValues(alpha: 0.38)
              : AppTheme.warmGray.withValues(alpha: 0.14),
        ),
      ),
      child: Row(
        children: [
          _RankBadge(rank: entry.rank, color: accent),
          const SizedBox(width: 12),
          UserAvatar(
            avatarUrl: entry.avatarUrl,
            username: displayName,
            radius: 22,
            backgroundColor: accent.withValues(alpha: 0.12),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppTheme.deepCharcoal,
                            ),
                      ),
                    ),
                    if (isCurrentUser) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          loc.leaderboardYou,
                          style: TextStyle(
                            color: AppTheme.sageGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  entry.bylineLabel(loc),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.warmGray,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                entry.scoreLabel,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppTheme.deepCharcoal,
                ),
              ),
              Text(
                loc.leaderboardLifetime,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.warmGray,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RankBadge extends StatelessWidget {
  final int rank;
  final Color color;
  final bool compact;

  const _RankBadge({
    required this.rank,
    required this.color,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = compact ? 26.0 : 34.0;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.24),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        '#$rank',
        style: TextStyle(
          color: Colors.white,
          fontSize: compact ? 11 : 13,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

Color _rankAccent(int rank) {
  if (rank == 1) return AppTheme.skipAmber;
  if (rank == 2) return const Color(0xFFB7B7B7);
  if (rank == 3) return const Color(0xFFB7794A);
  return AppTheme.sageGreen;
}

String _formatNumber(int value) {
  final text = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    final remaining = text.length - i;
    buffer.write(text[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}
