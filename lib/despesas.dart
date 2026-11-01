import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_shell.dart';
import 'app_theme.dart';
import 'despesa_model.dart';
import 'despesas_repository.dart';

class Despesas extends StatefulWidget {
  const Despesas({super.key});

  @override
  State<Despesas> createState() => _DespesasState();
}

class _DespesasState extends State<Despesas> {
  final DespesasRepository _repository = DespesasRepository();
  DateTime _mes = DateTime(DateTime.now().year, DateTime.now().month);

  void _mudarMes(int deslocamento) {
    setState(() => _mes = DateTime(_mes.year, _mes.month + deslocamento));
  }

  Future<void> _abrirFormulario([Despesa? despesa]) async {
    final salva = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      builder: (_) => _DespesaForm(repository: _repository, despesa: despesa),
    );
    if (salva == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(despesa == null
              ? 'Lançamento cadastrado com sucesso.'
              : 'Lançamento atualizado com sucesso.'),
        ),
      );
    }
  }

  Future<void> _excluir(Despesa despesa) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir lançamento?'),
        content: Text(
          '${despesa.categoria.label} de ${_moeda(despesa.valor)} será removido permanentemente.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Excluir')),
        ],
      ),
    );
    if (confirmou != true || !mounted) return;
    try {
      await _repository.excluir(despesa.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lançamento excluído.')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Não foi possível excluir o lançamento.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentIndex: 6,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirFormulario,
        icon: const Icon(Icons.add),
        label: const Text('Novo lançamento'),
      ),
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: PageHeader(
              eyebrow: 'Controle financeiro',
              title: 'Financeiro',
              subtitle:
                  'Registre entradas de eventos e despesas para acompanhar o resultado do mês.',
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 110),
                  child: _conteudoConectado(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _conteudoConectado() {
    return Column(
      children: [
        _SeletorMes(
          mes: _mes,
          onAnterior: () => _mudarMes(-1),
          onProximo: () => _mudarMes(1),
        ),
        const SizedBox(height: 18),
        StreamBuilder<List<Despesa>>(
          stream: _repository.observarMes(_mes),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const _EstadoMensagem(
                icon: Icons.storage_outlined,
                titulo: 'Não foi possível carregar os lançamentos',
                texto: 'Confira a conexão com a internet e tente novamente.',
              );
            }
            if (!snapshot.hasData) {
              return const Padding(
                padding: EdgeInsets.all(48),
                child: CircularProgressIndicator(),
              );
            }
            final despesas = snapshot.data!;
            final resumo = ResumoDespesas(despesas);
            return Column(
              children: [
                _Indicadores(resumo: resumo),
                const SizedBox(height: 18),
                LayoutBuilder(builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 800;
                  final grafico = _GraficoCategorias(resumo: resumo);
                  final historico = _Historico(
                    despesas: despesas,
                    onEditar: _abrirFormulario,
                    onExcluir: _excluir,
                  );
                  if (!wide) {
                    return Column(children: [
                      grafico,
                      const SizedBox(height: 18),
                      historico,
                    ]);
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 4, child: grafico),
                      const SizedBox(width: 18),
                      Expanded(flex: 6, child: historico),
                    ],
                  );
                }),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _EstadoMensagem extends StatelessWidget {
  const _EstadoMensagem({
    required this.icon,
    required this.titulo,
    required this.texto,
  });

  final IconData icon;
  final String titulo;
  final String texto;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(36),
          child: Column(children: [
            Icon(icon, color: AppColors.green, size: 36),
            const SizedBox(height: 18),
            Text(titulo,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(texto, textAlign: TextAlign.center),
          ]),
        ),
      );
}

class _SeletorMes extends StatelessWidget {
  const _SeletorMes({
    required this.mes,
    required this.onAnterior,
    required this.onProximo,
  });

  final DateTime mes;
  final VoidCallback onAnterior;
  final VoidCallback onProximo;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(children: [
            IconButton(
                tooltip: 'Mês anterior',
                onPressed: onAnterior,
                icon: const Icon(Icons.chevron_left)),
            Expanded(
              child: Text(
                _nomeMes(mes),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 17,
                    fontWeight: FontWeight.w800),
              ),
            ),
            IconButton(
                tooltip: 'Próximo mês',
                onPressed: onProximo,
                icon: const Icon(Icons.chevron_right)),
          ]),
        ),
      );
}

