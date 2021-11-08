import 'package:rss_reader/model/news.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const String tableNews = 'news';
const String columnId = 'id';
const String columnTitle = 'title';
const String columnLink = 'link';
const String columnTimePublic = 'timePublic';

class DatabaseHandler {
  late Database db;

  Future initializeDB() async {
    try {
      String path = await getDatabasesPath();
      db = await openDatabase(join(path, '$tableNews.db'), version: 1,
          onCreate: (Database db, int version) async {
        await db.execute('''
      create table $tableNews ( 
        $columnId integer primary key autoincrement, 
        $columnTitle text not null,
        $columnLink text not null,
        $columnTimePublic text not null)
      ''');
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<int?> insertNew(News news) async {
    var result = db.insert(tableNews, news.toMap());
    return result;
  }

  fecthAllNews() async {
    List<Map<String, Object?>> result = await db.query(tableNews);
    return result.map((e) => News.fromMap(e)).toList();
  }

  Future<int?> delete(int id) async {
    var result = db.delete(tableNews, where: '$columnId=?', whereArgs: [id]);
    return result;
  }

  Future close() async => db.close();
}
