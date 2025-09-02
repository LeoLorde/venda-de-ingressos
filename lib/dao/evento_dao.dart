import 'package:venda_ingressos/database/DB.dart';
import 'package:venda_ingressos/models/evento_model.dart';

class EventoDao {
  final dbProvider = DB.instance;

  Future<int> inserir(Evento evento) async {
    final db = await dbProvider.database;
    return await db.insert('eventos', evento.toMap());
  }

  Future<List<Evento>> listarTodos() async {
    final db = await dbProvider.database;
    final maps = await db.query('eventos');
    return maps.map((e) => Evento.fromMap(e)).toList();
  }

  Future<Evento?> buscarPorId(int id) async {
    final db = await dbProvider.database;
    final maps = await db.query('eventos', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Evento.fromMap(maps.first);
    }
    return null;
  }

  Future<int> atualizar(Evento evento) async {
    final db = await dbProvider.database;
    return await db.update(
      'eventos',
      evento.toMap(),
      where: 'id = ?',
      whereArgs: [evento.id],
    );
  }

  Future<int> deletar(int id) async {
    final db = await dbProvider.database;
    return await db.delete('eventos', where: 'id = ?', whereArgs: [id]);
  }
}