class _Indicadores extends StatelessWidget {
  const _Indicadores({required this.resumo});

  final ResumoDespesas resumo;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth >= 900
          ? (constraints.maxWidth - 54) / 4
          : constraints.maxWidth >= 580
              ? (constraints.maxWidth - 18) / 2
              : constraints.maxWidth;
      return Wrap(
        spacing: 18,
        runSpacing: 12,
        children: [
          _IndicadorCard(
            width: width,
            icon: Icons.trending_up,
            label: 'Entradas',
            value: _moeda(resumo.totalEntradas),
            color: AppColors.green,
          ),
          _IndicadorCard(
            width: width,
            icon: Icons.trending_down,
            label: 'Despesas',
            value: _moeda(resumo.total),
            color: AppColors.red,
          ),
          _IndicadorCard(
            width: width,
            icon: Icons.account_balance_wallet_outlined,
            label: 'Saldo do mês',
            value: _moeda(resumo.saldo),
            color: resumo.saldo >= 0 ? AppColors.green : AppColors.red,
          ),
          _IndicadorCard(
            width: width,
            icon: Icons.receipt_long_outlined,
            label: 'Movimentações',
            value: '${resumo.quantidade} lançamento(s)',
            color: const Color(0xFF2A6FBB),
          ),
        ],
      );
    });
  }
}

class _IndicadorCard extends StatelessWidget {
  const _IndicadorCard({
    required this.width,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final double width;
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: const TextStyle(
                            color: AppColors.muted, fontSize: 12)),
                    const SizedBox(height: 3),
                    Text(value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: AppColors.ink,
                            fontSize: 17,
                            fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
            ]),
          ),
        ),
      );
}

class _GraficoCategorias extends StatelessWidget {
  const _GraficoCategorias({required this.resumo});

  final ResumoDespesas resumo;

  @override
  Widget build(BuildContext context) {
    final items = resumo.porCategoria.entries
        .where((item) => item.value > 0)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Gastos por categoria',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 5),
          const Text('Participação de cada categoria no total do mês.'),
          const SizedBox(height: 22),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: Text('Nenhum gasto neste mês.')),
            )
          else
            ...items.map((item) {
              final percent =
                  resumo.total == 0 ? 0.0 : item.value / resumo.total;
              final color = item.key.color;
              return Padding(
                padding: const EdgeInsets.only(bottom: 17),
                child: Column(children: [
                  Row(children: [
                    Icon(item.key.icon, color: color, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(item.key.label,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    Text(_moeda(item.value),
                        style: const TextStyle(
                            color: AppColors.ink, fontWeight: FontWeight.w800)),
                  ]),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      minHeight: 9,
                      value: percent,
                      color: color,
                      backgroundColor: color.withValues(alpha: .12),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text('${(percent * 100).toStringAsFixed(1)}%',
                        style: const TextStyle(
                            color: AppColors.muted, fontSize: 11)),
                  ),
                ]),
              );
            }),
        ]),
      ),
    );
  }
}

class _Historico extends StatefulWidget {
  const _Historico({
    required this.despesas,
    required this.onEditar,
    required this.onExcluir,
  });

  final List<Despesa> despesas;
  final ValueChanged<Despesa> onEditar;
  final ValueChanged<Despesa> onExcluir;

  @override
  State<_Historico> createState() => _HistoricoState();
}

class _HistoricoState extends State<_Historico> {
  int _categoriaSelecionada = 0;

