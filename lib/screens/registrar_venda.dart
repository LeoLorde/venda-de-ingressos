import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:venda_ingressos/dao/venda_dao.dart';
import 'package:venda_ingressos/models/venda_model.dart';
import 'package:venda_ingressos/models/evento_model.dart';

class RegistrarVenda extends StatefulWidget {
  final Evento evento; // venda vinculada a um evento

  const RegistrarVenda({super.key, required this.evento});

  @override
  State<RegistrarVenda> createState() => _RegistrarVendaState();
}

class _RegistrarVendaState extends State<RegistrarVenda> {
  final _nomeController = TextEditingController();
  final _quantidadeController = TextEditingController();
  DateTime? _dataNascimento;

  final VendaDao _vendaDao = VendaDao();

  Future<void> _selecionarData() async {
    final dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (dataSelecionada != null) {
      setState(() {
        _dataNascimento = dataSelecionada;
      });
    }
  }

  Future<void> _salvarVenda() async {
    final nome = _nomeController.text.trim();
    final quantidade = int.tryParse(_quantidadeController.text.trim()) ?? 0;

    if (nome.isEmpty || _dataNascimento == null || quantidade <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos corretamente")),
      );
      return;
    }

    final venda = Venda(
      nomeComprador: nome,
      dataNascimento: _dataNascimento!,
      quantidade: quantidade,
      eventoId: widget.evento.id!, // FK pro evento
    );

    await _vendaDao.inserir(venda);

    Navigator.pop(context, true); // retorna true p/ recarregar a lista
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar Venda - ${widget.evento.nome}"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: "Nome do comprador"),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _dataNascimento == null
                        ? "Nenhuma data selecionada"
                        : "Data de nascimento: ${DateFormat('dd/MM/yyyy').format(_dataNascimento!)}",
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _selecionarData,
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _quantidadeController,
              decoration: const InputDecoration(
                labelText: "Quantidade de ingressos",
              ),
              keyboardType: TextInputType.number,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _salvarVenda,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Salvar", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
