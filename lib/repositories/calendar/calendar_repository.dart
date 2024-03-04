import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/event.dart';

class CalendarRepository {
  Database? _database;

  bool get isDatabaseInitialized => _database != null;

  Future<void> open() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'calendar_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE events(id TEXT PRIMARY KEY, dateTime TEXT, title TEXT, description TEXT, photoPath TEXT)',
        );
      },
      version: 1,
      readOnly: false,
    );
  }

  Future<void> deleteDB() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'calendar_database.db');
    await deleteDatabase(path);
  }

  Future<void> close() async => _database!.close();

  Future<List<Event>> getAllEvents() async {
    if (!isDatabaseInitialized) {
      throw StateError('Database is not initialized');
    }

    final List<Map<String, dynamic>> maps = await _database!.query('events');

    return List.generate(maps.length, (i) {
      return Event.fromMap(maps[i]);
    });
  }

  Future<List<Event>> getEventsForDay({required DateTime dateTime}) async {
    final String formattedDate = Event.dateFormat.format(dateTime);

    final List<Map<String, dynamic>> maps = await _database!.query(
      'events',
      where: 'dateTime = ?',
      whereArgs: [formattedDate],
    );
    return List.generate(maps.length, (i) {
      return Event.fromMap(maps[i]);
    });
  }

  Future<void> insertEvent(Event event) async {
    await _database!.insert(
      'events',
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateEvent(Event event) async {
    await _database!.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<void> deleteEvent(int id) async {
    await _database!.delete(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
