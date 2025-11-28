import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savemoney/providers/transaction_provider.dart';
import 'package:savemoney/screens/registro_view.dart';
import 'package:savemoney/screens/informe_view.dart';

class HistorialView extends StatefulWidget {
  const HistorialView({super.key});

  @override
  State<HistorialView> createState() => _HistorialViewState();
}

class _HistorialViewState extends State<HistorialView> {
  @override
  void initState() {
    super.initState();
    Provider.of<TransactionProvider>(context, listen: false).loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    final items = provider.transactions;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6), // gris suave para contraste

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0D0F36),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(22),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Historial",
                    style: TextStyle(
                      fontFamily: "Outfit",
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.bar_chart, color: Color(0xFF69D2CD), size: 30),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const InformeView()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF69D2CD),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RegistroView()),
        ),
      ),

      body: items.isEmpty
          ? const Center(
              child: Text(
                "No hay movimientos aún",
                style: TextStyle(fontFamily: "Outfit", fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final t = items[i];
                final isIngreso = t.type == "Ingreso";

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        offset: const Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    leading: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isIngreso
                            ? Colors.green.withOpacity(0.15)
                            : Colors.red.withOpacity(0.15),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        isIngreso ? Icons.arrow_upward : Icons.arrow_downward,
                        color: isIngreso ? Colors.green : Colors.red,
                      ),
                    ),

                    title: Text(
                      "${t.category} - ${t.amount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontFamily: "Outfit",
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    subtitle: Text(
                      t.description ?? "Sin descripción",
                      style: TextStyle(
                        fontFamily: "Outfit",
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    // 👉 EDITAR
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            RegistroView(editable: true, transaction: t),
                      ),
                    ),

                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => provider.deleteTransaction(t.id!),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
