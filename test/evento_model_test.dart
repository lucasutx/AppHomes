import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/evento_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('converte evento do Firestore sem perder os dados', () {
    final dataHora = DateTime(2026, 12, 20, 19, 30);

    final evento = Evento.fromFirestore('evento-1', {
      'nome': 'Maria Silva',
      'telefone': '(31) 99999-9999',
      'endereco': 'Rua das Flores, 100',
      'convidados': 80,
      'dataHora': Timestamp.fromDate(dataHora),
    });

    expect(evento.id, 'evento-1');
    expect(evento.nome, 'Maria Silva');
    expect(evento.telefone, '(31) 99999-9999');
    expect(evento.endereco, 'Rua das Flores, 100');
    expect(evento.convidados, 80);
    expect(evento.dataHora, dataHora);
  });
}
