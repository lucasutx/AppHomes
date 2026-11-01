import 'package:cloud_firestore/cloud_firestore.dart';
import 'evento_model.dart';

class EventosRepository {
  EventosRepository({FirebaseFirestore? firestore})
      : _collection =
            (firestore ?? FirebaseFirestore.instance).collection('eventos');

  final CollectionReference<Map<String, dynamic>> _collection;

  Stream<List<Evento>> observarAgenda() {
    final agora = DateTime.now();
    final hoje = DateTime(agora.year, agora.month, agora.day);
    return _collection
        .where('dataHora', isGreaterThanOrEqualTo: Timestamp.fromDate(hoje))
        .orderBy('dataHora')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Evento.fromFirestore(doc.id, doc.data()))
            .toList());
  }

  Future<void> salvar(Evento evento) async {
    if (evento.id.isEmpty) {
      await _collection.add({
        ...evento.toFirestore(),
        'criadoEm': FieldValue.serverTimestamp(),
      });
      return;
    }
    await _collection.doc(evento.id).set(
          evento.toFirestore(),
          SetOptions(merge: true),
        );
  }

  Future<void> excluir(String id) => _collection.doc(id).delete();
}
