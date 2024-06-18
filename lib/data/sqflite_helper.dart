import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:suporte_dti/model/itens_equipamento_model.dart';

class DatabaseHelper {
  Database? _database;

  Future<Database> get database async {
    final String dbpath = await getDatabasesPath();
    const dbName = "equipamento.db";
    final path = join(dbpath, dbName);

    _database = await openDatabase(path, version: 1, onCreate: _createDB);

    return _database!;
  }

  Future _createDB(Database db, int version) async {
    await db.execute(
      '''CREATE TABLE equipamento(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          descricao TEXT, 
          fabricante TEXT,   
          IdEquipamento INTEGER,
          idFabricante INTEGER,
          idModelo INTEGER,
          modelo TEXT, 
          numeroSerie TEXT,
          patrimonioSead TEXT,
          patrimonioSsp TEXT,
          tipoEquipamento TEXT)''',
    );
  }

  Future<void> insertEquipamento(ItemEquipamento itens) async {
    final db = await database;
    await db.insert(
      'equipamento',
      itens.toDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ItemEquipamento>> equipamentos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('equipamento');
    return List.generate(maps.length, (i) {
      return ItemEquipamento(
        idEquipamento: maps[i]['idEquipamento'],
        numeroSerie: maps[i]['numeroSerie'],
        patrimonioSead: maps[i]['patrimonioSead'],
        patrimonioSsp: maps[i]['patrimonioSsp'],
        idFabricante: maps[i]['idFabricante'],
        descricao: maps[i]['descricao'],
        fabricante: maps[i]['fabricante'],
        modelo: maps[i]['modelo'],
        tipoEquipamento: maps[i]['tipoEquipamento'],
      );
    });
  }

  Future<int> getEquipamentosCount() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('equipamento');
    return maps.length;
  }

  Future<void> updateEquipamento(ItemEquipamento equipamento) async {
    final db = await database;
    await db.update(
      'equipamento',
      equipamento.toDb(),
      where: "idEquipamento = ?",
      whereArgs: [equipamento.idEquipamento],
    );
  }

  Future<void> deleteEquipamento(int idEquipamento) async {
    final db = await database;
    await db.delete(
      'equipamento',
      where: "idEquipamento = ?",
      whereArgs: [idEquipamento],
    );
  }

  Future<void> deleteTable() async {
    final db = await database;
    await db.execute("DROP TABLE IF EXISTS equipamento");
    print("deletei");
  }
}
