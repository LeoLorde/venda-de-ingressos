import 'package:venda_ingressos/database/DB.dart';
import 'package:venda_ingressos/models/venda_model.dart';

class VendaDao {
  final dbProvider = DB.instance;

  Future<int> inserir(Venda venda) async {
    final db = await dbProvider.database;
    return await db.insert('vendas', venda.toMap());
  }

  Future<List<Venda>> listarPorEvento(int idEvento) async {
    final db = await dbProvider.database;
    final maps = await db.query(
      'vendas',
      where: 'id_evento = ?',
      whereArgs: [idEvento],
    );
    return maps.map((e) => Venda.fromMap(e)).toList();
  }

  Future<List<Venda>> listarTodas() async {
    final db = await dbProvider.database;
    final maps = await db.query('vendas');
    return maps.map((e) => Venda.fromMap(e)).toList();
  }

  Future<Venda?> buscarPorId(int id) async {
    final db = await dbProvider.database;
    final maps = await db.query('vendas', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Venda.fromMap(maps.first);
    }
    return null;
  }

  Future<int> atualizar(Venda venda) async {
    final db = await dbProvider.database;
    return await db.update(
      'vendas',
      venda.toMap(),
      where: 'id = ?',
      whereArgs: [venda.id],
    );
  }

  Future<int> deletar(int id) async {
    final db = await dbProvider.database;
    return await db.delete('vendas', where: 'id = ?', whereArgs: [id]);
  }
}
