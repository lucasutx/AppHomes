import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'despesa_model.dart';

class DespesasRepository {
  static const _legacyStorageKey = 'homes_despesas_v1';
  DespesasRepository({FirebaseFirestore? firestore})
      : _collection =
            (firestore ?? FirebaseFirestore.instance).collection('lancamentos');

  final CollectionReference<Map<String, dynamic>> _collection;

  static Future<void> migrarDadosLocais({FirebaseFirestore? firestore}) async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(_legacyStorageKey);
    if (raw == null || raw.isEmpty) return;

    final decoded = jsonDecode(raw) as List<dynamic>;
    final items = decoded
        .whereType<Map<String, dynamic>>()
        .map(Despesa.fromLocalJson)
        .where((item) => item.valor > 0)
        .toList();
    if (items.isEmpty) {
      await preferences.remove(_legacyStorageKey);
      return;
    }

    final database = firestore ?? FirebaseFirestore.instance;
    final batch = database.batch();
    for (final item in items) {
      final id = item.id.isEmpty
          ? DateTime.now().microsecondsSinceEpoch.toString()
          : 'local_${item.id}';
      batch.set(database.collection('lancamentos').doc(id), {
        ...item.toFirestore(),
        'criadoEm': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
    await preferences.remove(_legacyStorageKey);
  }

  Stream<List<Despesa>> observarMes(DateTime mes) {
    final inicio = DateTime(mes.year, mes.month);
    final fim = DateTime(mes.year, mes.month + 1);
    return _collection
        .where('data', isGreaterThanOrEqualTo: Timestamp.fromDate(inicio))
        .where('data', isLessThan: Timestamp.fromDate(fim))
        .orderBy('data', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Despesa.fromFirestore(doc.id, doc.data()))
            .toList());
  }

  Future<void> salvar(Despesa despesa) async {
    if (despesa.id.isEmpty) {
      await _collection.add({
        ...despesa.toFirestore(),
        'criadoEm': FieldValue.serverTimestamp(),
      });
      return;
    }
    await _collection.doc(despesa.id).set(
          despesa.toFirestore(),
          SetOptions(merge: true),
        );
  }

  Future<void> excluir(String id) => _collection.doc(id).delete();
}
