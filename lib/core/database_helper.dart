import 'package:lunch_mate/core/init_menue_list.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'menu_database.db');
    return await openDatabase(
      path,
      version: 2,  // ✅ DB 버전을 증가시켜야 기존 DB를 삭제하고 다시 생성함
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE menu (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT UNIQUE, category TEXT)',
        );

        await db.execute(
          'CREATE TABLE selected_menu (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, selected_at TEXT)',
        );

        await _insertInitialMenus(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'CREATE TABLE IF NOT EXISTS selected_menu (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, selected_at TEXT)',
          );
        }
      },
    );
  }


  // ✅ 최초 1회 실행되는 데이터 삽입 로직
  Future<void> _insertInitialMenus(Database db) async {
    List<Map<String, dynamic>> existingMenus = await db.query('menu');
    if (existingMenus.isNotEmpty) return; // 이미 데이터가 있으면 추가 X

    Batch batch = db.batch();
    for (var menu in menus) {
      batch.insert('menu', menu, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    await batch.commit();
  }

  // ✅ 선택된 메뉴 저장 (name, 선택 시간)
  Future<int> insertSelectedMenu(String name) async {
    final db = await database;
    return await db.insert(
      'selected_menu',
      {'name': name, 'selected_at': DateTime.now().toIso8601String()},
    );
  }

  // ✅ 선택된 메뉴 가져오기 (최근 선택된 메뉴 리스트)
  Future<List<Map<String, dynamic>>> getSelectedMenus() async {
    final db = await database;
    return await db.query('selected_menu', orderBy: 'selected_at DESC');
  }

  // ✅ 메뉴 리스트 가져오기
  Future<List<Map<String, dynamic>>> getMenus() async {
    final db = await database;
    return await db.query('menu');
  }

  // ✅ 메뉴 삭제
  Future<int> deleteMenu(int id) async {
    final db = await database;
    return await db.delete('menu', where: 'id = ?', whereArgs: [id]);
  }

  // ✅ 선택된 메뉴 삭제
  Future<int> deleteSelectedMenu(int id) async {
    final db = await database;
    return await db.delete('selected_menu', where: 'id = ?', whereArgs: [id]);
  }

  // ✅ 최근 선택된 메뉴 3개 가져오는 메서드 추가
  Future<List<Map<String, dynamic>>> getRecentSelectedMenus() async {
    final db = await database;
    return await db.query(
      'selected_menu',
      orderBy: 'selected_at DESC',
      limit: 3, // 🔥 최근 3개만 가져오기
    );
  }
  Future<List<Map<String, dynamic>>> getAllMenus() async {
    final db = await database;
    return await db.query("selected_menu", orderBy: "selected_at DESC");
  }

}
