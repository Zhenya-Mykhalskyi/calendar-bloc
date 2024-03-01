import 'dart:async';
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

      await _database!.execute(
        'CREATE TABLE events(id INTEGER PRIMARY KEY, dateTime TEXT, title TEXT, description TEXT, photoPath TEXT)',
      );
    }

    final List<Event> eventsToInsert = [
      Event(
        id: 1,
        dateTime: DateTime(2024, 3, 1),
        title: 'Перша подія',
        description: 'Опис першої події',
        photoPath: 'https://www.imgonline.com.ua/examples/bee-on-daisy.jpg',
      ),
      Event(
        id: 2,
        dateTime: DateTime(2024, 3, 2),
        title: 'Друга подія',
        description: 'Опис другої події',
        photoPath: 'https://www.imgonline.com.ua/examples/bee-on-daisy.jpg',
      ),
      Event(
        id: 3,
        dateTime: DateTime(2024, 3, 16),
        title: 'Третя подія',
        description: 'Опис другої події',
        photoPath: 'https://www.imgonline.com.ua/examples/bee-on-daisy.jpg',
      ),
      Event(
        id: 4,
        dateTime: DateTime(2024, 3, 18),
        title: 'Четверта подія',
        description: 'Опис другої події',
        photoPath: 'https://www.imgonline.com.ua/examples/bee-on-daisy.jpg',
      ),
      Event(
        id: 5,
        dateTime: DateTime(2024, 3, 18),
        title: 'Пʼята подія',
        description: 'Опис другої події',
        photoPath: 'https://www.imgonline.com.ua/examples/bee-on-daisy.jpg',
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
  Future<List<Event>> getEventsForDay({required DateTime dateTime}) async {
    final String formattedDate = dateTime.toIso8601String().substring(0, 23);
    final List<Map<String, dynamic>> maps = await _database!.query(
      'events',
      where: 'dateTime = ?',
      whereArgs: [formattedDate],
    );
    return List.generate(maps.length, (i) {
      return Event.fromMap(maps[i]);
    });
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
