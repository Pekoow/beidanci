import 'dart:io';
import 'dart:async';
import 'package:helproommatespasscet4/model/constant.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:helproommatespasscet4/model/word.dart';

// database helper
class DBClient {
  final String studied = 'studied'; //是否学习过
  final String text = 'text'; //单词文本
  final String ph_en = 'ph_en'; //英文发音音标
  final String ph_en_mp3 = 'ph_en_mp3'; //英文发音
  final String explain = 'explain'; //单词释义

  static const String users = 'users';
  static const String userId = 'userId';
  static const String username = 'username';
  static const String password = 'password';

  static const String wordProgressTable = 'word_progress';
  static const String colWordId = 'wordId';
  static const String colReviewCount = 'review_count';

  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initDb();
    }
    return _db;
  }

  //Creating a database with name test.dn in your directory
  initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, '$studied.db');
    var db = await openDatabase(path,
        version: Constant.dbVersion, onCreate: _onCreate, onOpen: _onOpen);
    return db;
  }

  void _onOpen(Database db) {
    print('打开数据库成功');
  }

  void _onCreate(Database db, int newVersion) async {
    print('创建数据库成功');
    await db.execute('''
      create table $studied (
        _id integer primary key autoincrement, 
        $text text not null,
        $ph_en text,
        $ph_en_mp3 text,
        $explain text
      );
    ''');
    await db.execute('''
          create table $users (
            _id integer primary key autoincrement, 
            $userId text not null,
            $username TEXT NOT NULL,
            $password TEXT NOT NULL
          )
          ''');
  }

  Future<Word> insert(Word word) async {
    var client = await db;
    try {
      await client.insert('studied', {
        text: word.text,
        ph_en: word.ph_en,
        ph_en_mp3: word.ph_en_mp3,
        explain: word.explain
      });
    } catch (e) {
      print(e);
    }
    print('插入操作');
    return word;
  }

  Future<Word> queryById(int id) async {
    var client = await db;
    List<Map> maps =
    await client.query(studied, where: "_id = ?", whereArgs: [id]);
    print('查找的id为： $id');
    if (maps.length > 0) {
      return Word.fromJson(maps.first);
    }
    return null;
  }

  Future<List> queryAll() async {
    print("Studied words ......");
    // var client = await db;
    try {
      var client = await db;
      // 执行其他操作...
      List<Map> maps = await client.query(studied);
      print("查询成功");
      List words = [];
      maps.forEach((json) {
        words.add(json['text']);
      });
      return words;
    } catch (e) {
      print("Error occurred while awaiting db: $e");
    }
  }

  //user部分
  Future<int> insertUser(String id,String name ,String pwd) async {
    var client = await db;
    try {
      await client.insert('users', {
        userId: id,
        username: name,
        password: pwd,
      });
      print('user插入操作');
    } catch (e) {
      print(e);
    }
    return 1;
  }
  Future<List<Map<String, dynamic>>> getUsers() async {
    Database db = await _db;
    return await db.query(users);
  }
  Future<int> updateUser(Map<String, dynamic> user) async {
    Database db = await _db;
    return await db.update(
      users,
      user,
      where: '$userId = ?',
      whereArgs: [user[userId]],
    );
  }
  Future<int> deleteUser(String userId) async {
    Database db = await _db;
    return await db.delete(
      users,
      where: '$userId = ?',
      whereArgs: [userId],
    );
  }




}
