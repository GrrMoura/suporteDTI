import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:suporte_dti/model/equipamentos_historico_model.dart';

class SqliteService {
  Database? _database;
  Future<Database> get database async {
    final String dbpath = await getDatabasesPath();
    const dbName = "historico.db";
    final path = join(dbpath, dbName);

    _database = await openDatabase(path, version: 1, onCreate: _createDB);

    return _database!;
  }

  Future _createDB(Database db, int version) async {
    await db.execute(
      '''
          CREATE TABLE Equipamentos(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          patrimonio TEXT NOT NULL, 
          tipo TEXT NOT NULL,
          marca TEXT NOT NULL,
          lotacao TEXT NOT NULL,
          tag TEXT NOT NULL)''',
    );
  }

  Future add(EquipamentosHistoricoModel equipamento) async {
    final db = await database;

    var termoExiste = await db.rawQuery(
        "SELECT * FROM Equipamentos WHERE patrimonio='${equipamento.patrimonio}'");
    if (termoExiste.isNotEmpty) {
      await db.delete('Equipamentos',
          where: 'patrimonio==?', whereArgs: [equipamento.patrimonio]);
    }

    await db.insert('Equipamentos', equipamento.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<EquipamentosHistoricoModel>> getEquipamentos() async {
    final db = await database;
    List<Map<String, dynamic>> equipamentoList =
        await db.query('Equipamentos', orderBy: 'id DESC');

    return List.generate(
        equipamentoList.length,
        (i) => EquipamentosHistoricoModel(
            id: equipamentoList[i]['id'],
            patrimonio: equipamentoList[i]['patrimonio'],
            tipo: equipamentoList[i]['tipo'],
            marca: equipamentoList[i]['marca'],
            lotacao: equipamentoList[i]['lotacao'],
            tag: equipamentoList[i]['tag']));
  }

  Future<void> deletarEquipamento(String patrimonio) async {
    final db = await database;

    await db.delete('Equipamentos',
        where: 'patrimonio = ?', whereArgs: [patrimonio]);
  }

  Future<void> deletarTabela() async {
    final db = await database;
    db.delete('Equipamentos');
  }
}
