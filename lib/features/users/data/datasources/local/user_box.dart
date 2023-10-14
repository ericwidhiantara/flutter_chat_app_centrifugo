import 'package:hive_flutter/hive_flutter.dart';
import 'package:tdd_boilerplate/features/features.dart';
import 'package:tdd_boilerplate/utils/utils.dart';

mixin class UserBoxMixin {
  static late Box? mainBox;
  static const _boxName = 'user_box';

  static Future<void> initHive(String prefixBox) async {
    // Initialize hive (persistent database)
    await Hive.initFlutter();
    Hive.registerAdapter(UserEntityAdapter());
    mainBox = await Hive.openBox<UserEntity>("$prefixBox$_boxName");
  }

  Future<void> addData(UserEntity value) async {
    final data = getAllData();

    if (data.contains(value)) {
      await mainBox?.deleteAt(data.indexOf(value));
    } else {
      await mainBox?.add(value);
    }
  }

  Future<void> removeData(UserEntity value) async {
    final data = getAllData();
    if (data.contains(value)) {
      await mainBox?.deleteAt(data.indexOf(value));
    }
  }

  Future<void> clearData() async {
    final data = getAllData();
    if (data.isNotEmpty) {
      await mainBox?.clear();
    }
  }

  UserEntity? getData(UserEntity value) {
    final box = mainBox;
    if (box != null) {
      return box.get(value) as UserEntity;
    }
    return null;
  }

  List<UserEntity> getAllData() {
    final data = mainBox?.values.toList();
    if (data == null) {
      return <UserEntity>[];
    }

    final List<UserEntity> articleData = data.map((item) {
      if (item is UserEntity) {
        return item;
      } else {
        // Handle casting here, e.g., creating a new UserEntity
        // instance from the dynamic item
        return UserEntity(
          name: "${item["first_name"]} ${item["last_name"]}",
          avatar: item["avatar"].toString(),
          email: item["email"].toString(),
        );
      }
    }).toList();

    return articleData;
  }

  Future<void> closeBox({bool isUnitTest = false}) async {
    try {
      if (mainBox != null) {
        await mainBox?.close();
        await mainBox?.deleteFromDisk();
      }
    } catch (e, stackTrace) {
      if (!isUnitTest) {
        FirebaseCrashLogger().nonFatalError(error: e, stackTrace: stackTrace);
      }
    }
  }
}
