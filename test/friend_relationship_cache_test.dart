import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/database/database.dart';

void main() {
  test('friend relationship cache tracks pending and accepted state', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await db.cacheFriendRelationship(
      userId: 'friend-1',
      username: 'Bob',
      relationshipState: 'pending_incoming',
      requestId: 'request-1',
    );

    final pending = await db.watchPendingIncomingFriendRelationships().first;
    expect(pending, hasLength(1));
    expect(pending.single.userId, 'friend-1');
    expect(pending.single.requestId, 'request-1');

    await db.cacheFriendRelationship(
      userId: 'friend-1',
      username: 'Bob',
      relationshipState: 'accepted',
    );

    final acceptedClearsPending =
        await db.watchPendingIncomingFriendRelationships().first;
    expect(acceptedClearsPending, isEmpty);
  });

  test('friend relationship refresh can clear stale pending requests', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await db.cacheFriendRelationship(
      userId: 'friend-1',
      username: 'Bob',
      relationshipState: 'pending_incoming',
      requestId: 'request-1',
    );

    await db.clearPendingIncomingFriendRelationships();

    final pending = await db.watchPendingIncomingFriendRelationships().first;
    expect(pending, isEmpty);
  });
}