  @override
  Widget build(BuildContext context) {
    const categorias = CategoriaDespesa.values;
    final lancamentos = _categoriaSelecionada == 0
        ? widget.despesas
        : widget.despesas
            .where((item) =>
                item.categoria == categorias[_categoriaSelecionada - 1])
            .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Lançamentos', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 5),
          const Text('Selecione uma categoria e toque para editar.'),
          const SizedBox(height: 14),
          DefaultTabController(
            length: categorias.length + 1,
            initialIndex: _categoriaSelecionada,
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              onTap: (index) => setState(() => _categoriaSelecionada = index),
              tabs: [
                const Tab(text: 'Todos'),
                ...categorias.map((categoria) => Tab(text: categoria.label)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (lancamentos.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 42),
              child: Center(
                child: Column(children: [
                  Icon(Icons.receipt_long_outlined,
                      color: AppColors.muted, size: 36),
                  SizedBox(height: 10),
                  Text('Nenhum lançamento nesta categoria.'),
                ]),
              ),
            )
          else
            ...lancamentos.map((despesa) => Column(children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () => widget.onEditar(despesa),
                    leading: CircleAvatar(
                      backgroundColor:
                          despesa.categoria.color.withValues(alpha: .12),
                      child: Icon(despesa.categoria.icon,
                          color: despesa.categoria.color, size: 20),
                    ),
                    title: Text(despesa.categoria.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                    subtitle: Text(
                        '${despesa.tipo.label} · ${_formatarData(despesa.data)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            '${despesa.tipo == TipoLancamento.entrada ? '+' : '-'} ${_moeda(despesa.valor)}',
                            style: TextStyle(
                                color: despesa.tipo == TipoLancamento.entrada
                                    ? AppColors.green
                                    : AppColors.red,
                                fontWeight: FontWeight.w900)),
                        IconButton(
                          tooltip: 'Excluir',
                          onPressed: () => widget.onExcluir(despesa),
                          icon: const Icon(Icons.delete_outline, size: 20),
                        ),
                      ],
                    ),
                  ),
                  if (despesa != lancamentos.last) const Divider(height: 1),
                ])),
        ]),
      ),
    );
  }
}

class _DespesaForm extends StatefulWidget {
  const _DespesaForm({required this.repository, this.despesa});

  final DespesasRepository repository;
  final Despesa? despesa;

  @override
  State<_DespesaForm> createState() => _DespesaFormState();
}

class _DespesaFormState extends State<_DespesaForm> {
  final _formKey = GlobalKey<FormState>();
  late final _valor = TextEditingController(
      text: widget.despesa == null
          ? ''
          : widget.despesa!.valor.toStringAsFixed(2).replaceAll('.', ','));
  late final _observacao =
      TextEditingController(text: widget.despesa?.observacao);
  late CategoriaDespesa _categoria =
      widget.despesa?.categoria ?? CategoriaDespesa.eventos;
  late TipoLancamento _tipo = widget.despesa?.tipo ?? TipoLancamento.entrada;
  late DateTime _data = widget.despesa?.data ?? DateTime.now();
  bool _salvando = false;

  @override
  void dispose() {
    _valor.dispose();
    _observacao.dispose();
    super.dispose();
  }

