import 'package:cloud_firestore/cloud_firestore.dart';

class Evento {
  const Evento({
    required this.id,
    required this.nome,
    required this.telefone,
    required this.endereco,
    required this.convidados,
    required this.dataHora,
  });

  final String id;
  final String nome;
  final String telefone;
  final String endereco;
  final int convidados;
  final DateTime dataHora;

  Map<String, Object?> toFirestore() => {
        'nome': nome,
        'telefone': telefone,
        'endereco': endereco,
        'convidados': convidados,
        'dataHora': Timestamp.fromDate(dataHora),
        'atualizadoEm': FieldValue.serverTimestamp(),
      };

  factory Evento.fromFirestore(String id, Map<String, dynamic> data) {
    final dataHora = data['dataHora'];
    return Evento(
      id: id,
      nome: (data['nome'] as String?) ?? '',
      telefone: (data['telefone'] as String?) ?? '',
      endereco: (data['endereco'] as String?) ?? '',
      convidados: (data['convidados'] as num?)?.toInt() ?? 0,
      dataHora: dataHora is Timestamp ? dataHora.toDate() : DateTime.now(),
    );
  }
}
