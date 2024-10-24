import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Dog {
  final int? id;
  final String? name;
  final int? age;

  Dog({ this.id, this.name, this.age });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age
    };
  }

  @override
  String toString() {
    return 'Dog(id: $id, name: $name, age: $age)';
  }
}

Future<Database> initializeDatabase() async {
  try {
    final String path = join(await getDatabasesPath(), 'doggie_database.db');
    return await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE dogs("
                "id INTEGER PRIMARY KEY,"
                "name TEXT,"
                "age INTEGER"
                ")"
        );
      },
      version: 1,
    );
  } catch (e) {
    print('Error initializing database: $e');
    rethrow;
  }
}

Future<void> insertDog(Dog dog) async {
  final Database db = await initializeDatabase();

  await db.insert('dogs', dog.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<List<Dog>> dogs() async {
  final Database db = await initializeDatabase();
  final List<Map<String, dynamic>> maps = await db.query('dogs');

  return List.generate(maps.length, (i) {
    return Dog(
      id: maps[i]['id'],
      name: maps[i]['name'],
      age: maps[i]['age'],
    );
  });
}

Future<void> updateDog(Dog dog) async {
  final db = await initializeDatabase();
  await db.update('dogs', dog.toMap(), where: "id=?", whereArgs: [dog.id]);
}

Future<void> deleteDog(int id) async {
  final db = await initializeDatabase();
  await db.delete('dogs', where: "id=?", whereArgs: [id]);
}

