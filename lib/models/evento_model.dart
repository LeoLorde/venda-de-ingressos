class Evento {
  int? id;
  String nome;
  int quantidadeMaxima;

  Evento({this.id, required this.nome, required this.quantidadeMaxima});

  Evento copyWith({int? id, String? nome, int? quantidadeMaxima}) {
    return Evento(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      quantidadeMaxima: quantidadeMaxima ?? this.quantidadeMaxima,
    );
  }

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
