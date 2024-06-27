import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:suporte_dti/model/itens_equipamento_model.dart';
import 'package:suporte_dti/utils/app_name.dart';

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
          setor TEXT, 
          numeroSerie TEXT,
          patrimonioSead TEXT,
          patrimonioSsp TEXT,
          tipoEquipamento TEXT)''',
    );
  }

  Future<String> insertEquipamento(ItemEquipamento itens) async {
    final db = await database;

    try {
      bool seExiste = await equipamentoExiste(itens.idEquipamento!);
      if (seExiste) {
        return "Equipamento já cadastrado";
      } else {
        await db.insert(
          'equipamento',
          itens.toDb(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        return AppName.sucesso!;
      }
    } catch (e) {
      return "Erro: ${e.toString()}";
    }
  }

  Future<bool> equipamentoExiste(int idEquipamento) async {
    final db = await database;

    final List<Map<String, dynamic>> resultado = await db.query(
      'equipamento',
      where: 'idEquipamento = ?',
      whereArgs: [idEquipamento],
    );

    return resultado.isNotEmpty;
  }

  Future<List<ItemEquipamento>> equipamentos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('equipamento');
    return List.generate(maps.length, (i) {
      return ItemEquipamento(
        idBanco: maps[i]['id'],
        setor: maps[i]['setor'],
        idEquipamento: maps[i]['IdEquipamento'],
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

  Future<String> updateEquipamento(ItemEquipamento equipamento) async {
    final db = await database;
    try {
      await db.update(
        'equipamento',
        equipamento.toDb(),
        where: "idEquipamento = ?",
        whereArgs: [equipamento.idEquipamento],
      );

      return AppName.sucesso!;
    } catch (e) {
      return AppName.erro!;
    }
  }

  Future<void> deleteEquipamentoPorId(int idBanco) async {
    final db = await database;
    await db.delete(
      'equipamento',
      where: "id = ?",
      whereArgs: [idBanco],

      ///
    );
  }

  Future<void> deleteAllEquipamentos() async {
    final Database db = await database;

    await db.delete("equipamento"); // Exclui todos os registros da tabela
  }

  Future<void> deleteATable() async {
    final db = await database;
    await db.execute("DROP TABLE IF EXISTS equipamento"); //excluir a tabela
  }
}
