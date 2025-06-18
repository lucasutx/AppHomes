import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Funcionamento extends StatefulWidget {
  const Funcionamento({Key? key}) : super(key: key);

  @override
  State<Funcionamento> createState() => _FuncionamentoState();
}

class _FuncionamentoState extends State<Funcionamento> {
  int _indiceAtual = 4; // Página atual: Funcionamento

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
        Navigator.pushNamed(context, '/orcamento');
        break;
      case 3:
        Navigator.pushNamed(context, '/fotos');
        break;
      case 4:
        // Tela atual
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(14.0),
              color: const Color(0xFF800000),
              child: Text(
                'Funcionamento',
                style: GoogleFonts.gloriaHallelujah(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resumo',
                      style: GoogleFonts.gloriaHallelujah(
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildCard(
                      'A HOME´S PIZZARIA LEVA PARA SEU EVENTO TODA A ESTRUTURA PARA REALIZAR UM TRABALHO DE QUALIDADE PARA VOCÊ E SEUS CONVIDADOS.\n\nLEVAMOS AS MASSAS PRÉ-ASSADAS, MONTAMOS E ASSAMOS AS PIZZAS NO LOCAL PARA SER SERVIDAS.\n\nTAMBÉM LEVAMOS TODOS OS INGREDIENTES PARA FAZER TODOS OS SABORES, CONFORME O CÁRDAPIO.',
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Perguntas frequentes',
                      style: GoogleFonts.gloriaHallelujah(
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildQuestion(
                      'COMO AS PIZZAS SÃO\nSERVIDAS?',
                      'AS PIZZAS SERÃO SERVIDAS EM GUARDANAPOS ESPECIAIS, QUE JÁ ESTÃO INCLUSOS NO ORÇAMENTO.\nPODENDO TAMBÉM SEREM SERVIDAS EM PRATOS E TALHERES, QUE DEVERÃO SER FORNECIDOS PELO CONTRATANTE.',
                    ),
                    _buildQuestion(
                      'O QUE LEVAMOS PARA O\nEVENTO?',
                      'LEVAMOS PARA O EVENTO TODO O MATERIAL NECESSÁRIO PARA A REALIZAÇÃO DO MESMO, COMO FORNO PARA ASSAR, GÁS, GUARDANAPOS, ETC.',
                    ),
                    _buildQuestion(
                      'O QUE OS GARÇONS PODEM\nSERVIR?',
                      'OS GARÇONS SÃO EXCLUSIVOS PARA SERVIR AS PIZZAS. CASO QUEIRA, PODEM SER CONTRATADOS GARÇONS PARA BEBIDAS À PARTE.',
                    ),
                    _buildQuestion(
                      'SÃO LEVADAS PIZZAS\nRESERVAS?',
                      'SIM, LEVAMOS 10 PIZZAS A MAIS PARA RESERVA. CASO SEJAM UTILIZADAS, SERÁ COBRADO À PARTE R\$35,90 CADA. AS PIZZAS NÃO UTILIZADAS SERÃO EMBALADAS E ENTREGUES PARA O CONTRATANTE.',
                    ),
                    _buildQuestion(
                      'QUANTAS HORAS DE EVENTO?',
                      'SÃO 4 HORAS DE EVENTO A PARTIR DO MOMENTO EM QUE COMEÇAMOS A SERVIR. CHEGAMOS COM 1 HORA DE ANTECEDÊNCIA PARA MONTAGEM.',
                    ),
                    _buildQuestion(
                      'QUAIS AS FORMAS DE PAGAMENTO?',
                      'O PAGAMENTO DEVE SER REALIZADO APÓS O EVENTO POR PIX, DINHEIRO OU CARTÃO (COM ACRÉSCIMO DA TAXA DA MAQUININHA DE APROXIMADAMENTE 4%).',
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _gerarPDF();
                      },
                      child: const Text('Gerar PDF'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: const Color(0xFF800000),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Orçamento'),
          BottomNavigationBarItem(icon: Icon(Icons.photo), label: 'Fotos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: 'Funcionamento'),
        ],
      ),
    );
  }

  Widget _buildCard(String text) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildQuestion(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.arrow_right, color: Color(0xFF800000)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  question,
                  style: GoogleFonts.leagueSpartan(
                    color: const Color(0xFF800000),
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            answer,
            style: GoogleFonts.leagueSpartan(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _gerarPDF() async {
    final pdf = pw.Document();

    // Adicionando a primeira página
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text(
                'Home´s Pizzaria',
                style: pw.TextStyle(
                  fontSize: 30,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('#800000'),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Resumo',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('#000000'),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'A HOME´S PIZZARIA LEVA PARA SEU EVENTO TODA A ESTRUTURA PARA REALIZAR UM TRABALHO DE QUALIDADE PARA VOCÊ E SEUS CONVIDADOS.\n\nLEVAMOS AS MASSAS PRÉ-ASSADAS, MONTAMOS E ASSAMOS AS PIZZAS NO LOCAL PARA SER SERVIDAS.\n\nTAMBÉM LEVAMOS TODOS OS INGREDIENTES PARA FAZER TODOS OS SABORES, CONFORME O CÁRDAPIO.',
                style: pw.TextStyle(
                  fontSize: 14,
                  color: PdfColor.fromHex('#000000'),
                ),
              ),
              // Adicionando perguntas frequentes ao PDF
              pw.SizedBox(height: 20),
              pw.Text('Perguntas frequentes', style: pw.TextStyle(fontSize: 20)),
              
              pw.SizedBox(height: 20),
              pw.Text('COMO AS PIZZAS SÃO SERVIDAS?', style: pw.TextStyle(fontSize: 16)),
              pw.Text('AS PIZZAS SERÃO SERVIDAS EM GUARDANAPOS ESPECIAIS, QUE JÁ ESTÃO INCLUSOS NO ORÇAMENTO.\nPODENDO TAMBÉM SEREM SERVIDAS EM PRATOS E TALHERES, QUE DEVERÃO SER FORNECIDOS PELO CONTRATANTE.', style: pw.TextStyle(fontSize: 14)),
              
              pw.SizedBox(height: 20),
              pw.Text('O QUE LEVAMOS PARA O EVENTO?', style: pw.TextStyle(fontSize: 16)),
              pw.Text('LEVAMOS PARA O EVENTO TODO O MATERIAL NECESSÁRIO PARA A REALIZAÇÃO DO MESMO, COMO FORNO PARA ASSAR, GÁS, GUARDANAPOS, ETC.', style: pw.TextStyle(fontSize: 14)),
              
              pw.SizedBox(height: 20),
              pw.Text('O QUE OS GARÇONS PODEM\nSERVIR?', style: pw.TextStyle(fontSize: 16)),
              pw.Text('OS GARÇONS SÃO EXCLUSIVOS PARA SERVIR AS PIZZAS. CASO QUEIRA, PODEM SER CONTRATADOS GARÇONS PARA BEBIDAS À PARTE.', style: pw.TextStyle(fontSize: 14)),
              
              
            
              
            ],
          );
        },
      ),
    );

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text(
                'Home´s Pizzaria',
                style: pw.TextStyle(
                  fontSize: 30,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('#800000'),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text('SÃO LEVADAS PIZZAS\nRESERVAS?', style: pw.TextStyle(fontSize: 16)),
              pw.Text('SIM, LEVAMOS 10 PIZZAS A MAIS PARA RESERVA. CASO SEJAM UTILIZADAS, SERÁ COBRADO À PARTE R\$35,90 CADA. AS PIZZAS NÃO UTILIZADAS SERÃO EMBALADAS E ENTREGUES PARA O CONTRATANTE.', style: pw.TextStyle(fontSize: 14)),

              
              pw.SizedBox(height: 20),
              pw.Text('QUANTAS HORAS DE EVENTO?', style: pw.TextStyle(fontSize: 16)),
              pw.Text('SÃO 4 HORAS DE EVENTO A PARTIR DO MOMENTO EM QUE COMEÇAMOS A SERVIR. CHEGAMOS COM 1 HORA DE ANTECEDÊNCIA PARA MONTAGEM.', style: pw.TextStyle(fontSize: 14)),
            
              
              pw.SizedBox(height: 20),
              pw.Text('QUAIS AS FORMAS DE PAGAMENTO?', style: pw.TextStyle(fontSize: 16)),
              pw.Text('O PAGAMENTO DEVE SER REALIZADO APÓS O EVENTO POR PIX, DINHEIRO OU CARTÃO (COM ACRÉSCIMO DA TAXA DA MAQUININHA DE APROXIMADAMENTE 4%).', style: pw.TextStyle(fontSize: 14)),
            ],
          );
        },
      ),
    );

    // Gerar o PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
