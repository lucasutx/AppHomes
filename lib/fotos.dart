import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Fotos extends StatefulWidget {
  const Fotos({Key? key}) : super(key: key);

  @override
  State<Fotos> createState() => _FotosState();
}

class _FotosState extends State<Fotos> {
  int _indiceAtual = 3; // Página atual: Fotos

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
        // Tela atual: Fotos
        break;
      case 4:
        Navigator.pushNamed(context, '/funcionamento');
        break;
    }
  }

  final List<String> photoUrls = [
    'assets/images/01.jpg',
    'assets/images/02.jpg',
    'assets/images/03.jpg',
    'assets/images/04.jpg',
    'assets/images/05.jpg',
    'assets/images/06.jpg',
    'assets/images/07.jpg',
    'assets/images/08.jpg',
    'assets/images/09.jpg',
    'assets/images/10.jpg',
    'assets/images/11.jpg',
    'assets/images/12.jpg',
    'assets/images/13.jpg',
    'assets/images/14.jpg',
    'assets/images/15.jpg',
    'assets/images/16.jpg',
    'assets/images/17.jpg',
    'assets/images/18.jpg',
    'assets/images/20.jpg',
    'assets/images/21.jpg',
    'assets/images/22.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(221, 230, 230, 230),
      body: SafeArea(
        
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Container(
              padding: const EdgeInsets.all(14.0),
              color: const Color(0xFF800000),
              
            ),
            SizedBox(height: 0),
            Expanded(
              child: GridView.builder(
                itemCount: photoUrls.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _showFullScreenImage(context, photoUrls[index]);
                    },
                    child: Image.asset(
                      photoUrls[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
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
          BottomNavigationBarItem(
              icon: Icon(Icons.payment), label: 'Orçamento'),
          BottomNavigationBarItem(icon: Icon(Icons.photo), label: 'Fotos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: 'Funcionamento'),
        ],
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          backgroundColor: Colors.black,
          child: Stack(
            children: [
              InteractiveViewer(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(imageUrl),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
