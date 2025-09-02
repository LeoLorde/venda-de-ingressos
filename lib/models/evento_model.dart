class Evento {
  int? id;
  String nome;
  int quantidadeMaxima;

  Evento({this.id, required this.nome, required this.quantidadeMaxima});

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome, 'quantidade_maxima': quantidadeMaxima};
  }

  factory Evento.fromMap(Map<String, dynamic> map) {
    return Evento(
      id: map['id'],
      nome: map['nome'],
      quantidadeMaxima: map['quantidade_maxima'],
    );
  }
}
