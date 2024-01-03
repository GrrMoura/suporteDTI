import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:suporte_dti/model/equipamentos_historico_model.dart';

class SqliteService {
  Database? _database;
  Future<Database> get database async {
    final String dbpath = await getDatabasesPath();
    const dbname = "historico.db";
    final path = join(dbpath, dbname);
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
          tag TEXT NOT NULL)''',
    );
  }

  Future add(EquipamentosHistoricoModel historico) async {
    final db = await database;

    var termoExiste = await db.rawQuery(
        "SELECT * FROM historico WHERE patrimonio='${historico.patrimonio}'");
    if (termoExiste.isNotEmpty) {
      await db.delete('historico',
          where: 'patrimonio==?', whereArgs: [historico.patrimonio]);
    }

    await db.insert('historico', historico.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<EquipamentosHistoricoModel>> getEquipamentos() async {
    final db = await database;
    List<Map<String, dynamic>> equipamentoList =
        await db.query('historico', orderBy: 'id DESC');

    return List.generate(
        equipamentoList.length,
        (i) => EquipamentosHistoricoModel(
            id: equipamentoList[i]['id'],
            patrimonio: equipamentoList[i]['patrimonio'],
            tipo: equipamentoList[i]['tipo'],
            marca: equipamentoList[i]['marca'],
            tag: equipamentoList[i]['tag']));
  }

  Future<void> deletarEquipamento(String patrimonio) async {
    final db = await database;

    await db
        .delete('historico', where: 'patrimonio==?', whereArgs: [patrimonio]);
  }
}
