import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'evento_model.dart';
import 'eventos_repository.dart';

class EventoForm extends StatefulWidget {
  const EventoForm({super.key, this.evento});

  final Evento? evento;

  @override
  State<EventoForm> createState() => _EventoFormState();
}

class _EventoFormState extends State<EventoForm> {
  final _formKey = GlobalKey<FormState>();
  final _repository = EventosRepository();
  late final _nome = TextEditingController(text: widget.evento?.nome);
  late final _telefone = TextEditingController(text: widget.evento?.telefone);
  late final _endereco = TextEditingController(text: widget.evento?.endereco);
  late final _convidados = TextEditingController(
      text: widget.evento == null ? '' : '${widget.evento!.convidados}');
  late DateTime _data = widget.evento?.dataHora ?? DateTime.now();
  late TimeOfDay _horario = TimeOfDay.fromDateTime(
      widget.evento?.dataHora ?? DateTime.now().add(const Duration(hours: 1)));
  bool _salvando = false;

  @override
  void dispose() {
    _nome.dispose();
    _telefone.dispose();
    _endereco.dispose();
    _convidados.dispose();
    super.dispose();
  }

  Future<void> _escolherData() async {
    final agora = DateTime.now();
    final hoje = DateTime(agora.year, agora.month, agora.day);
    final data = await showDatePicker(
      context: context,
      initialDate: _data,
      firstDate: hoje,
      lastDate: DateTime(DateTime.now().year + 10, 12, 31),
    );
    if (data != null) setState(() => _data = data);
  }

  Future<void> _escolherHorario() async {
    final horario = await showTimePicker(
      context: context,
      initialTime: _horario,
    );
    if (horario != null) setState(() => _horario = horario);
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _salvando = true);
    final dataHora = DateTime(
      _data.year,
      _data.month,
      _data.day,
      _horario.hour,
      _horario.minute,
    );
    try {
      final conflito = await _repository.buscarConflito(
        dataHora,
        ignorarId: widget.evento?.id,
      );
      if (conflito != null) {
        if (!mounted) return;
        setState(() => _salvando = false);
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Horário indisponível'),
            content: Text(
              'Já existe um evento de ${conflito.nome} em '
              '${_formatarData(dataHora)} às ${_formatarHorario(dataHora)}.',
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Escolher outro horário'),
              ),
            ],
          ),
        );
        return;
      }
      await _repository.salvar(Evento(
        id: widget.evento?.id ?? '',
        nome: _nome.text.trim(),
        telefone: _telefone.text.trim(),
        endereco: _endereco.text.trim(),
        convidados: int.parse(_convidados.text),
        dataHora: dataHora,
      ));
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _salvando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível salvar o evento.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.evento == null ? 'Novo evento' : 'Editar evento'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dados do evento',
                            style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 6),
                        const Text(
                            'Preencha os dados usados para organizar a agenda.'),
                        const SizedBox(height: 22),
                        TextFormField(
                          controller: _nome,
                          maxLength: 120,
                          textCapitalization: TextCapitalization.words,
                          autofillHints: const [AutofillHints.name],
                          decoration: const InputDecoration(
                            labelText: 'Nome da pessoa',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (value) =>
                              value == null || value.trim().length < 2
                                  ? 'Informe o nome da pessoa'
                                  : null,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _telefone,
                          maxLength: 30,
                          keyboardType: TextInputType.phone,
                          autofillHints: const [AutofillHints.telephoneNumber],
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9()+\- ]')),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Telefone',
                            hintText: '(31) 99999-9999',
                            prefixIcon: Icon(Icons.phone_outlined),
                          ),
                          validator: (value) {
                            final digitos = (value ?? '')
                                .replaceAll(RegExp(r'\D'), '')
                                .length;
                            return digitos < 10
                                ? 'Informe um telefone válido'
                                : null;
                          },
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _convidados,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Número de convidados',
                            prefixIcon: Icon(Icons.groups_outlined),
                          ),
                          validator: (value) {
                            final numero = int.tryParse(value ?? '');
                            return numero == null ||
                                    numero <= 0 ||
                                    numero > 10000
                                ? 'Informe uma quantidade válida'
                                : null;
                          },
                        ),
                        const SizedBox(height: 14),
                        LayoutBuilder(builder: (context, constraints) {
                          final campoData = InkWell(
                            onTap: _escolherData,
                            borderRadius: BorderRadius.circular(16),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Data',
                                prefixIcon: Icon(Icons.calendar_today_outlined),
                              ),
                              child: Text(_formatarData(_data)),
                            ),
                          );
                          final campoHorario = InkWell(
                            onTap: _escolherHorario,
                            borderRadius: BorderRadius.circular(16),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Horário',
                                prefixIcon: Icon(Icons.schedule_outlined),
                              ),
                              child: Text(_horario.format(context)),
                            ),
                          );
                          if (constraints.maxWidth >= 560) {
                            return Row(children: [
                              Expanded(child: campoData),
                              const SizedBox(width: 14),
                              Expanded(child: campoHorario),
                            ]);
                          }
                          return Column(
                            children: [
                              campoData,
                              const SizedBox(height: 14),
                              campoHorario,
                            ],
                          );
                        }),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _endereco,
                          maxLength: 300,
                          textCapitalization: TextCapitalization.words,
                          autofillHints: const [
                            AutofillHints.streetAddressLine1
                          ],
                          maxLines: 2,
                          decoration: const InputDecoration(
                            labelText: 'Endereço',
                            prefixIcon: Icon(Icons.location_on_outlined),
                            alignLabelWithHint: true,
                          ),
                          validator: (value) =>
                              value == null || value.trim().length < 5
                                  ? 'Informe o endereço do evento'
                                  : null,
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: _salvando ? null : _salvar,
                            icon: _salvando
                                ? const SizedBox.square(
                                    dimension: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.save_outlined),
                            label: Text(
                                _salvando ? 'Salvando...' : 'Salvar evento'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _formatarData(DateTime data) =>
    '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';

String _formatarHorario(DateTime data) =>
    '${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
