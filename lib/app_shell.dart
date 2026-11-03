import 'package:flutter/material.dart';

import 'app_theme.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.currentIndex,
    required this.child,
    this.floatingActionButton,
  });

  final int currentIndex;
  final Widget child;
  final Widget? floatingActionButton;

  static const _primaryRoutes = ['/', '/cardapio', '/orcamento'];

  void _navigate(BuildContext context, int index) {
    if (index == 3) {
      _showMore(context);
      return;
    }
    if (index == currentIndex) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      _primaryRoutes[index],
      (route) => false,
    );
  }

  Future<void> _showMore(BuildContext context) async {
    final route = await showModalBottomSheet<String>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      constraints: const BoxConstraints(maxWidth: 560),
      builder: (context) => _MoreMenu(currentIndex: currentIndex),
    );
    if (route == null || !context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(top: false, child: child),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex >= 3 ? 3 : currentIndex,
        onDestinationSelected: (index) => _navigate(context, index),
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_pizza_outlined),
            selectedIcon: Icon(Icons.local_pizza_rounded),
            label: 'Cardápio',
          ),
          NavigationDestination(
            icon: Icon(Icons.request_quote_outlined),
            selectedIcon: Icon(Icons.request_quote_rounded),
            label: 'Orçamento',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'Mais',
          ),
        ],
      ),
    );
  }
}

class _MoreMenu extends StatelessWidget {
  const _MoreMenu({required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mais opções', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          const Text('Conteúdo para clientes e ferramentas de gestão.'),
          const SizedBox(height: 20),
          const _MenuLabel('PARA SEU EVENTO'),
          _MoreTile(
            icon: Icons.photo_library_outlined,
            title: 'Fotos',
            subtitle: 'Veja eventos realizados',
            selected: currentIndex == 3,
            route: '/fotos',
          ),
          _MoreTile(
            icon: Icons.info_outline_rounded,
            title: 'Como funciona',
            subtitle: 'Entenda cada etapa do serviço',
            selected: currentIndex == 4,
            route: '/funcionamento',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1),
          ),
          const _MenuLabel('GESTÃO'),
          _MoreTile(
            icon: Icons.calendar_month_outlined,
            title: 'Agenda',
            subtitle: 'Organize os próximos eventos',
            selected: currentIndex == 5,
            route: '/agenda',
          ),
          _MoreTile(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Financeiro',
            subtitle: 'Acompanhe despesas e resultados',
            selected: currentIndex == 6,
            route: '/despesas',
          ),
        ],
      ),
    );
  }
}

class _MenuLabel extends StatelessWidget {
  const _MenuLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      );
}

class _MoreTile extends StatelessWidget {
  const _MoreTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.route,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final String route;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minTileHeight: 64,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      selected: selected,
      selectedTileColor: AppColors.red.withValues(alpha: .08),
      leading: Icon(icon, color: selected ? AppColors.red : AppColors.ink),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(subtitle),
      trailing: Icon(
        selected ? Icons.check_rounded : Icons.chevron_right_rounded,
        color: selected ? AppColors.red : AppColors.muted,
      ),
      onTap: selected
          ? () => Navigator.pop(context)
          : () => Navigator.pop(context, route),
    );
  }
}

class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  final String eyebrow;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.ink, Color(0xFF3A241E)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 3,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB15C),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        eyebrow.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFFFFC47F),
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.4,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFFE3D7D0),
                      fontSize: 15,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
