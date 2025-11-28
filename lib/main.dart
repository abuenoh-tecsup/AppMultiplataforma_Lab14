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
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "SaveMoney",
        theme: ThemeData(
          primarySwatch: Colors.green,
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