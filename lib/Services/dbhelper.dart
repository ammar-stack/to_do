import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:todo_app/Services/todomodal.dart';

class Dbhelper {
  Dbhelper._();
  static Dbhelper instance = Dbhelper._();

  Database? db;

  static String TableName = "ToDoTable";
  static String idColumn = 'id';
  static String todoColumn = 'todo';
  static String isdoneColumn = 'isdone';

  Future<Database> getDB() async {
    return db ?? await initDB();
  }

  Future<Database> initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'todo.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
         CREATE TABLE $TableName(
         $idColumn INTEGER PRIMARY KEY,
         $todoColumn TEXT,
         $isdoneColumn INTEGER)     
        ''');
      },
    );
  }

  //insert to do
  Future<int> insertToDo(ToDoModal modal) async {
    final db = await getDB();
    return db.insert(TableName, modal.toJson());
  }

  //delete to do
  Future<int> deleteToDo(ToDoModal modal) async {
    final db = await getDB();
    return db.delete(TableName, where: 'id = ?', whereArgs: [modal.id]);
  }

  //update to do
  Future<int> updateToDo(ToDoModal modal) async {
    final db = await getDB();
    return db.update(
      TableName,
      modal.toJson(),
      where: 'id = ?',
      whereArgs: [modal.id],
    );
  }

  //get all to dos
  Future<List<ToDoModal>> GetToDo() async {
    final db = await getDB();
    List<Map<String, dynamic>> data = await db.query(TableName);
    return data.map((c) => ToDoModal.fromJson(c)).toList();
  }
}
