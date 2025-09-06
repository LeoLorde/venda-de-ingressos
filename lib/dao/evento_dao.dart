import 'package:venda_ingressos/database/DB.dart';
import 'package:venda_ingressos/models/evento_model.dart';

class EventoDao {
  final dbProvider = DB.instance;

  Future<Evento> inserir(Evento evento) async {
    final db = await dbProvider.database;
    final id = await db.insert('eventos', evento.toMap());
    return evento.copyWith(id: id);
  }

  Future<List<Evento>> listarTodos() async {
    final db = await dbProvider.database;
    final maps = await db.query('eventos');
    return maps.map((e) => Evento.fromMap(e)).toList();
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
