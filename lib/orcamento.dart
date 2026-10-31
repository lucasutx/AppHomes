import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'app_shell.dart';
import 'app_theme.dart';
import 'orcamento_calculator.dart';

class Orcamento extends StatefulWidget {
  const Orcamento({super.key});
  @override
  State<Orcamento> createState() => _OrcamentoState();
}

class _OrcamentoState extends State<Orcamento> {
  final _formKey = GlobalKey<FormState>();
  final _convidados = TextEditingController(text: '50');
  final _cliente = TextEditingController();
  final _dataEvento = TextEditingController();
  RegiaoEvento _regiao = RegiaoEvento.proximidades;
  OrcamentoResultado? _resultado;

  @override
  void dispose() {
    _convidados.dispose();
    _cliente.dispose();
    _dataEvento.dispose();
    super.dispose();
  }

  String _moeda(num valor) {
    final partes = valor.toStringAsFixed(2).split('.');
    final chars = partes.first.split('').reversed.toList();
    final grupos = <String>[];
    for (var i = 0; i < chars.length; i += 3) {
      grupos.add(chars.skip(i).take(3).toList().reversed.join());
    }
    return 'R\$ ${grupos.reversed.join('.')},${partes.last}';
  }

  void _calcular() {
    if (!_formKey.currentState!.validate()) return;
    final convidados = int.parse(_convidados.text);
    setState(
        () => _resultado = OrcamentoCalculator.calcular(convidados, _regiao));
    FocusScope.of(context).unfocus();
  }

