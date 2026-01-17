// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// Future<void> testSqflite() async {
//   try {
//     // Get database path
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, 'test.db');

//     // Open database
//     final database = await openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) async {
//         await db.execute(
//           'CREATE TABLE test(id INTEGER PRIMARY KEY, name TEXT)',
//         );
//       },
//     );

//     // Insert data
//     await database.insert('test', {'name': 'Sqflite Working'});

//     // Read data
//     final result = await database.query('test');

//     print('SQFLITE RESULT 👉 $result');

//     await database.close();
//   } catch (e) {
//     print('SQFLITE ERROR ❌ $e');
//   }
// }
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<void> testSqflite() async {
  try {
    print("🔥 SQFLITE TEST STARTED");

    // 1️⃣ Get database directory
    final dbPath = await getDatabasesPath();
    print("📁 Database path: $dbPath");

    // 2️⃣ Create database path
    final path = join(dbPath, 'test.db');

    // 3️⃣ Open database
    final database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        print("🛠 Creating table...");
        await db.execute(
          'CREATE TABLE test(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)',
        );
      },
    );

    // 4️⃣ Insert data
    await database.insert('test', {'name': 'Sqflite Working'});
    print("✅ Data inserted");

    // 5️⃣ Read data
    final result = await database.query('test');
    print("📊 Data from DB: $result");

    // 6️⃣ Close database
    await database.close();
    print("🎉 SQFLITE TEST COMPLETED SUCCESSFULLY");
  } catch (e) {
    print("❌ SQFLITE ERROR: $e");
  }
}
