import 'package:flutter/material.dart';
import 'app_shell.dart';
import 'app_theme.dart';

class _Sabor {
  const _Sabor(this.nome, this.ingredientes, {this.doce = false});
  final String nome;
  final String ingredientes;
  final bool doce;
}

const _sabores = [
  _Sabor(
      'Calabresa', 'Molho, mussarela, calabresa fatiada, presunto e orégano'),
  _Sabor('Lombo canadense', 'Molho, lombo canadense, presunto e orégano'),
  _Sabor('Frango com catupiry',
      'Molho, mussarela, frango desfiado, catupiry e orégano'),
  _Sabor(
      'Caipira', 'Molho, mussarela, frango, bacon, cheddar, milho e orégano'),
  _Sabor('À moda',
      'Molho, mussarela, calabresa, presunto, cebola, tomate, pimentão, milho, azeitona e orégano'),
  _Sabor(
      '4 queijos', 'Molho, mussarela, catupiry, parmesão, cheddar e orégano'),
  _Sabor('Bacon', 'Molho, mussarela, bacon, milho e orégano'),
  _Sabor('4 carnes',
      'Molho, mussarela, presunto, calabresa, lombo canadense, bacon e orégano'),
  _Sabor('Alho-poró com bacon',
      'Molho, mussarela, alho-poró, bacon, catupiry, azeite e orégano'),
  _Sabor('Jiló com bacon',
      'Molho, mussarela, jiló, bacon, catupiry, azeite e orégano'),
  _Sabor('Marguerita',
      'Molho, mussarela, tomate, parmesão, azeite, manjericão e orégano'),
  _Sabor('Parmegiana',
      'Molho, mussarela, presunto, tomate, bacon, parmesão e orégano'),
  _Sabor('Presunto', 'Molho, mussarela, presunto, azeitona e orégano'),
  _Sabor('Napolitana', 'Molho, mussarela, presunto, tomate e orégano'),
  _Sabor('Alho-poró, bacon e abacaxi',
      'Molho, mussarela, alho-poró, bacon, abacaxi, azeite e orégano'),
  _Sabor('Lombo com abacaxi e barbecue',
      'Molho, mussarela, lombo canadense, presunto, abacaxi, barbecue, azeitona e orégano'),
  _Sabor('Banana', 'Mussarela, banana fatiada, leite condensado e canela',
      doce: true),
  _Sabor('Chocolate', 'Brigadeiro e granulado', doce: true),
  _Sabor('Romeu e Julieta', 'Mussarela e goiabada', doce: true),
  _Sabor('Duo chocolate', 'Brigadeiro e chocolate branco', doce: true),
];

class Cardapio extends StatefulWidget {
  const Cardapio({super.key});
  @override
  State<Cardapio> createState() => _CardapioState();
}

class _CardapioState extends State<Cardapio> {
  bool? _doces;
  String _busca = '';

  @override
  Widget build(BuildContext context) {
    final filtrados = _sabores.where((sabor) {
      final categoria = _doces == null || sabor.doce == _doces;
      final busca = sabor.nome.toLowerCase().contains(_busca.toLowerCase()) ||
          sabor.ingredientes.toLowerCase().contains(_busca.toLowerCase());
      return categoria && busca;
    }).toList();

    return AppShell(
      currentIndex: 1,
      child: CustomScrollView(slivers: [
        const SliverToBoxAdapter(
            child: PageHeader(
                eyebrow: 'Feito na hora',
                title: 'Nosso cardápio',
                subtitle:
                    'Sabores clássicos e combinações especiais para agradar todos os convidados.')),
        SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 14),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                          onChanged: (value) => setState(() => _busca = value),
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              hintText: 'Buscar sabor ou ingrediente')),
                      const SizedBox(height: 14),
                      Wrap(spacing: 8, runSpacing: 8, children: [
                        _Filter(
                            label: 'Todos',
                            selected: _doces == null,
                            onTap: () => setState(() => _doces = null)),
                        _Filter(
                            label: 'Salgadas',
                            selected: _doces == false,
                            onTap: () => setState(() => _doces = false)),
                        _Filter(
                            label: 'Doces',
                            selected: _doces == true,
                            onTap: () => setState(() => _doces = true)),
                      ]),
                      const SizedBox(height: 12),
                      Text(
                        filtrados.length == 1
                            ? '1 sabor encontrado'
                            : '${filtrados.length} sabores encontrados',
                        style: const TextStyle(
                            color: AppColors.muted,
                            fontWeight: FontWeight.w700),
                      ),
                    ]),
              ),
            ),
          ),
        ),
        if (filtrados.isEmpty)
          const SliverToBoxAdapter(child: _EmptyMenu())
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            sliver: SliverLayoutBuilder(builder: (context, constraints) {
              final count = constraints.crossAxisExtent >= 900
                  ? 3
                  : constraints.crossAxisExtent >= 580
                      ? 2
                      : 1;
              return SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: count,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    mainAxisExtent: 204),
                delegate: SliverChildBuilderDelegate(
                    (context, index) => _MenuCard(sabor: filtrados[index]),
                    childCount: filtrados.length),
              );
            }),
          ),
      ]),
    );
  }
}

class _Filter extends StatelessWidget {
  const _Filter(
      {required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.red.withValues(alpha: .15),
      labelStyle: TextStyle(
          color: selected ? AppColors.red : AppColors.muted,
          fontWeight: FontWeight.w700));
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.sabor});
  final _Sabor sabor;
  @override
  Widget build(BuildContext context) {
    final color = sabor.doce ? const Color(0xFFB5617A) : AppColors.green;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                    color: color.withValues(alpha: .11),
                    borderRadius: BorderRadius.circular(13)),
                child: Icon(
                    sabor.doce
                        ? Icons.cake_outlined
                        : Icons.local_pizza_outlined,
                    color: color)),
            const Spacer(),
            Text(sabor.doce ? 'DOCE' : 'SALGADA',
                style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1)),
          ]),
          const SizedBox(height: 15),
          Text(sabor.nome,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 7),
          Text(sabor.ingredientes,
              maxLines: 3, overflow: TextOverflow.ellipsis),
        ]),
      ),
    );
  }
}

class _EmptyMenu extends StatelessWidget {
  const _EmptyMenu();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 48),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                color: AppColors.muted,
                size: 30,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Nenhum sabor encontrado',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            const Text(
              'Tente outro ingrediente ou escolha uma categoria diferente.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
