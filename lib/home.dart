import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _indiceAtual = 0;

  final Uri numero = Uri.parse('https://wa.me/553195396402');
  final Uri instagram = Uri.parse('https://www.instagram.com/pizzaria_homes/');

  // Telas que vão ser chamadas
  final List<Widget> _telas = [
    Center(child: Text('Página Inicial')),
    Center(child: Text('Cardápio')),
    Center(child: Text('Orçamento')),
    Center(child: Text('Fotos')),
    Center(child: Text('Funcionamento')),
  ];

  // Navegação por nome das rotas
  void _navegar(int index) {
    setState(() {
      _indiceAtual = index;
    });

    switch (index) {
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
        Navigator.pushNamed(context, '/funcionamento');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 146, 1, 1),
      
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100),
            Image.asset(
              'assets/images/logo.png',
              width: MediaQuery.of(context).size.width * 0.6,
              color: Colors.white,
            ),
            const SizedBox(height: 150),
            Text(
              'Rodízio De Pizza',
              style: GoogleFonts.gloriaHallelujah(
                color: Colors.white,
                fontSize: 35,
                wordSpacing: 7,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => launchUrl(numero),
                  icon: const Icon(Icons.call,
                      color: Color.fromARGB(204, 20, 153, 49)),
                  label: const Text(
                    'WhatsApp',
                    style: TextStyle(
                        color: Color.fromARGB(204, 20, 153, 49),
                        fontStyle: FontStyle.italic,
                        fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => launchUrl(instagram),
                  icon: Image.asset('assets/images/icon.png',
                      width: 30, color: Colors.pink[900]),
                  label: Text(
                    'Instagram',
                    style: TextStyle(
                        color: Colors.pink[800],
                        fontStyle: FontStyle.italic,
                        fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 30),
            
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        selectedItemColor: const Color(0xFF800000),
        unselectedItemColor: Colors.grey[400],
        backgroundColor: Colors.white,
        onTap: _navegar,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu), label: 'Cardápio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.payment), label: 'Orçamento'),
          BottomNavigationBarItem(
              icon: Icon(Icons.photo), label: 'Fotos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: 'Funcionamento'),
        ],
      ),
    );
  }
}
