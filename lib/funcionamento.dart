import 'package:flutter/material.dart';
import 'app_shell.dart';
import 'app_theme.dart';

class Funcionamento extends StatelessWidget {
  const Funcionamento({super.key});

  static const faqs = [
    (
      'Como as pizzas são servidas?',
      'Servimos as fatias em guardanapos próprios, já incluídos. Se preferir pratos e talheres, eles devem ser fornecidos pelo contratante.'
    ),
    (
      'O que a Home’s leva?',
      'Levamos massas, ingredientes, forno, gás, utensílios, guardanapos e toda a estrutura necessária para preparar e servir as pizzas.'
    ),
    (
      'Como funciona a equipe?',
      'O orçamento inclui um garçom a cada 50 convidados. A quantidade é calculada automaticamente para manter o atendimento ágil.'
    ),
    (
      'Quanto tempo dura o evento?',
      'O serviço tem duração de até 4 horas a partir do início do rodízio. A equipe chega antes para organizar a estrutura.'
    ),
    (
      'Qual é a forma de pagamento?',
      'A forma de pagamento e a reserva da data são confirmadas diretamente com a equipe pelo WhatsApp.'
    ),
  ];

  @override
  Widget build(BuildContext context) => AppShell(
        currentIndex: 4,
        child: CustomScrollView(slivers: [
          const SliverToBoxAdapter(
              child: PageHeader(
                  eyebrow: 'Do forno à mesa',
                  title: 'Como funciona',
                  subtitle:
                      'Você cuida dos convidados. A gente leva a pizzaria até o seu evento.')),
          SliverToBoxAdapter(
              child: Center(
                  child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 42),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Uma experiência completa',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 10),
                    const Text(
                        'As massas chegam pré-assadas, e as pizzas são montadas e finalizadas no local. Assim, cada sabor chega quentinho aos seus convidados.'),
                    const SizedBox(height: 26),
                    const _Step(
                        number: '01',
                        title: 'Você simula',
                        text:
                            'Escolhe a região e informa o número de pessoas para receber o valor estimado.'),
                    const _Step(
                        number: '02',
                        title: 'A gente confirma',
                        text:
                            'Alinhamos data, endereço, horário e detalhes do evento pelo WhatsApp.'),
                    const _Step(
                        number: '03',
                        title: 'Levamos tudo',
                        text:
                            'Nossa equipe chega com antecedência para montar forno, ingredientes e área de serviço.'),
                    const _Step(
                        number: '04',
                        title: 'O rodízio começa',
                        text:
                            'Preparamos pizzas salgadas e doces no local por até quatro horas de evento.'),
                    const SizedBox(height: 30),
                    Text('Dúvidas frequentes',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 14),
                    ...faqs.map((item) => Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ExpansionTile(
                            tilePadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            childrenPadding:
                                const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            iconColor: AppColors.red,
                            title: Text(item.$1,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800)),
                            children: [
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(item.$2))
                            ],
                          ),
                        )),
                    const SizedBox(height: 18),
                    SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/orcamento'),
                            icon: const Icon(Icons.calculate_outlined),
                            label: const Text('Fazer meu orçamento'))),
                  ]),
            ),
          ))),
        ]),
      );
}

class _Step extends StatelessWidget {
  const _Step({required this.number, required this.title, required this.text});
  final String number;
  final String title;
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Card(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: 48,
                          height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: AppColors.red,
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(number,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900))),
                      const SizedBox(width: 16),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(title,
                                style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 5),
                            Text(text)
                          ])),
                    ]))),
      );
}
