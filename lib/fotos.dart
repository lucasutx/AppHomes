import 'package:flutter/material.dart';
import 'app_shell.dart';
import 'app_theme.dart';

class Fotos extends StatelessWidget {
  const Fotos({super.key});

  static const photos = [
    'assets/images/01.jpg',
    'assets/images/02.jpg',
    'assets/images/03.jpg',
    'assets/images/04.jpg',
    'assets/images/05.jpg',
    'assets/images/06.jpg',
    'assets/images/07.jpg',
    'assets/images/08.JPG',
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

  void _open(BuildContext context, String photo) {
    showDialog(
        context: context,
        barrierColor: Colors.black.withValues(alpha: .92),
        builder: (_) => Dialog.fullscreen(
              backgroundColor: Colors.black,
              child: SafeArea(
                  child: Stack(children: [
                Center(
                    child: InteractiveViewer(
                        minScale: .8,
                        maxScale: 4,
                        child: Image.asset(photo, fit: BoxFit.contain))),
                Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton.filled(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.ink))),
              ])),
            ));
  }

  @override
  Widget build(BuildContext context) => AppShell(
        currentIndex: 3,
        child: CustomScrollView(slivers: [
          const SliverToBoxAdapter(
              child: PageHeader(
                  eyebrow: 'Momentos reais',
                  title: 'Galeria de eventos',
                  subtitle:
                      'Um pouco do nosso trabalho, da preparação ao último pedaço servido.')),
          SliverPadding(
            padding: const EdgeInsets.all(14),
            sliver: SliverLayoutBuilder(builder: (context, constraints) {
              final count = constraints.crossAxisExtent >= 1000
                  ? 5
                  : constraints.crossAxisExtent >= 700
                      ? 4
                      : constraints.crossAxisExtent >= 430
                          ? 3
                          : 2;
              return SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: count,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8),
                delegate: SliverChildBuilderDelegate(
                    (context, index) => GestureDetector(
                          onTap: () => _open(context, photos[index]),
                          child: Hero(
                              tag: photos[index],
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: Image.asset(photos[index],
                                      fit: BoxFit.cover))),
                        ),
                    childCount: photos.length),
              );
            }),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ]),
      );
}
