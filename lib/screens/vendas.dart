import 'package:flutter/material.dart';
import 'package:venda_ingressos/dao/venda_dao.dart';
import 'package:venda_ingressos/models/evento_model.dart';
import 'package:venda_ingressos/models/venda_model.dart';

class Vendas extends StatefulWidget {
  final Evento evento;

  const Vendas({Key? key, required this.evento}) : super(key: key);

  @override
  State<Vendas> createState() => _VendasState();
}

class _VendasState extends State<Vendas> {
  final VendaDao _vendaDao = VendaDao();
  List<Venda> _vendas = [];

  @override
  void initState() {
    super.initState();
    _carregarVendas();
  }

  Future<void> _carregarVendas() async {
    final vendas = await _vendaDao.listarPorEvento(widget.evento.id!);
    setState(() {
      _vendas = vendas;
    });
  }

  void _abrirRegistrarVenda() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistrarVenda(evento: widget.evento),
      ),
    );
    _carregarVendas(); // recarrega ao voltar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vendas - ${widget.evento.nome}"),
        backgroundColor: Colors.blue,
      ),
      body: _vendas.isEmpty
          ? const Center(child: Text("Nenhuma venda cadastrada"))
          : ListView.builder(
              itemCount: _vendas.length,
              itemBuilder: (context, index) {
                final venda = _vendas[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(
                      venda.nome,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Qtd: ${venda.quantidade} - Nasc.: ${venda.dataNascimento}",
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: _abrirRegistrarVenda,
        child: const Icon(Icons.add),
      ),
    );
  }
}
