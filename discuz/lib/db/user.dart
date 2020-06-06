import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tableName = 'userTable';

const int _kDBVersion = 1;

class UserDBModel {
  int item;
  String data;

  UserDBModel(int item, String data) {
    this.item = item;
    this.data = data;
  }

  Map<String, dynamic> toMap() => {
        'item': item,
        'data': data,
      };

  UserDBModel.fromMap(Map<String, dynamic> map) {
    item = map['item'];
    data = map['data'];
  }
}

class UserDataSqlite {
  Database db;

  Future<void> openSqlite() async {
    /// 获取数据库文件的存储路径
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'user.db');

    /// 根据数据库文件路径和数据库版本号创建数据库表
    db = await openDatabase(path, version: _kDBVersion,
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE $tableName (
            item INTEGER PRIMARY KEY NOT NULL UNIQUE, 
            data TEXT)
          ''');
    });
  }

  // 添加
  Future<UserDBModel> insert(UserDBModel user) async {
    user.item = await db.insert(tableName, user.toMap());
    return user;
  }

  /// 查询全部用户
  Future<List<UserDBModel>> queryAll() async {
    List<Map> maps = await db.query(tableName, columns: ['item', 'data']);

    if (maps == null || maps.length == 0) {
      return null;
    }

    List<UserDBModel> users = [];
    maps.forEach((it) {
      users.add(UserDBModel.fromMap(it));
    });
    return users;
  }

  /// 使用记录ID进行查询
  Future<UserDBModel> queryByID(int item) async {
    List<Map> maps = await db.query(tableName,
        columns: [
          'item',
          'data',
        ],
        where: 'item = ?',
        whereArgs: [item]);
    if (maps != null && maps.length > 0) {
      return UserDBModel.fromMap(maps.first);
    }

    return null;
  }

  /// 更新用户
  Future<UserDBModel> update(UserDBModel topic) async {
    topic.item = await db.update(tableName, topic.toMap(),
        where: 'item = ?', whereArgs: [topic.item]);
    return topic;
  }

  /// 删除
  Future<int> remove(int item) async =>
      await db.delete(tableName, where: 'item = ?', whereArgs: [item]);

  /// 清空全部
  /// 这将同时移除 user.db文件
  Future<void> clearAll() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'user.db');
    return deleteDatabase(path);
  }

  close() async => await db.close();
}