  Future<void> _escolherData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _data,
      firstDate: DateTime(2020),
      lastDate: DateTime(DateTime.now().year + 5, 12, 31),
    );
    if (data != null) setState(() => _data = data);
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _salvando = true);
    try {
      await widget.repository.salvar(Despesa(
        id: widget.despesa?.id ?? '',
        descricao: widget.despesa?.descricao ?? _categoria.label,
        valor: _parseValor(_valor.text)!,
        tipo: _tipo,
        categoria: _categoria,
        data: _data,
        observacao: _observacao.text.trim(),
      ));
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _salvando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível salvar o lançamento.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(
            22, 16, 22, MediaQuery.viewInsetsOf(context).bottom + 24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(
                    child: Text(
                      widget.despesa == null
                          ? 'Novo lançamento'
                          : 'Editar lançamento',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close)),
                ]),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<TipoLancamento>(
                    segments: const [
                      ButtonSegment(
                        value: TipoLancamento.entrada,
                        icon: Icon(Icons.add_circle_outline),
                        label: Text('Entrada'),
                      ),
                      ButtonSegment(
                        value: TipoLancamento.despesa,
                        icon: Icon(Icons.remove_circle_outline),
                        label: Text('Despesa'),
                      ),
                    ],
                    selected: {_tipo},
                    onSelectionChanged: (value) {
                      setState(() {
                        _tipo = value.first;
                        _categoria = _tipo == TipoLancamento.entrada
                            ? CategoriaDespesa.eventos
                            : CategoriaDespesa.ingredientes;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _valor,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Valor',
                    prefixText: 'R\$ ',
                    prefixIcon: Icon(Icons.payments_outlined),
                  ),
                  validator: (value) {
                    final numero = _parseValor(value ?? '');
                    return numero == null || numero <= 0
                        ? 'Informe um valor válido'
                        : null;
                  },
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<CategoriaDespesa>(
                  initialValue: _categoria,
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: CategoriaDespesa.values
                      .where((categoria) => _tipo == TipoLancamento.entrada
                          ? categoria == CategoriaDespesa.eventos
                          : categoria != CategoriaDespesa.eventos)
                      .map((categoria) => DropdownMenuItem(
                            value: categoria,
                            child: Text(categoria.label),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _categoria = value);
                  },
                ),
                const SizedBox(height: 14),
                InkWell(
                  onTap: _escolherData,
                  borderRadius: BorderRadius.circular(16),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Data',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    child: Text(_formatarData(_data)),
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _observacao,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Observação (opcional)',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _salvando ? null : _salvar,
                    icon: _salvando
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.save_outlined),
                    label:
                        Text(_salvando ? 'Salvando...' : 'Salvar lançamento'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

extension on CategoriaDespesa {
  IconData get icon => switch (this) {
        CategoriaDespesa.eventos => Icons.celebration_outlined,
        CategoriaDespesa.ingredientes => Icons.shopping_basket_outlined,
        CategoriaDespesa.bebidas => Icons.local_drink_outlined,
        CategoriaDespesa.equipe => Icons.groups_outlined,
        CategoriaDespesa.transporte => Icons.local_shipping_outlined,
        CategoriaDespesa.equipamentos => Icons.kitchen_outlined,
        CategoriaDespesa.marketing => Icons.campaign_outlined,
        CategoriaDespesa.taxas => Icons.account_balance_outlined,
        CategoriaDespesa.outros => Icons.more_horiz,
      };

  Color get color => switch (this) {
        CategoriaDespesa.eventos => AppColors.green,
        CategoriaDespesa.ingredientes => const Color(0xFFC6281C),
        CategoriaDespesa.bebidas => const Color(0xFF2A6FBB),
        CategoriaDespesa.equipe => const Color(0xFF176A3B),
        CategoriaDespesa.transporte => const Color(0xFFE48A19),
        CategoriaDespesa.equipamentos => const Color(0xFF7253A6),
        CategoriaDespesa.marketing => const Color(0xFFD54A79),
        CategoriaDespesa.taxas => const Color(0xFF59656F),
        CategoriaDespesa.outros => const Color(0xFF8A6A54),
      };
}

double? _parseValor(String value) {
  var normalizado = value.trim().replaceAll(' ', '');
  if (normalizado.contains(',')) {
    normalizado = normalizado.replaceAll('.', '').replaceAll(',', '.');
  }
  return double.tryParse(normalizado);
}

String _moeda(num valor) {
  final partes = valor.toStringAsFixed(2).split('.');
  final chars = partes.first.split('').reversed.toList();
  final grupos = <String>[];
  for (var i = 0; i < chars.length; i += 3) {
    grupos.add(chars.skip(i).take(3).toList().reversed.join());
  }
  return 'R\$ ${grupos.reversed.join('.')},${partes.last}';
}

String _formatarData(DateTime data) =>
    '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';

String _nomeMes(DateTime data) {
  const meses = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];
  return '${meses[data.month - 1]} de ${data.year}';
}
