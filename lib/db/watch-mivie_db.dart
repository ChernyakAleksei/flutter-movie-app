import 'dart:async';

import 'package:achernyak_app/models/movie_card.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null)
    return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {

  return await openDatabase(
    join(await getDatabasesPath(), 'watch_movie2.db'),
    onCreate: (Database db, int version) async {
      const String columns =
        'id INTEGER PRIMARY KEY,'
        'vote_average REAL,'
        'title INTEGER,'
        'poster_path TEXT,'
        'overview TEXT,'
        'release_date TEXT';
      await db.execute(
        'CREATE TABLE moviesWatched($columns)'
      );
      await db.execute(
        'CREATE TABLE movies($columns)'
      );
    },
    version: 1,
  );
}

Future<void> insert(MovieCard card, String table) async {
    final Database db = await database;

    await db.insert(
      table,
      card.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

Future<List<MovieCard>> getAll(String table) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(table);

    final List<MovieCard> list =
      maps.isNotEmpty ? maps.map((Map<String, dynamic> c) => MovieCard.fromJSON(c)).toList() : [];

    return list;
  }

    Future<void> delete(int id, String table) async {
    final Database db = await database;

    await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id]
    );
  }
}