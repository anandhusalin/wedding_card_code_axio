import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_cards/src/features/auth/domain/user_model.dart';

void main() {
  group('User model', () {
    test('fromJson parses full user object', () {
      final json = {
        '_id': 'user-123',
        'email': 'test@example.com',
        'displayName': 'Test User',
        'avatarUrl': 'https://example.com/avatar.jpg',
        'plan': 'premium',
      };
      final user = User.fromJson(json);

      expect(user.id, 'user-123');
      expect(user.email, 'test@example.com');
      expect(user.displayName, 'Test User');
      expect(user.avatarUrl, 'https://example.com/avatar.jpg');
      expect(user.plan, 'premium');
    });

    test('fromJson - missing plan defaults to free', () {
      final json = {
        '_id': 'user-456',
        'email': 'user2@example.com',
        'displayName': 'User Two',
      };
      final user = User.fromJson(json);

      expect(user.plan, 'free');
    });

    test('fromJson - missing avatarUrl is null', () {
      final json = {
        '_id': 'user-789',
        'email': 'user3@example.com',
        'displayName': 'User Three',
      };
      final user = User.fromJson(json);

      expect(user.avatarUrl, null);
    });

    test('toJson includes all fields', () {
      const user = User(
        id: 'user-abc',
        email: 'abc@example.com',
        displayName: 'ABC User',
        plan: 'pro',
      );
      final json = user.toJson();

      expect(json['_id'], 'user-abc');
      expect(json['email'], 'abc@example.com');
      expect(json['displayName'], 'ABC User');
      expect(json['plan'], 'pro');
    });

    test('copyWith updates specific fields', () {
      const original = User(
        id: 'user-1',
        email: 'old@example.com',
        displayName: 'Old Name',
        plan: 'free',
      );

      final updated = original.copyWith(
        email: 'new@example.com',
        plan: 'premium',
      );

      expect(updated.id, 'user-1');
      expect(updated.email, 'new@example.com');
      expect(updated.displayName, 'Old Name');
      expect(updated.plan, 'premium');
    });

    test('equality based on all fields', () {
      const user1 = User(
        id: 'user-1',
        email: 'a@example.com',
        displayName: 'A',
        plan: 'free',
      );
      const user2 = User(
        id: 'user-1',
        email: 'a@example.com',
        displayName: 'A',
        plan: 'free',
      );
      const user3 = User(
        id: 'user-2',
        email: 'b@example.com',
        displayName: 'B',
        plan: 'free',
      );

      expect(user1, user2);
      expect(user1, isNot(user3));
    });
  });
}