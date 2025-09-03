import 'package:flutter/material.dart';
import 'package:venda_ingressos/dao/evento_dao.dart';
import 'package:venda_ingressos/models/evento_model.dart';
import 'vendas.dart';

class Eventos extends StatefulWidget {
  @override
  State<Eventos> createState() => _EventosState();
}

class _EventosState extends State<Eventos> {
  final EventoDao _eventoDao = EventoDao();
  List<Evento> _eventos = [];

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _quantidadeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarEventos();
  }

  Future<void> _carregarEventos() async {
    final eventos = await _eventoDao.listarTodos();
    setState(() {
      _eventos = eventos;
    });
  }

  void _abrirCriarEvento() {
    _nomeController.clear();
    _quantidadeController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Novo Evento",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: "Nome do evento"),
              ),
              TextField(
                controller: _quantidadeController,
                decoration: const InputDecoration(
                  labelText: "Quantidade máxima",
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  const Color.fromARGB(255, 10, 40, 65),
                ),
              ),
              child: const Text(
                "Salvar",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                final nome = _nomeController.text.trim();
                final quantidade =
                    int.tryParse(_quantidadeController.text.trim()) ?? 0;

                if (nome.isNotEmpty && quantidade > 0) {
                  final novoEvento = Evento(
                    nome: nome,
                    quantidadeMaxima: quantidade,
                  );
                  await _eventoDao.inserir(novoEvento);
                  Navigator.pop(context);
                  _carregarEventos();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _abrirVendas(Evento evento) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Vendas(evento: evento)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 10, 40, 65),
        title: const Text(
          'Eventos',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: _eventos.isEmpty
          ? const Center(child: Text("Nenhum evento cadastrado"))
          : ListView.builder(
              itemCount: _eventos.length,
              itemBuilder: (context, index) {
                final evento = _eventos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: Icon(Icons.event_note),
                    title: Text(
                      evento.nome,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Nº Máx. de Ingressos: ${evento.quantidadeMaxima}",
                    ),
                    onTap: () => _abrirVendas(evento),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 10, 40, 65),
        foregroundColor: Colors.white,
        onPressed: _abrirCriarEvento,
        child: const Icon(Icons.add),
      ),
    );
  }
}
