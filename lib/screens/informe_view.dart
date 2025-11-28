import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savemoney/providers/transaction_provider.dart';

class InformeView extends StatelessWidget {
  const InformeView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    final items = provider.transactions;

    final ingresos = items
        .where((t) => t.type == "Ingreso")
        .fold<double>(0, (s, t) => s + t.amount);

    final gastos = items
        .where((t) => t.type == "Gasto")
        .fold<double>(0, (s, t) => s + t.amount);

    final balance = ingresos - gastos;

    return Scaffold(
      appBar: AppBar(title: const Text("Informe")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _box("Ingresos", ingresos, Colors.green),
            _box("Gastos", gastos, Colors.red),
            _box("Balance", balance, balance >= 0 ? Colors.green : Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _box(String title, double value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(
              value.toStringAsFixed(2),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