  Future<Uint8List> _criarPdf(PdfPageFormat format) async {
    final resultado = _resultado!;
    final logoBytes = await rootBundle.load('assets/images/logo_colorida.png');
    final logo = pw.MemoryImage(logoBytes.buffer.asUint8List());
    final pdf = pw.Document(
        title: "Orçamento - Home's Pizzaria", author: "Home's Pizzaria");
    final red = PdfColor.fromHex('#C6281C');
    final green = PdfColor.fromHex('#176A3B');
    final ink = PdfColor.fromHex('#241A17');
    final line = PdfColor.fromHex('#E9DED3');

    pw.Widget row(String label, String value, {bool strong = false}) =>
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 8),
          child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Expanded(
                    child: pw.Text(label,
                        style: pw.TextStyle(
                            color: ink,
                            fontSize: 11,
                            fontWeight: strong
                                ? pw.FontWeight.bold
                                : pw.FontWeight.normal))),
                pw.Text(value,
                    style: pw.TextStyle(
                        color: strong ? red : ink,
                        fontSize: strong ? 14 : 11,
                        fontWeight: strong
                            ? pw.FontWeight.bold
                            : pw.FontWeight.normal)),
              ]),
        );

    pdf.addPage(pw.Page(
      pageFormat: format,
      margin: const pw.EdgeInsets.all(36),
      build: (_) =>
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
          pw.Image(logo, width: 104, height: 104, fit: pw.BoxFit.contain),
          pw.SizedBox(width: 20),
          pw.Expanded(
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                pw.Text('ORÇAMENTO',
                    style: pw.TextStyle(
                        color: red,
                        fontSize: 11,
                        fontWeight: pw.FontWeight.bold,
                        letterSpacing: 2)),
                pw.SizedBox(height: 5),
                pw.Text("Home's Pizzaria",
                    style: pw.TextStyle(
                        color: ink,
                        fontSize: 25,
                        fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                pw.Text('Rodízio de pizza no seu evento',
                    style: const pw.TextStyle(
                        color: PdfColors.grey700, fontSize: 11)),
              ])),
        ]),
        pw.SizedBox(height: 26),
        pw.Container(
          padding: const pw.EdgeInsets.all(18),
          decoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#FFF8EC'),
              borderRadius: pw.BorderRadius.circular(10)),
          child: pw.Row(children: [
            pw.Expanded(
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                  pw.Text('CLIENTE',
                      style: pw.TextStyle(
                          color: PdfColors.grey700,
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 4),
                  pw.Text(
                      _cliente.text.trim().isEmpty
                          ? 'Não informado'
                          : _cliente.text.trim(),
                      style: pw.TextStyle(
                          color: ink,
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold)),
                ])),
            pw.Expanded(
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                  pw.Text('DATA DO EVENTO',
                      style: pw.TextStyle(
                          color: PdfColors.grey700,
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 4),
                  pw.Text(
                      _dataEvento.text.trim().isEmpty
                          ? 'A combinar'
                          : _dataEvento.text.trim(),
                      style: pw.TextStyle(
                          color: ink,
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold)),
                ])),
          ]),
        ),
        pw.SizedBox(height: 24),
        pw.Text('Detalhamento',
            style: pw.TextStyle(
                color: ink, fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 10),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: pw.BoxDecoration(
              border: pw.Border.all(color: line),
              borderRadius: pw.BorderRadius.circular(10)),
          child: pw.Column(children: [
            row('${resultado.convidados} pessoas x ${_moeda(OrcamentoCalculator.valorPorPessoa)}',
                _moeda(resultado.valorPessoas)),
            pw.Divider(color: line),
            row('${resultado.quantidadeGarcons} garçom(ns) x ${_moeda(OrcamentoCalculator.valorPorGarcom)}',
                _moeda(resultado.valorGarcons)),
            pw.Divider(color: line),
            row('Deslocamento', _moeda(resultado.regiao.deslocamento)),
            pw.Divider(color: line, thickness: 1.3),
            row('VALOR TOTAL', _moeda(resultado.total), strong: true),
          ]),
        ),
        pw.SizedBox(height: 22),
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(16),
          decoration: pw.BoxDecoration(
              color: green, borderRadius: pw.BorderRadius.circular(10)),
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('O que está incluído',
                    style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 13,
                        fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 8),
                pw.Text(
                    'Rodízio no local, ingredientes, massas, forno, gás, guardanapos e equipe calculada para o evento.',
                    style: const pw.TextStyle(
                        color: PdfColors.white, fontSize: 10, lineSpacing: 3)),
              ]),
        ),
        pw.Spacer(),
        pw.Divider(color: line),
        pw.SizedBox(height: 8),
        pw.Text(
            'Orçamento sujeito à confirmação de disponibilidade e dos dados do evento. Fale conosco para reservar a data.',
            style: const pw.TextStyle(
                color: PdfColors.grey700, fontSize: 8, lineSpacing: 2)),
        pw.SizedBox(height: 7),
        pw.Text('WhatsApp: (31) 9539-6402  |  Instagram: @pizzaria_homes',
            style: pw.TextStyle(
                color: red, fontSize: 9, fontWeight: pw.FontWeight.bold)),
      ]),
    ));
    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentIndex: 2,
      child: CustomScrollView(slivers: [
        const SliverToBoxAdapter(
            child: PageHeader(
                eyebrow: 'Simulação rápida',
                title: 'Monte seu orçamento',
                subtitle:
                    'Informe os dados do evento. O número de garçons é calculado automaticamente: um profissional a cada 50 pessoas.')),
        SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 980),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 42),
                child: LayoutBuilder(builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 760;
                  final form = _FormCard(
                    formKey: _formKey,
                    convidados: _convidados,
                    cliente: _cliente,
                    dataEvento: _dataEvento,
                    regiao: _regiao,
                    onRegiao: (value) => setState(() => _regiao = value),
                    onCalcular: _calcular,
                  );
                  final result = _ResultCard(
                      resultado: _resultado,
                      moeda: _moeda,
                      onPdf: _resultado == null
                          ? null
                          : () => Printing.layoutPdf(
                              onLayout: _criarPdf,
                              name: 'orcamento-homes-pizzaria.pdf'));
                  return wide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Expanded(child: form),
                              const SizedBox(width: 18),
                              Expanded(child: result)
                            ])
                      : Column(
                          children: [form, const SizedBox(height: 18), result]);
                }),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard(
      {required this.formKey,
      required this.convidados,
      required this.cliente,
      required this.dataEvento,
      required this.regiao,
      required this.onRegiao,
      required this.onCalcular});
  final GlobalKey<FormState> formKey;
  final TextEditingController convidados;
  final TextEditingController cliente;
  final TextEditingController dataEvento;
  final RegiaoEvento regiao;
  final ValueChanged<RegiaoEvento> onRegiao;
  final VoidCallback onCalcular;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Form(
              key: formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dados do evento',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 18),
                    TextFormField(
                        controller: convidados,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                            labelText: 'Número de convidados',
                            prefixIcon: Icon(Icons.groups_outlined)),
                        validator: (value) {
                          final numero = int.tryParse(value ?? '');
                          if (numero == null) {
                            return 'Informe o número de convidados';
                          }
                          if (numero < OrcamentoCalculator.minimoConvidados) {
                            return 'Mínimo de ${OrcamentoCalculator.minimoConvidados} pessoas';
                          }
                          return null;
                        }),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<RegiaoEvento>(
                        initialValue: regiao,
                        decoration: const InputDecoration(
                            labelText: 'Região do evento',
                            prefixIcon: Icon(Icons.location_on_outlined)),
                        items: RegiaoEvento.values
                            .map((item) => DropdownMenuItem(
                                value: item, child: Text(item.label)))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) onRegiao(value);
                        }),
                    const SizedBox(height: 14),
                    TextFormField(
                        controller: cliente,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                            labelText: 'Nome do cliente (opcional)',
                            prefixIcon: Icon(Icons.person_outline))),
                    const SizedBox(height: 14),
                    TextFormField(
                        controller: dataEvento,
                        decoration: const InputDecoration(
                            labelText: 'Data do evento (opcional)',
                            hintText: 'Ex.: 15/12/2026',
                            prefixIcon: Icon(Icons.calendar_today_outlined))),
                    const SizedBox(height: 18),
                    SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                            onPressed: onCalcular,
                            icon: const Icon(Icons.calculate_outlined),
                            label: const Text('Calcular orçamento'))),
                  ])),
        ),
      );
}

