import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/despesa_model.dart';

void main() {
  group('ResumoDespesas', () {
    final despesas = [
      Despesa(
        id: '1',
        descricao: 'Mussarela',
        valor: 300,
        categoria: CategoriaDespesa.ingredientes,
        data: DateTime(2026, 10, 1),
      ),
      Despesa(
        id: '2',
        descricao: 'Tomate',
        valor: 100,
        categoria: CategoriaDespesa.ingredientes,
        data: DateTime(2026, 10, 2),
      ),
      Despesa(
        id: '3',
        descricao: 'Combustível',
        valor: 200,
        categoria: CategoriaDespesa.transporte,
        data: DateTime(2026, 10, 3),
      ),
    ];

    test('calcula total, média e quantidade', () {
      final resumo = ResumoDespesas(despesas);

      expect(resumo.total, 600);
      expect(resumo.media, 200);
      expect(resumo.quantidade, 3);
    });

    test('agrupa valores e identifica a maior categoria', () {
      final resumo = ResumoDespesas(despesas);

      expect(resumo.porCategoria[CategoriaDespesa.ingredientes], 400);
      expect(resumo.porCategoria[CategoriaDespesa.transporte], 200);
      expect(resumo.maiorCategoria?.key, CategoriaDespesa.ingredientes);
    });

    test('não divide por zero quando a lista está vazia', () {
      final resumo = ResumoDespesas(const []);

      expect(resumo.total, 0);
      expect(resumo.media, 0);
      expect(resumo.maiorCategoria, isNull);
    });

    test('calcula entradas e saldo sem misturar com despesas', () {
      final resumo = ResumoDespesas([
        ...despesas,
        Despesa(
          id: '4',
          descricao: 'Evento da Maria',
          valor: 1500,
          tipo: TipoLancamento.entrada,
          categoria: CategoriaDespesa.eventos,
          data: DateTime(2026, 10, 10),
        ),
      ]);

      expect(resumo.totalEntradas, 1500);
      expect(resumo.total, 600);
      expect(resumo.saldo, 900);
    });
  });
}
