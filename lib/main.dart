import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'cardapio.dart';
import 'despesas.dart';
import 'despesas_repository.dart';
import 'fotos.dart';
import 'firebase_options.dart';
import 'funcionamento.dart';
import 'home.dart';
import 'orcamento.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (FirebaseAuth.instance.currentUser == null) {
    await FirebaseAuth.instance.signInAnonymously();
  }
  try {
    await DespesasRepository.migrarDadosLocais();
  } catch (_) {
    // Mantém a cópia local para tentar novamente na próxima abertura.
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Home's Pizzaria",
      theme: buildAppTheme(),
      initialRoute: '/',
      routes: {
        '/': (_) => const Home(),
        '/funcionamento': (_) => const Funcionamento(),
        '/cardapio': (_) => const Cardapio(),
        '/fotos': (_) => const Fotos(),
        '/orcamento': (_) => const Orcamento(),
        '/despesas': (_) => const Despesas(),
      },
    );
  }
}
