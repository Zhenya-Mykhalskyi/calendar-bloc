import 'dart:async';
import 'dart:developer';
import 'package:keym_calendar/repositories/calendar/abstarct_calendar_repository.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'models/event.dart';

class CalendarRepository extends AbstractCalendarRepository {
  Database? _database;

  @override
  bool get isDatabaseInitialized => _database != null;

  @override
  Future<void> open() async {
    if (_database == null) {
      _database = await openDatabase(
        join(await getDatabasesPath(), 'calendar_database.db'),
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE events(id INTEGER PRIMARY KEY, dateTime TEXT, title TEXT, description TEXT, photoPath TEXT)',
          );
        },
        version: 1,
        readOnly: false,
      );
    } else {
      await _database!.execute('DROP TABLE IF EXISTS events');
      log('dropdatabase');
      await _database!.execute(
        'CREATE TABLE events(id INTEGER PRIMARY KEY, dateTime TEXT, title TEXT, description TEXT, photoPath TEXT)',
      );
      log('new database');
    }

    // Вставляємо дані в таблицю
    final List<Event> eventsToInsert = [
      Event(
        id: 1,
        dateTime: DateTime.now(),
        title: 'Перша подія',
        description: 'Опис першої події',
        photoPath: 'шлях_до_фото_1.jpg',
      ),
      Event(
        id: 2,
        dateTime: DateTime.now().add(const Duration(days: 1)),
        title: 'Друга подія',
        description: 'Опис другої події',
        photoPath: 'шлях_до_фото_2.jpg',
      ),
    ];

    for (final event in eventsToInsert) {
      await _database!.insert(
        'events',
        event.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    print('Таблицю успішно видалено і знову створено, та дані додано.');
  }

  @override
  Future<void> close() async => _database!.close();

  @override
  Future<List<Event>> getAllEvents() async {
    if (!isDatabaseInitialized) {
      throw StateError('Database is not initialized');
    }

    final List<Map<String, dynamic>> maps = await _database!.query('events');

    return List.generate(maps.length, (i) {
      return Event.fromMap(maps[i]);
    });
  }

  @override
  Future<List<Event>> getEventsForDay(DateTime dateTime) async {
    final List<Map<String, dynamic>> maps = await _database!.query(
      'events',
      where: 'dateTime = ?',
      whereArgs: [dateTime.toIso8601String()],
    );

    return List.generate(maps.length, (i) {
      return Event.fromMap(maps[i]);
    });
  }

  @override
  Future<int> getEventCountForDay(DateTime dateTime) async {
    final List<Map<String, dynamic>> maps = await _database!.query(
      'events',
      columns: ['id'],
      where: 'dateTime = ?',
      whereArgs: [dateTime.toIso8601String()],
    );
    return maps.length;
  }

  @override
  Future<void> insertEvent(Event event) async {
    await _database!.insert(
      'events',
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateEvent(Event event) async {
    await _database!.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  @override
  Future<void> deleteEvent(int id) async {
    await _database!.delete(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
