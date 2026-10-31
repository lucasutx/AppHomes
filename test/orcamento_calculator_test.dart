import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/orcamento_calculator.dart';

void main() {
  group('OrcamentoCalculator', () {
    test('calcula 50 pessoas no Barreiro com um garçom', () {
      final resultado =
          OrcamentoCalculator.calcular(50, RegiaoEvento.proximidades);
      expect(resultado.quantidadeGarcons, 1);
      expect(resultado.valorPessoas, 2250);
      expect(resultado.valorGarcons, 150);
      expect(resultado.total, 2420);
    });

    test('calcula um garçom adicional acima de 50 pessoas', () {
      final resultado = OrcamentoCalculator.calcular(51, RegiaoEvento.contagem);
      expect(resultado.quantidadeGarcons, 2);
      expect(resultado.total, 2675);
    });

    test('usa deslocamento de 100 reais para Betim', () {
      final resultado = OrcamentoCalculator.calcular(100, RegiaoEvento.betim);
      expect(resultado.quantidadeGarcons, 2);
      expect(resultado.regiao.deslocamento, 100);
      expect(resultado.total, 4900);
    });

    test('rejeita evento com menos de 30 convidados', () {
      expect(() => OrcamentoCalculator.calcular(29, RegiaoEvento.igarape),
          throwsArgumentError);
    });
  });
}
