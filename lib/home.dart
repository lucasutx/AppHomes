import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_shell.dart';
import 'app_theme.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  static final _instagram =
      Uri.parse('https://www.instagram.com/pizzaria_homes/');

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentIndex: 0,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const _Hero(),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 38, 20, 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pizza quentinha. Festa leve.',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Levamos a estrutura, preparamos tudo no local e cuidamos do serviço para você aproveitar cada momento.',
                      ),
                      const SizedBox(height: 24),
                      const _FeatureGrid(),
                      const SizedBox(height: 32),
                      const _PriceCard(),
                      const SizedBox(height: 22),
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            TextButton.icon(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/fotos'),
                              icon: const Icon(Icons.photo_library_outlined),
                              label: const Text('Ver fotos'),
                            ),
                            TextButton.icon(
                              onPressed: () => launchUrl(
                                _instagram,
                                mode: LaunchMode.externalApplication,
                              ),
                              icon: const Icon(Icons.camera_alt_outlined),
                              label: const Text('Instagram'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 600;
        return Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: compact ? 540 : 570),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/02.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: .32),
                  AppColors.ink.withValues(alpha: .96),
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, compact ? 24 : 34, 20, 42),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo_colorida.png',
                          height: compact ? 152 : 180,
                          fit: BoxFit.contain,
                          semanticLabel: "Home's Pizzaria",
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .12),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                                color: Colors.white.withValues(alpha: .22)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.location_on_outlined,
                                  color: AppColors.warm, size: 18),
                              SizedBox(width: 6),
                              Text(
                                'Pizzaria para eventos',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Rodízio de pizza onde sua festa acontece.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                color: Colors.white,
                                fontSize: compact ? 34 : 46,
                              ),
                        ),
                        const SizedBox(height: 14),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 660),
                          child: const Text(
                            'Pizzas preparadas na hora, equipe completa e tudo organizado para você curtir seus convidados.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFF1E8E1),
                              fontSize: 17,
                              height: 1.45,
                            ),
                          ),
                        ),
                        const SizedBox(height: 26),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            FilledButton.icon(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/orcamento'),
                              icon: const Icon(Icons.calculate_outlined),
                              label: const Text('Calcular orçamento'),
                            ),
                            OutlinedButton.icon(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/cardapio'),
                              icon: const Icon(Icons.local_pizza_outlined),
                              label: const Text('Ver cardápio'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white70),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid();

  @override
  Widget build(BuildContext context) {
    const cards = [
      _Feature(
        icon: Icons.local_pizza_outlined,
        title: 'Rodízio completo',
        text: 'Pizzas salgadas e doces preparadas durante o evento.',
      ),
      _Feature(
        icon: Icons.outdoor_grill_outlined,
        title: 'Tudo no local',
        text: 'Forno, ingredientes, gás e equipe para servir seus convidados.',
      ),
      _Feature(
        icon: Icons.receipt_long_outlined,
        title: 'Orçamento na hora',
        text: 'Simule o valor e gere um PDF profissional em poucos passos.',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 700) {
          return Column(
            children: [
              cards[0],
              const SizedBox(height: 12),
              cards[1],
              const SizedBox(height: 12),
              cards[2],
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: cards[0]),
            const SizedBox(width: 12),
            Expanded(child: cards[1]),
            const SizedBox(width: 12),
            Expanded(child: cards[2]),
          ],
        );
      },
    );
  }
}

class _PriceCard extends StatelessWidget {
  const _PriceCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.green,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 590;
            const copy = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'A partir de R\$ 45 por pessoa',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 6),
                Text(
                  'Deslocamento e garçons calculados conforme a região e o número de convidados.',
                  style: TextStyle(color: Color(0xFFD5E9DB), height: 1.4),
                ),
              ],
            );
            final action = FilledButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/orcamento'),
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text('Simular agora'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.green,
              ),
            );

            if (compact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [copy, const SizedBox(height: 20), action],
              );
            }
            return Row(
              children: [
                const Expanded(child: copy),
                const SizedBox(width: 24),
                action,
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  const _Feature({required this.icon, required this.title, required this.text});

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.red.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.red),
            ),
            const SizedBox(height: 18),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 7),
            Text(text),
          ],
        ),
      ),
    );
  }
}
