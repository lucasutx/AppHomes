import 'package:flutter/material.dart';
import 'app_theme.dart';

class AppShell extends StatelessWidget {
  const AppShell(
      {super.key,
      required this.currentIndex,
      required this.child,
      this.floatingActionButton});
  final int currentIndex;
  final Widget child;
  final Widget? floatingActionButton;

  static const _routes = [
    '/',
    '/cardapio',
    '/orcamento',
    '/fotos',
    '/funcionamento',
    '/agenda',
    '/despesas',
  ];

  void _navigate(BuildContext context, int index) {
    if (index == currentIndex) return;
    Navigator.pushNamedAndRemoveUntil(
        context, _routes[index], (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(top: false, child: child),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) => _navigate(context, index),
        backgroundColor: Colors.white,
        indicatorColor: AppColors.red.withValues(alpha: .12),
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Início'),
          NavigationDestination(
              icon: Icon(Icons.local_pizza_outlined),
              selectedIcon: Icon(Icons.local_pizza),
              label: 'Cardápio'),
          NavigationDestination(
              icon: Icon(Icons.request_quote_outlined),
              selectedIcon: Icon(Icons.request_quote),
              label: 'Orçamento'),
          NavigationDestination(
              icon: Icon(Icons.photo_library_outlined),
              selectedIcon: Icon(Icons.photo_library),
              label: 'Fotos'),
          NavigationDestination(
              icon: Icon(Icons.info_outline),
              selectedIcon: Icon(Icons.info),
              label: 'Como funciona'),
          NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined),
              selectedIcon: Icon(Icons.calendar_month),
              label: 'Agenda'),
          NavigationDestination(
              icon: Icon(Icons.account_balance_wallet_outlined),
              selectedIcon: Icon(Icons.account_balance_wallet),
              label: 'Financeiro'),
        ],
      ),
    );
  }
}

class PageHeader extends StatelessWidget {
  const PageHeader(
      {super.key,
      required this.eyebrow,
      required this.title,
      required this.subtitle});
  final String eyebrow;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 58, 24, 28),
      decoration: const BoxDecoration(
          color: AppColors.ink,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(32))),
      child: SafeArea(
        bottom: false,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(eyebrow.toUpperCase(),
              style: const TextStyle(
                  color: Color(0xFFFFB15C),
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5)),
          const SizedBox(height: 8),
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Colors.white)),
          const SizedBox(height: 8),
          Text(subtitle,
              style: const TextStyle(color: Color(0xFFD8CBC3), height: 1.45)),
        ]),
      ),
    );
  }
}
