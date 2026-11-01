import 'package:flutter/material.dart';
import 'app_shell.dart';
import 'app_theme.dart';
import 'evento_form.dart';
import 'evento_model.dart';
import 'eventos_repository.dart';

class EventosAgenda extends StatefulWidget {
  const EventosAgenda({super.key});

  @override
  State<EventosAgenda> createState() => _EventosAgendaState();
}

class _EventosAgendaState extends State<EventosAgenda> {
  final _repository = EventosRepository();

  Future<void> _abrirFormulario([Evento? evento]) async {
    final salvo = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => EventoForm(evento: evento)),
    );
    if (salvo == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              evento == null ? 'Evento cadastrado.' : 'Evento atualizado.'),
        ),
      );
    }
  }

  Future<void> _excluir(Evento evento) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir evento?'),
        content: Text(
            'O evento de ${evento.nome}, em ${_formatarData(evento.dataHora)}, será removido permanentemente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmou != true || !mounted) return;
    try {
      await _repository.excluir(evento.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Evento excluído.')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível excluir o evento.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentIndex: 5,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirFormulario,
        icon: const Icon(Icons.add),
        label: const Text('Novo evento'),
      ),
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: PageHeader(
              eyebrow: 'Organização',
              title: 'Agenda de eventos',
              subtitle:
                  'Consulte os próximos eventos e mantenha os dados de cada cliente organizados.',
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 110),
                  child: StreamBuilder<List<Evento>>(
                    stream: _repository.observarAgenda(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const _MensagemAgenda(
                          icon: Icons.cloud_off_outlined,
                          titulo: 'Não foi possível carregar a agenda',
                          texto: 'Confira a internet e tente novamente.',
                        );
                      }
                      if (!snapshot.hasData) {
                        return const Padding(
                          padding: EdgeInsets.all(48),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final eventos = snapshot.data!;
                      if (eventos.isEmpty) {
                        return const _MensagemAgenda(
                          icon: Icons.event_available_outlined,
                          titulo: 'Agenda livre',
                          texto: 'Nenhum evento futuro cadastrado.',
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Próximos eventos',
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
                          const SizedBox(height: 6),
                          Text('${eventos.length} evento(s) na agenda.'),
                          const SizedBox(height: 18),
                          ...eventos.map((evento) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _EventoCard(
                                  evento: evento,
                                  onEditar: () => _abrirFormulario(evento),
                                  onExcluir: () => _excluir(evento),
                                ),
                              )),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventoCard extends StatelessWidget {
  const _EventoCard({
    required this.evento,
    required this.onEditar,
    required this.onExcluir,
  });

  final Evento evento;
  final VoidCallback onEditar;
  final VoidCallback onExcluir;

  @override
  Widget build(BuildContext context) => Card(
        child: InkWell(
          onTap: onEditar,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 62,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.red.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(children: [
                    Text('${evento.dataHora.day}'.padLeft(2, '0'),
                        style: const TextStyle(
                            color: AppColors.red,
                            fontSize: 24,
                            fontWeight: FontWeight.w900)),
                    Text(_mesCurto(evento.dataHora),
                        style: const TextStyle(
                            color: AppColors.darkRed,
                            fontSize: 11,
                            fontWeight: FontWeight.w800)),
                  ]),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(evento.nome,
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 16,
                        runSpacing: 7,
                        children: [
                          _Info(
                              icon: Icons.schedule_outlined,
                              texto: _formatarHorario(evento.dataHora)),
                          _Info(
                              icon: Icons.groups_outlined,
                              texto: '${evento.convidados} convidados'),
                          _Info(
                              icon: Icons.phone_outlined,
                              texto: evento.telefone),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _Info(
                          icon: Icons.location_on_outlined,
                          texto: evento.endereco),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Excluir evento',
                  onPressed: onExcluir,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ),
        ),
      );
}

class _Info extends StatelessWidget {
  const _Info({required this.icon, required this.texto});

  final IconData icon;
  final String texto;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: AppColors.muted),
          const SizedBox(width: 5),
          Flexible(child: Text(texto)),
        ],
      );
}

class _MensagemAgenda extends StatelessWidget {
  const _MensagemAgenda({
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Center(
            child: Column(children: [
              Icon(icon, size: 42, color: AppColors.green),
              const SizedBox(height: 14),
              Text(titulo, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 6),
              Text(texto, textAlign: TextAlign.center),
            ]),
          ),
        ),
      );
}

String _formatarData(DateTime data) =>
    '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';

String _formatarHorario(DateTime data) =>
    '${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';

String _mesCurto(DateTime data) => const [
      'JAN',
      'FEV',
      'MAR',
      'ABR',
      'MAI',
      'JUN',
      'JUL',
      'AGO',
      'SET',
      'OUT',
      'NOV',
      'DEZ',
    ][data.month - 1];
