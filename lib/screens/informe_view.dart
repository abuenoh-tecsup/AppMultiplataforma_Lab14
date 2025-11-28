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
      backgroundColor: const Color(0xFF0D0F36),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0F36),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Informe",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Outfit",
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _box(
              "Ingresos",
              ingresos,
              Colors.greenAccent,
            ),
            const SizedBox(height: 20),
            _box(
              "Gastos",
              gastos,
              Colors.redAccent,
            ),
            const SizedBox(height: 20),
            _box(
              "Balance",
              balance,
              balance >= 0 ? Colors.greenAccent : Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _box(String title, double value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D4A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF69D2CD), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF69D2CD).withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontFamily: "Outfit",
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Text(
            value.toStringAsFixed(2),
            style: TextStyle(
              fontSize: 22,
              fontFamily: "Outfit",
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
