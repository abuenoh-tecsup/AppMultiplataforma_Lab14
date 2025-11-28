import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savemoney/providers/transaction_provider.dart';
import 'package:savemoney/screens/historial_view.dart';
import 'package:savemoney/screens/inicio_view.dart';

void main() {
  runApp(const SaveMoneyApp());
}

class SaveMoneyApp extends StatelessWidget {
  const SaveMoneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TransactionProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "SaveMoney",
        theme: ThemeData(
          primarySwatch: Colors.green,
          fontFamily: 'Outfit',
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF0D0F36),
            foregroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: "Outfit",
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const InicioView(),
          '/historial': (context) => const HistorialView(),
        },
      ),
    );
  }
}
