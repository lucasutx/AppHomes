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
        child: Column(children: [
          const _Hero(),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 34, 20, 48),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Seu evento, com sabor de casa.',
                          style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 10),
                      const Text(
                          'Levamos a estrutura, preparamos as pizzas no local e cuidamos do serviço para você aproveitar cada momento.'),
                      const SizedBox(height: 24),
                      LayoutBuilder(builder: (context, constraints) {
                        final wide = constraints.maxWidth >= 700;
                        final cards = [
                          const _Feature(
                              icon: Icons.local_pizza_outlined,
                              title: 'Rodízio completo',
                              text:
                                  'Pizzas salgadas e doces preparadas durante o evento.'),
                          const _Feature(
                              icon: Icons.outdoor_grill_outlined,
                              title: 'Tudo no local',
                              text:
                                  'Forno, ingredientes, gás e equipe para servir seus convidados.'),
                          const _Feature(
                              icon: Icons.receipt_long_outlined,
                              title: 'Orçamento na hora',
                              text:
                                  'Simule o valor e gere um PDF profissional em poucos passos.'),
                        ];
                        return wide
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: cards
                                    .map((card) => Expanded(
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 12),
                                            child: card)))
                                    .toList())
                            : Column(
                                children: cards
                                    .map((card) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 12),
                                        child: card))
                                    .toList());
                      }),
                      const SizedBox(height: 34),
                      Card(
                        color: AppColors.green,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Row(children: [
                            const Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Text('A partir de R\$ 45 por pessoa',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w900)),
                                  SizedBox(height: 6),
                                  Text(
                                      'Deslocamento e garçons calculados conforme região e número de convidados.',
                                      style: TextStyle(
                                          color: Color(0xFFD5E9DB),
                                          height: 1.4)),
                                ])),
                            const SizedBox(width: 16),
                            FilledButton.tonalIcon(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/orcamento'),
                              icon: const Icon(Icons.arrow_forward),
                              label: const Text('Simular'),
                              style: FilledButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.green),
                            ),
                          ]),
                        ),
                      ),
                      const SizedBox(height: 26),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton.icon(
                                onPressed: () => launchUrl(_instagram,
                                    mode: LaunchMode.externalApplication),
                                icon: const Icon(Icons.camera_alt_outlined),
                                label: const Text('Siga no Instagram')),
                          ]),
                    ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 580),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/02.jpg'), fit: BoxFit.cover),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: .42),
                AppColors.ink.withValues(alpha: .96)
              ]),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 30, 24, 46),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/logo_colorida.png',
                          height: 245, fit: BoxFit.contain),
                      const SizedBox(height: 20),
                      Text('Rodízio de pizza onde sua festa acontece.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(color: Colors.white)),
                      const SizedBox(height: 14),
                      const Text(
                          'Pizzas quentinhas, equipe preparada e uma experiência feita para reunir pessoas.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xFFF1E8E1),
                              fontSize: 17,
                              height: 1.45)),
                      const SizedBox(height: 26),
                      FilledButton.icon(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/orcamento'),
                          icon: const Icon(Icons.calculate_outlined),
                          label: const Text('Calcular orçamento')),
                    ]),
              ),
            ),
          ),
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: AppColors.red.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: AppColors.red)),
          const SizedBox(height: 18),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 7),
          Text(text),
        ]),
      ),
    );
  }
}
