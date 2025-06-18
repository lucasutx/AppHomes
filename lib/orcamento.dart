import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

class Orcamento extends StatefulWidget {
  const Orcamento({super.key});

  @override
  State<Orcamento> createState() => _OrcamentoState();
}

class _OrcamentoState extends State<Orcamento> {
  final TextEditingController convidados = TextEditingController();
  bool? selecionado = false;

  final double precoPizza = 35.9;
  final double precoGarcom = 150;
  final double precoPizzaiolo = 150;
  final double deslocamento = 80;
  final double gas = 60;

  int garcom = 0;
  int garcomBebida = 0;
  int pizzaiolo = 0;
  double quantidadePizzas = 0;

  double subtotalPizza = 0;
  double subtotalGarcom = 0;
  double subtotalGarcomBebida = 0;
  double subtotalPizzaiolo = 0;

  int _indiceAtual = 2;

  void _navegar(int index) {
    setState(() {
      _indiceAtual = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/');
        break;
      case 1:
        Navigator.pushNamed(context, '/cardapio');
        break;
      case 2:
        break;
      case 3:
        Navigator.pushNamed(context, '/fotos');
        break;
      case 4:
        Navigator.pushNamed(context, '/funcionamento');
        break;
    }
  }

  void calcular(String convidadosStr) {
    int invites = int.tryParse(convidadosStr) ?? 0;

    if (invites < 30) {
      _showInvalidoDialog();
      return;
    }

    _definirServicos(invites);
    _calcularSubtotais(invites);

    double calculoFinal = subtotalPizza +
        subtotalGarcom +
        subtotalGarcomBebida +
        subtotalPizzaiolo +
        deslocamento +
        gas;

    if (selecionado == true) {
      _showResultadoDialogBebida(calculoFinal);
    } else {
      _showResultadoDialog(calculoFinal);
    }
  }

  void _definirServicos(int invites) {
    if (selecionado == false) {
      _atribuirGarcons(invites, bebida: false);
    } else {
      _atribuirGarcons(invites, bebida: true);
    }
  }

  void _atribuirGarcons(int invites, {required bool bebida}) {
    if (invites <= 45) {
      garcom = 1;
      pizzaiolo = 1;
      garcomBebida = bebida ? 1 : 0;
    } else if (invites <= 80) {
      garcom = 2;
      pizzaiolo = 1;
      garcomBebida = bebida ? 2 : 0;
    } else if (invites <= 120) {
      garcom = 3;
      pizzaiolo = 2;
      garcomBebida = bebida ? 3 : 0;
    } else if (invites <= 160) {
      garcom = 4;
      pizzaiolo = 2;
      garcomBebida = bebida ? 4 : 0;
    } else if (invites <= 200) {
      garcom = 5;
      pizzaiolo = 3;
      garcomBebida = bebida ? 5 : 0;
    } else if (invites <= 250) {
      garcom = 6;
      pizzaiolo = 3;
      garcomBebida = bebida ? 6 : 0;
    } else {
      garcom = 7;
      pizzaiolo = 4;
      garcomBebida = bebida ? 7 : 0;
    }
  }

  void _calcularSubtotais(int invites) {
    quantidadePizzas = (invites * 6 / 8).ceilToDouble();
    if (quantidadePizzas % 2 != 0) {
      quantidadePizzas += 1;
    }

    // Calcula os subtotais
    subtotalPizza = quantidadePizzas * precoPizza;
    subtotalGarcom = garcom * precoGarcom;
    subtotalGarcomBebida = garcomBebida * precoGarcom;
    subtotalPizzaiolo = pizzaiolo * precoPizzaiolo;
  }

 // Função para gerar o PDF com as cores do app
  Future<void> gerarPDF() async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Center( // Centraliza o conteúdo
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Container(
                padding: pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#800000'), // Cor de fundo vermelha
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Text(
                  'Orçamento Pizzaria',
                  style: pw.TextStyle(fontSize: 30, color: PdfColors.white),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Número de Convidados: ${convidados.text}', style: pw.TextStyle(fontSize: 18, color: PdfColors.black)),
              pw.SizedBox(height: 10),
              pw.Text('Quantidade de Pizzas: ${quantidadePizzas.toStringAsFixed(0)}', style: pw.TextStyle(fontSize: 18, color: PdfColors.black)),
              pw.SizedBox(height: 10),
              pw.Text('Subtotal Pizza: R\$${subtotalPizza.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 18, color: PdfColors.black)),
              pw.SizedBox(height: 10),
              pw.Text('Garçom(s): $garcom', style: pw.TextStyle(fontSize: 18, color: PdfColors.black)),
              pw.SizedBox(height: 10),
              pw.Text('Subtotal Garçom: R\$${subtotalGarcom.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 18, color: PdfColors.black)),
              pw.SizedBox(height: 10),
              pw.Text('Pizzaiolo(s): $pizzaiolo', style: pw.TextStyle(fontSize: 18, color: PdfColors.black)),
              pw.SizedBox(height: 10),
              pw.Text('Subtotal Pizzaiolo: R\$${subtotalPizzaiolo.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 18, color: PdfColors.black)),
              pw.SizedBox(height: 10),
              pw.Text('Deslocamento: R\$${deslocamento.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 18, color: PdfColors.black)),
              pw.SizedBox(height: 10),
              pw.Text('Gás: R\$${gas.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 18, color: PdfColors.black)),
              pw.SizedBox(height: 20),
              pw.Divider(color: PdfColors.black), // Linha separadora
              pw.SizedBox(height: 20),
              pw.Text('Custo Total: R\$ ${(subtotalPizza + subtotalGarcom + subtotalPizzaiolo + deslocamento + gas).toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#800000'))),
            ],
          ),
        );
      },
    ));

    // Salva o PDF como arquivo
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/orcamento.pdf");
    await file.writeAsBytes(await pdf.save());
    Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(14.0),
                color: const Color(0xFF800000),
              ),
              SizedBox(height: 90),
              Text(
                'ORÇAMENTO',
                style: GoogleFonts.gloriaHallelujah(
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 90),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 223, 223, 223)),
                  child: TextField(
                    controller: convidados,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                      labelText: 'Insira o número de convidados',
                      labelStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(color: Colors.black),
                    cursorColor: Color(0xFF800000),
                    maxLength: 3,
                    maxLengthEnforcement: MaxLengthEnforcement.none,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Gostaria de Garçom para bebidas?',
                      style: GoogleFonts.robotoCondensed(
                          color: Colors.black, fontSize: 16),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: selecionado,
                          activeColor: const Color(0xFF800000),
                          onChanged: (valor) =>
                              setState(() => selecionado = valor),
                        ),
                        const Text('Sim'),
                        Checkbox(
                          value: !selecionado!,
                          activeColor: const Color(0xFF800000),
                          onChanged: (valor) =>
                              setState(() => selecionado = !valor!),
                        ),
                        const Text('Não'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        calcular(convidados.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF800000),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Calcular',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: _navegar,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF800000),
        unselectedItemColor: const Color(0xFF800000),
        selectedLabelStyle: const TextStyle(fontSize: 14),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        iconSize: 30,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu), label: 'Cardápio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.payment), label: 'Orçamento'),
          BottomNavigationBarItem(icon: Icon(Icons.photo), label: 'Fotos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: 'Funcionamento'),
        ],
      ),
    );
  }

  Widget _infoBox() {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.amber[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.info, color: Colors.white),
          const SizedBox(width: 5),
          const Expanded(
            child: Text(
              ' Caso queria alguma mudança,\n falar com o contratante',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _linha(String descricao, double subtotal) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.done, color: Colors.green),
            Expanded(
                child:
                    Text(descricao, style: const TextStyle(fontSize: 18)))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.arrow_forward, color: Colors.green),
            Text(' SubTotal: R\$${subtotal.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18))
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  void _showResultadoDialog(double total) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Valor do Orçamento',
            style: GoogleFonts.gloriaHallelujah(fontSize: 25)),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _infoBox(),
              const SizedBox(height: 15),
              _linha(
                  '${quantidadePizzas.toStringAsFixed(0)} pizzas à R\$${precoPizza.toStringAsFixed(2)}',
                  subtotalPizza),
              _linha(
                  '$garcom garçom(s) exclusivos para pizza à R\$${precoGarcom.toStringAsFixed(2)}',
                  subtotalGarcom),
              _linha(
                  '$pizzaiolo pizzaiolo(s) à R\$${precoPizzaiolo.toStringAsFixed(2)}',
                  subtotalPizzaiolo),
              Row(
                children: [
                  const Icon(Icons.done, color: Colors.green),
                  const Text(' Deslocamento à R\$80.00',
                      style: TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.done, color: Colors.green),
                  const Text(' Gás à R\$50.00',
                      style: TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 20),
              Text('O custo total é de:', style: const TextStyle(fontSize: 18)),
              Text('R\$ ${total.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 23, color: Colors.green)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
                      onPressed: gerarPDF,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF800000),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Gerar PDF',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
        ],
      ),
    );
  }

  void _showResultadoDialogBebida(double total) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Valor do Orçamento',
            style: GoogleFonts.gloriaHallelujah(fontSize: 25)),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _infoBox(),
              const SizedBox(height: 15),
              _linha(
                  '${quantidadePizzas.toStringAsFixed(0)} pizzas à R\$${precoPizza.toStringAsFixed(2)}',
                  subtotalPizza),
              _linha(
                  '$garcom garçom(s) exclusivos para pizza à R\$${precoGarcom.toStringAsFixed(2)}',
                  subtotalGarcom),
              _linha(
                  '$garcomBebida garçom(s) exclusivos para bebida à R\$${precoGarcom.toStringAsFixed(2)}',
                  subtotalGarcomBebida),
              _linha(
                  '$pizzaiolo pizzaiolo(s) à R\$${precoPizzaiolo.toStringAsFixed(2)}',
                  subtotalPizzaiolo),
              Row(
                children: [
                  const Icon(Icons.done, color: Colors.green),
                  const Text(' Deslocamento à R\$80.00',
                      style: TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.done, color: Colors.green),
                  const Text(' Gás à R\$50.00',
                      style: TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 20),
              Text('O custo total é de:', style: const TextStyle(fontSize: 18)),
              Text('R\$ ${total.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 23, color: Colors.green)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.black,),
            ),
          ),
          ElevatedButton(
                      onPressed: gerarPDF,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF800000),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Gerar PDF',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
        ],
      ),
    );
  }

  void _showInvalidoDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Valor do Orçamento',
            style: GoogleFonts.gloriaHallelujah(fontSize: 25)),
        content: const Text('O evento é no mínimo para 30 pessoas',
            style: TextStyle(fontSize: 17)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Color(0xFF800000))),
          ),

        ],
      ),
    );
  }
}
