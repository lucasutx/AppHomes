import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Cardapio extends StatefulWidget {
  const Cardapio({Key? key}) : super(key: key);

  @override
  State<Cardapio> createState() => _CardapioState();
}

class _CardapioState extends State<Cardapio> {
  int _indiceAtual = 1;

  void _navegar(int index) {
    setState(() {
      _indiceAtual = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/');
        break;
      case 1:
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

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> photoUrls = [
      'assets/images/car2.jpg',
      'assets/images/car3.jpg',
      'assets/images/car1.jpg',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14.0),
              color: const Color(0xFF800000),
              
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: photoUrls.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _showFullScreenImage(context, photoUrls[index]);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: const Offset(2, 2))
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: AspectRatio(
                          aspectRatio: 3 / 5, // 🔥 Menor zoom que 16/9
                          child: Image.asset(
                            photoUrls[index],
                            fit: BoxFit.contain, // 🔥 Mostra a imagem inteira sem corte
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
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
          BottomNavigationBarItem(
              icon: Icon(Icons.payment), label: 'Orçamento'),
          BottomNavigationBarItem(icon: Icon(Icons.photo), label: 'Fotos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: 'Funcionamento'),
        ],
      ),
    );
  }
}
