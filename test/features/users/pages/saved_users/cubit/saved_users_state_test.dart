import 'package:flutter_test/flutter_test.dart';
import 'package:tddboilerplate/features/features.dart';

void main() {
  group('SavedUsersX', () {
    late List<UserEntity> users;

    setUp(() {
      users = [
        const UserEntity(
          name: "George Bluth",
          avatar: "https://reqres.in/img/faces/1-image.jpg",
          email: "george.bluth@reqres.in",
        ),
        const UserEntity(
          name: "Janet Weaver",
          avatar: "https://reqres.in/img/faces/2-image.jpg",
          email: "janet.weaver@reqres.in",
        ),
      ];
    });

    test('returns correct values for SavedUsers.loading', () {
      const status = SavedUsersState.loading();
      expect(status, const SavedUsersState.loading());
    });

    test('returns correct values for SavedUsers.success', () {
      final status = SavedUsersState.success(users, "Success get data");
      expect(status, SavedUsersState.success(users, "Success get data"));
    });

    test('returns correct values for SavedUsers.failure', () {
      const status = SavedUsersState.failure("");
      expect(status, const SavedUsersState.failure(""));
    });
    test('returns correct values for SavedUsers.empty', () {
      const status = SavedUsersState.empty();
      expect(status, const SavedUsersState.empty());
    });
  });
}
