import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/inquiry.dart';
import '../model/property.dart';

class PropertyDb {
  static const _dbName = 'properties.db';
  static const _dbVersion = 2;
  static const _table = 'properties';
  static const _inquiriesTable = 'inquiries';

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, _dbName);
    _db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_table(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            city TEXT NOT NULL,
            state TEXT NOT NULL,
            price REAL NOT NULL,
            imageUrl TEXT NOT NULL,
            isFavorite INTEGER NOT NULL,
            syncStatus INTEGER NOT NULL,
            beds INTEGER NOT NULL,
            baths REAL NOT NULL,
            sqft INTEGER NOT NULL,
            description TEXT NOT NULL,
            address TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE $_inquiriesTable(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            propertyId INTEGER NOT NULL,
            message TEXT NOT NULL,
            createdAt INTEGER NOT NULL,
            status INTEGER NOT NULL,
            FOREIGN KEY(propertyId) REFERENCES $_table(id)
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE $_inquiriesTable(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              propertyId INTEGER NOT NULL,
              message TEXT NOT NULL,
              createdAt INTEGER NOT NULL,
              status INTEGER NOT NULL,
              FOREIGN KEY(propertyId) REFERENCES $_table(id)
            )
          ''');
        }
      },
    );
    return _db!;
  }

  Future<List<Property>> getAll() async {
    final db = await database;
    final rows = await db.query(_table, orderBy: 'id DESC');
    return rows.map((e) => Property.fromMap(e)).toList();
  }

  Future<int> insert(Property property) async {
    final db = await database;
    return db.insert(_table, property.toMap());
  }

  Future<void> update(Property property) async {
    final db = await database;
    await db.update(
      _table,
      property.toMap(),
      where: 'id = ?',
      whereArgs: [property.id],
    );
  }

  Future<void> deleteAll() async {
    final db = await database;
    await db.delete(_table);
  }

  // Inquiry methods
  Future<List<Inquiry>> getAllInquiries() async {
    final db = await database;
    final rows = await db.query(
      _inquiriesTable,
      orderBy: 'createdAt DESC',
    );
    return rows.map((e) => Inquiry.fromMap(e)).toList();
  }

  Future<List<Inquiry>> getInquiriesForProperty(int propertyId) async {
    final db = await database;
    final rows = await db.query(
      _inquiriesTable,
      where: 'propertyId = ?',
      whereArgs: [propertyId],
      orderBy: 'createdAt DESC',
    );
    return rows.map((e) => Inquiry.fromMap(e)).toList();
  }

  Future<int> insertInquiry(Inquiry inquiry) async {
    final db = await database;
    return db.insert(_inquiriesTable, inquiry.toMap());
  }

  Future<void> updateInquiry(Inquiry inquiry) async {
    final db = await database;
    await db.update(
      _inquiriesTable,
      inquiry.toMap(),
      where: 'id = ?',
      whereArgs: [inquiry.id],
    );
  }

  Future<List<Inquiry>> getPendingInquiries() async {
    final db = await database;
    final rows = await db.query(
      _inquiriesTable,
      where: 'status = ?',
      whereArgs: [InquiryStatus.pending.index],
      orderBy: 'createdAt ASC',
    );
    return rows.map((e) => Inquiry.fromMap(e)).toList();
  }
}