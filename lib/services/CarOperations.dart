import 'dart:developer';
import 'package:opt_ga_flutter_apps/models/car.dart';
import '../helper-database/database.dart';

class CarOperations {
  CarOperations? carOperations;

  final dbProvider = DatabaseCon();

  createCar(Car car) async {
    final db = await dbProvider.database;
    db?.insert('cars', car.toMap());
  }

  updateCar(Car car) async {
    final db = await dbProvider.database;
    db?.update('cars', car.toMap(), where: "id=?", whereArgs: [car.id]);
  }

  deleteCar(Car car) async {
    final db = await dbProvider.database;
    db?.update('cars', car.toMap(), where: 'id=?', whereArgs: [car.id]);
  }

  Future<List<Car>> getAllContacts() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> allRows = await db!.query('cars');
    List<Car> cars = allRows.map((cars) => Car.fromMap(cars)).toList();
    print('allRowsm: $allRows');
    print('cars: $cars');
    return cars;
  }

  Future<List<Car>> getAllCars(Car car) async {
    var connection = await dbProvider.database;
    // final result = await connection?.query(table);
    final List<Map<String, dynamic>> result = await connection!
        .query('cars', where: 'isDeleted=?', whereArgs: [car.isDeleted = 0]);
    inspect(result);
    return result.map((cars) => Car.fromMap(cars)).toList();

    // return await connection?.query(table);
  }

  // print(res);
  // List<Car> list =
  //     res.isNotEmpty ? res.map((c) => Car.fromMap(c)).toList() : [];

  // print('list: $list');
  // print('result query: $res');
  // return list;
}

  // Future<Future<List<Map<String, Object?>>>> getData() async {
  //   final db = await dbProvider.database;
  //   final result = db!.rawQuery('select * from cars');
  //   print('Result: $result');
  //   return result;
  //   print('Result: $result');
  // }

  // var dbClient = await dbProvider.database;
  // var res = await dbClient?.query("cars");

  // List<Car>? list =
  //     res!.isNotEmpty ? res.map((c) => Car.fromMap(c)).toList() : null;

  // return list;

  // print('result: $cars');
  // print('db: $db');
  // print('rows: $allRows');

