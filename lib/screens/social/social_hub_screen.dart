import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import 'package:flutter/foundation.dart';
import '../../widgets/3d/habit_environment_visualizer.dart';
import '../../providers/social_providers.dart';
import '../../database/database.dart';
import '../../providers/database_provider.dart';
import 'package:drift/drift.dart' hide Column;
import '../../widgets/user_avatar.dart';

// --- API Providers ---
const _baseUrl = kDebugMode
    ? 'http://127.0.0.1:8787'
    : 'https://hable.pages.dev';

final leaderboardProvider = FutureProvider.autoDispose<List<dynamic>>((
  ref,
) async {
  final auth = ref.watch(authProvider);
  if (auth.token == null) return [];

  final response = await http.get(
    Uri.parse('$_baseUrl/api/social/leaderboard'),
    headers: {'Authorization': 'Bearer ${auth.token}'},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['leaderboard'] ?? [];
  }
  throw Exception('Failed to fetch leaderboard');
});

final userSearchProvider = FutureProvider.family
    .autoDispose<List<dynamic>, String>((ref, query) async {
      debugPrint('SEARCHING FOR: "$query"');
      if (query.length < 2) return [];

      final auth = ref.watch(authProvider);
      if (auth.token == null) return [];

      final url = '$_baseUrl/api/social/search?q=$query';
      debugPrint('GET $url');
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer ${auth.token}'},
      );

      debugPrint('RESPONSE ${response.statusCode}: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['results'] ?? [];
      }
      throw Exception('Failed to search users: ${response.body}');
    });