class _ResultCard extends StatelessWidget {
  const _ResultCard(
      {required this.resultado, required this.moeda, required this.onPdf});
  final OrcamentoResultado? resultado;
  final String Function(num) moeda;
  final VoidCallback? onPdf;

  @override
  Widget build(BuildContext context) {
    if (resultado == null) {
      return Card(
          child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(children: [
                Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                        color: AppColors.green.withValues(alpha: .1),
                        shape: BoxShape.circle),
                    child: const Icon(Icons.receipt_long_outlined,
                        color: AppColors.green, size: 34)),
                const SizedBox(height: 18),
                Text('Seu resumo aparece aqui',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                const Text(
                    'Preencha os dados ao lado para ver o valor detalhado.',
                    textAlign: TextAlign.center),
              ])));
    }
    final r = resultado!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('ORÇAMENTO ESTIMADO',
              style: TextStyle(
                  color: AppColors.green,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2)),
          const SizedBox(height: 7),
          Text(moeda(r.total),
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(color: AppColors.red)),
          const SizedBox(height: 22),
          _line(
              '${r.convidados} pessoas × ${moeda(OrcamentoCalculator.valorPorPessoa)}',
              moeda(r.valorPessoas)),
          _line(
              '${r.quantidadeGarcons} garçom(ns) × ${moeda(OrcamentoCalculator.valorPorGarcom)}',
              moeda(r.valorGarcons)),
          _line(
              'Deslocamento • ${r.regiao.label}', moeda(r.regiao.deslocamento)),
          const Divider(height: 30),
          const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.check_circle, color: AppColors.green, size: 20),
            SizedBox(width: 9),
            Expanded(
                child: Text(
                    'Inclui estrutura, ingredientes, forno, gás, guardanapos e serviço no local.'))
          ]),
          const SizedBox(height: 20),
          SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                  onPressed: onPdf,
                  icon: const Icon(Icons.picture_as_pdf_outlined),
                  label: const Text('Gerar orçamento em PDF'),
                  style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 54),
                      foregroundColor: AppColors.red,
                      side: const BorderSide(color: AppColors.red),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16))))),
          const SizedBox(height: 10),
          const Text(
              'Valor estimado. A reserva depende da confirmação da data e do endereço.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.muted)),
        ]),
      ),
    );
  }

  Widget _line(String label, String value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Text(label)),
        const SizedBox(width: 10),
        Text(value,
            style: const TextStyle(
                color: AppColors.ink, fontWeight: FontWeight.w800))
      ]));
}
