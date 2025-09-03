import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:venda_ingressos/dao/venda_dao.dart';
import 'package:venda_ingressos/models/evento_model.dart';
import 'package:venda_ingressos/models/venda_model.dart';
import 'package:venda_ingressos/screens/registrar_venda.dart';

class Vendas extends StatefulWidget {
  final Evento evento;

  const Vendas({Key? key, required this.evento}) : super(key: key);

  @override
  State<Vendas> createState() => _VendasState();
}

class _VendasState extends State<Vendas> {
  final VendaDao _vendaDao = VendaDao();
  List<Venda> _vendas = [];
  int _ingressosDisponiveis = 0;

  @override
  void initState() {
    super.initState();
    _carregarVendas();
  }

  Future<void> _carregarVendas() async {
    final vendas = await _vendaDao.listarPorEvento(widget.evento.id!);
    final totalVendidos = vendas.fold<int>(0, (sum, v) => sum + v.quantidade);
    setState(() {
      _vendas = vendas;
      _ingressosDisponiveis = widget.evento.quantidadeMaxima - totalVendidos;
    });
  }

  void _abrirRegistrarVenda() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistrarVenda(evento: widget.evento),
      ),
    );

    if (resultado == true) {
      _carregarVendas();
    }
  }

  void _editarVenda(Venda venda) {
    final nomeController = TextEditingController(text: venda.nome);
    final quantidadeController = TextEditingController(
      text: venda.quantidade.toString(),
    );
    DateTime dataNascimento = venda.dataNascimento;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar Venda"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: "Nome"),
              ),
              TextField(
                controller: quantidadeController,
                decoration: const InputDecoration(labelText: "Quantidade"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Nascimento: ${DateFormat('dd/MM/yyyy').format(dataNascimento)}",
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final novaData = await showDatePicker(
                        context: context,
                        initialDate: dataNascimento,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (novaData != null) {
                        setState(() {
                          dataNascimento = novaData;
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                final nome = nomeController.text.trim();
                final quantidade =
                    int.tryParse(quantidadeController.text.trim()) ?? 0;

                if (nome.isEmpty || quantidade <= 0) return;

                final vendaAtualizada = Venda(
                  id: venda.id,
                  nome: nome,
                  dataNascimento: dataNascimento,
                  quantidade: quantidade,
                  idEvento: venda.idEvento,
                );

                await _vendaDao.atualizar(vendaAtualizada);
                Navigator.pop(context);
                _carregarVendas();
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  void _confirmarExclusao(Venda venda) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Excluir Venda"),
        content: Text(
          "Tem certeza que deseja excluir a venda de ${venda.nome}?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await _vendaDao.deletar(venda.id!);
              Navigator.pop(context);
              _carregarVendas();
            },
            child: const Text("Excluir"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vendas - ${widget.evento.nome}"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: _vendas.isEmpty
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
                            "Qtd: ${venda.quantidade} - Nasc.: ${DateFormat('dd/MM/yyyy').format(venda.dataNascimento)}",
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.orange,
                                ),
                                onPressed: () => _editarVenda(venda),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _confirmarExclusao(venda),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Ingressos disponíveis: $_ingressosDisponiveis",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _ingressosDisponiveis > 0 ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: _abrirRegistrarVenda,
        child: const Icon(Icons.add),
      ),
    );
  }
}
