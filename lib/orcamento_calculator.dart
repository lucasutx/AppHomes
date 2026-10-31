import 'dart:math' as math;

enum RegiaoEvento {
  proximidades('Barreiro e proximidades', 20),
  contagem('Contagem', 80),
  betim('Betim', 100),
  igarape('Igarapé', 100);

  const RegiaoEvento(this.label, this.deslocamento);
  final String label;
  final double deslocamento;
}

class OrcamentoResultado {
  const OrcamentoResultado(
      {required this.convidados,
      required this.regiao,
      required this.quantidadeGarcons,
      required this.valorPessoas,
      required this.valorGarcons,
      required this.total});
  final int convidados;
  final RegiaoEvento regiao;
  final int quantidadeGarcons;
  final double valorPessoas;
  final double valorGarcons;
  final double total;
}

abstract final class OrcamentoCalculator {
  static const double valorPorPessoa = 45;
  static const double valorPorGarcom = 150;
  static const int pessoasPorGarcom = 50;
  static const int minimoConvidados = 30;

  static OrcamentoResultado calcular(int convidados, RegiaoEvento regiao) {
    if (convidados < minimoConvidados) {
      throw ArgumentError(
          'O evento deve ter pelo menos $minimoConvidados convidados.');
    }
    final garcons = math.max(1, (convidados / pessoasPorGarcom).ceil());
    final pessoas = convidados * valorPorPessoa;
    final valorGarcons = garcons * valorPorGarcom;
    return OrcamentoResultado(
      convidados: convidados,
      regiao: regiao,
      quantidadeGarcons: garcons,
      valorPessoas: pessoas,
      valorGarcons: valorGarcons,
      total: pessoas + valorGarcons + regiao.deslocamento,
    );
  }
}
