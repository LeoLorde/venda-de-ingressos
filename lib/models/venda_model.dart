class Venda {
  int? id;
  String nome;
  String dataNascimento;
  int quantidade;
  int idEvento;

  Venda({
    this.id,
    required this.nome,
    required this.dataNascimento,
    required this.quantidade,
    required this.idEvento,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'data_nascimento': dataNascimento,
      'quantidade': quantidade,
      'id_evento': idEvento,
    };
  }

  factory Venda.fromMap(Map<String, dynamic> map) {
    return Venda(
      id: map['id'],
      nome: map['nome'],
      dataNascimento: map['data_nascimento'],
      quantidade: map['quantidade'],
      idEvento: map['id_evento'],
    );
  }
}
