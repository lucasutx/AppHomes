import 'package:cloud_firestore/cloud_firestore.dart';

enum TipoLancamento {
  entrada('Entrada'),
  despesa('Despesa');

  const TipoLancamento(this.label);
  final String label;

  static TipoLancamento fromName(String? name) => values.firstWhere(
        (tipo) => tipo.name == name,
        orElse: () => TipoLancamento.despesa,
      );
}

enum CategoriaDespesa {
  eventos('Eventos'),
  ingredientes('Ingredientes'),
  bebidas('Bebidas'),
  equipe('Equipe'),
  transporte('Transporte'),
  equipamentos('Equipamentos'),
  marketing('Marketing'),
  taxas('Taxas'),
  outros('Outros');

  const CategoriaDespesa(this.label);

  final String label;

  static CategoriaDespesa fromName(String? name) => values.firstWhere(
        (categoria) => categoria.name == name,
        orElse: () => CategoriaDespesa.outros,
      );
}

class Despesa {
  const Despesa({
    required this.id,
    required this.descricao,
    required this.valor,
    required this.categoria,
    required this.data,
    this.tipo = TipoLancamento.despesa,
    this.observacao = '',
  });

  final String id;
  final String descricao;
  final double valor;
  final CategoriaDespesa categoria;
  final DateTime data;
  final TipoLancamento tipo;
  final String observacao;

  Map<String, Object?> toFirestore() => {
        'descricao': descricao,
        'valor': valor,
        'tipo': tipo.name,
        'categoria': categoria.name,
        'data': Timestamp.fromDate(data),
        'observacao': observacao,
        'atualizadoEm': FieldValue.serverTimestamp(),
      };

  factory Despesa.fromFirestore(String id, Map<String, dynamic> data) {
    final rawDate = data['data'];
    return Despesa(
      id: id,
      descricao: (data['descricao'] as String?) ?? 'Sem descrição',
      valor: (data['valor'] as num?)?.toDouble() ?? 0,
      tipo: TipoLancamento.fromName(data['tipo'] as String?),
      categoria: CategoriaDespesa.fromName(data['categoria'] as String?),
      data: rawDate is Timestamp ? rawDate.toDate() : DateTime.now(),
      observacao: (data['observacao'] as String?) ?? '',
    );
  }

  factory Despesa.fromLocalJson(Map<String, dynamic> data) => Despesa(
        id: (data['id'] as String?) ?? '',
        descricao: (data['descricao'] as String?) ?? 'Sem descrição',
        valor: (data['valor'] as num?)?.toDouble() ?? 0,
        tipo: TipoLancamento.fromName(data['tipo'] as String?),
        categoria: CategoriaDespesa.fromName(data['categoria'] as String?),
        data: DateTime.tryParse((data['data'] as String?) ?? '') ??
            DateTime.now(),
        observacao: (data['observacao'] as String?) ?? '',
      );

  Despesa copyWith({
    String? id,
    String? descricao,
    double? valor,
    CategoriaDespesa? categoria,
    DateTime? data,
    TipoLancamento? tipo,
    String? observacao,
  }) =>
      Despesa(
        id: id ?? this.id,
        descricao: descricao ?? this.descricao,
        valor: valor ?? this.valor,
        categoria: categoria ?? this.categoria,
        data: data ?? this.data,
        tipo: tipo ?? this.tipo,
        observacao: observacao ?? this.observacao,
      );
}

class ResumoDespesas {
  ResumoDespesas(List<Despesa> despesas)
      : total = despesas
            .where((item) => item.tipo == TipoLancamento.despesa)
            .fold(0, (soma, item) => soma + item.valor),
        totalEntradas = despesas
            .where((item) => item.tipo == TipoLancamento.entrada)
            .fold(0, (soma, item) => soma + item.valor),
        quantidade = despesas.length,
        porCategoria = {
          for (final categoria in CategoriaDespesa.values)
            categoria: despesas
                .where((item) =>
                    item.tipo == TipoLancamento.despesa &&
                    item.categoria == categoria)
                .fold(0, (soma, item) => soma + item.valor),
        };

  final double total;
  final double totalEntradas;
  final int quantidade;
  final Map<CategoriaDespesa, double> porCategoria;

  double get media => quantidade == 0 ? 0 : total / quantidade;
  double get saldo => totalEntradas - total;

  MapEntry<CategoriaDespesa, double>? get maiorCategoria {
    final items = porCategoria.entries.where((item) => item.value > 0).toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return items.isEmpty ? null : items.first;
  }
}