final pendingFriendRequestsProvider = FutureProvider.autoDispose<List<dynamic>>(
  (ref) async {
    final auth = ref.watch(authProvider);
    if (auth.token == null) return [];

    final response = await http.get(
      Uri.parse('$_baseUrl/api/social/friend-request'),
      headers: {'Authorization': 'Bearer ${auth.token}'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['friend_requests'] ?? [];
    }
    throw Exception('Failed to fetch friend requests');
  },
);

// --- UI ---
class SocialHubScreen extends ConsumerStatefulWidget {
  const SocialHubScreen({super.key});

  @override
  ConsumerState<SocialHubScreen> createState() => _SocialHubScreenState();
}

class _SocialHubScreenState extends ConsumerState<SocialHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _sendFriendRequest(String targetUserId, String username) async {
    final auth = ref.read(authProvider);
    if (auth.token == null) return;

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/social/friend-request'),
        headers: {
          'Authorization': 'Bearer ${auth.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'target_user_id': targetUserId}),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Friend request sent to $username!')),
          );
        }
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to send request: $e')));
      }
    }
  }

  Future<void> _acceptFriendRequest(Map<String, dynamic> req) async {
    final requestId = req['id'];
    final requesterId = req['requester_id'];
    final username = req['requester_username'] ?? 'Unknown';
    final avatarUrl = req['requester_avatar'];

    final auth = ref.read(authProvider);
    if (auth.token == null) return;
    final messenger = ScaffoldMessenger.maybeOf(context);

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/social/friend-request/accept'),
        headers: {
          'Authorization': 'Bearer ${auth.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'request_id': requestId}),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          final db = ref.read(databaseProvider);
          await db.upsertAcceptedFriend(
            AcceptedFriendsCompanion(
              friendUserId: Value(requesterId.toString()),
              username: Value(username),
              avatarUrl: Value(avatarUrl?.toString()),
              updatedAt: Value(DateTime.now()),
              isSynced: const Value(true),
            ),
          );

          messenger?.showSnackBar(
            SnackBar(content: Text('You are now friends with $username!')),
          );
          ref.invalidate(pendingFriendRequestsProvider);
        }
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to accept request: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Hub'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.favorite_rounded), text: 'Friends'),
            Tab(icon: Icon(Icons.people_alt_rounded), text: 'Requests'),
            Tab(icon: Icon(Icons.leaderboard_rounded), text: 'Leaderboard'),
            Tab(icon: Icon(Icons.search_rounded), text: 'Find Friends'),
            Tab(icon: Icon(Icons.mail_rounded), text: 'Inbox'),
          ],
          labelColor: AppTheme.sageGreen,
          indicatorColor: AppTheme.sageGreen,
        ),
      ),
      body: Column(
        children: [
          // 3D Environment Header
          const HabitEnvironmentVisualizer(height: 250),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFriendsTab(),
                _buildRequestsTab(),
                _buildLeaderboardTab(),
                _buildSearchTab(),
                _buildInboxTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendsTab() {
    final friendsAsync = ref.watch(acceptedFriendsProvider);

    return friendsAsync.when(
      data: (friends) {
        if (friends.isEmpty) {
          return const Center(child: Text('No friends yet. Search and add some!'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: friends.length,
          itemBuilder: (context, index) {
            final friend = friends[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: UserAvatar(
                  avatarUrl: friend.avatarUrl,
                  username: friend.username,
                  radius: 20,
                ),
                title: Text(
                  friend.username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildInboxTab() {
    final messagesAsync = ref.watch(privateMessagesProvider);

    return messagesAsync.when(
      data: (messages) {
        if (messages.isEmpty) {
          return const Center(child: Text('No private messages.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final msg = messages[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.sageGreen.withValues(alpha: 0.2),
                  child: const Icon(Icons.mail, color: AppTheme.sageGreen),
                ),
                title: Text(
                  'From User ${msg.senderId}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(msg.message),
                trailing: Text(
                  msg.milestoneType ?? '',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildRequestsTab() {
    final requestsAsync = ref.watch(pendingFriendRequestsProvider);

    return requestsAsync.when(
      data: (requests) {
        if (requests.isEmpty) {
          return const Center(child: Text('No pending friend requests.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final req = requests[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: UserAvatar(
                  avatarUrl: req['requester_avatar']?.toString(),
                  username: req['requester_username']?.toString(),
                  radius: 20,
                ),
                title: Text(
                  req['requester_username'] ?? 'Unknown',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Sent you a friend request'),
                trailing: ElevatedButton(
                  onPressed: () => _acceptFriendRequest(req),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.sageGreen,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Accept'),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildLeaderboardTab() {
    final leaderboardAsync = ref.watch(leaderboardProvider);

    return leaderboardAsync.when(
      data: (users) {
        if (users.isEmpty) {
          return const Center(child: Text('No users found.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final rank = index + 1;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: UserAvatar(
                  avatarUrl: user['avatar_url']?.toString(),
                  username: user['username']?.toString() ?? '$rank',
                  radius: 20,
                ),
                title: Text(
                  user['username'] ?? 'Unknown',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Score: ${user['total_score'] ?? 0}'),
                trailing: rank <= 3
                    ? Icon(
                        Icons.star_rounded,
                        color: rank == 1
                            ? Colors.amber
                            : rank == 2
                            ? Colors.grey[400]
                            : Colors.brown,
                      )
                    : Text('#$rank'),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildSearchTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Search username...',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value.trim();
              });
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _searchQuery.length < 2
                ? const Center(
                    child: Text('Type at least 2 characters to search.'),
                  )
                : Consumer(
                    builder: (context, ref, _) {
                      final searchAsync = ref.watch(
                        userSearchProvider(_searchQuery),
                      );
                      return searchAsync.when(
                        data: (results) {
                          if (results.isEmpty) {
                            return const Center(
                              child: Text('No matches found.'),
                            );
                          }
                          return ListView.builder(
                            itemCount: results.length,
                            itemBuilder: (context, index) {
                              final user = results[index];
                              return ListTile(
                                leading: UserAvatar(
                                  avatarUrl: user['avatar_url']?.toString(),
                                  username: user['username']?.toString(),
                                  radius: 20,
                                ),
                                title: Text(user['username']),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.person_add_rounded,
                                    color: AppTheme.sageGreen,
                                  ),
                                  onPressed: () => _sendFriendRequest(
                                    user['id'],
                                    user['username'],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (e, st) => Center(child: Text('Error: $e')),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
