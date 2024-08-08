import 'package:flutter/material.dart';
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
          idEquipamento INTEGER,
          idUnidade INTEGER,
          idFabricante INTEGER,
          idModelo INTEGER,
          modelo TEXT, 
          setor TEXT, 
          numeroSerie TEXT,
          numeroLacre TEXT,
          patrimonioSead TEXT,
          patrimonioSsp TEXT,
          tipoEquipamento TEXT)''',
    );
  }

  Future<String> insertEquipamento({required ItemEquipamento itens}) async {
    final db = await database;
    try {
      await db.insert(
        'equipamento',
        itens.toDb(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return AppName.sucesso!;
    } catch (e) {
      debugPrint("Erro: ${e.toString()}");
      return "Erro";
    }
  }

  Future<bool> equipamentoExiste(
      {required int idEquipamento, required int idUnidade}) async {
    final db = await database;

    final List<Map<String, dynamic>> resultado = await db.query(
      'equipamento',
      where: 'idEquipamento = ? AND idUnidade = ?',
      whereArgs: [idEquipamento, idUnidade],
    );

    return resultado.isNotEmpty;
  }

  Future<List<ItemEquipamento>> getEquipamentos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('equipamento');
    return List.generate(maps.length, (i) {
      return ItemEquipamento(
        idBanco: maps[i]['id'],
        idUnidade: maps[i]['idUnidade'],
        setor: maps[i]['setor'],
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

  Future<List<ItemEquipamento>> getEquipamentosPorIdUnidade(
      int idUnidade) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'equipamento',
      where: 'idUnidade = ?',
      whereArgs: [idUnidade],
    );

    return List.generate(maps.length, (i) {
      return ItemEquipamento(
        idBanco: maps[i]['id'],
        setor: maps[i]['setor'],
        idUnidade: maps[i]['idUnidade'],
        numeroLacre: maps[i]['numeroLacre'],
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

  Future<int> getEquipamentosCount(int idUnidade) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db
        .query('equipamento', where: 'idUnidade = ?', whereArgs: [idUnidade]);

    return maps.length;
  }

  Future<bool> temEquipamentosCadastrados(int idUnidade) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('equipamento',
        where: 'idUnidade = ?', whereArgs: [idUnidade], limit: 1);

    return result.isNotEmpty;
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

    await db.delete(
      "equipamento",
    ); // Exclui todos os registros da tabela
  }

  Future<void> deleteAllEquipamentosPorUnidade(int idUnidade) async {
    final Database db = await database;

    await db.delete(
      "equipamento",
      where: "idUnidade = ?",
      whereArgs: [idUnidade],
    ); // Exclui todos os registros da tabela
  }

  Future<void> deleteATable() async {
    final db = await database;
    await db.execute("DROP TABLE IF EXISTS equipamento"); //excluir a tabela
  }
}
