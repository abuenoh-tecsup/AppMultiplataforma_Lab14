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
      appBar: AppBar(
        title: const Text("Historial"),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InformeView()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RegistroView()),
        ),
      ),
      body: items.isEmpty
          ? const Center(child: Text("No hay movimientos aún"))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, i) {
                final t = items[i];
                final isIngreso = t.type == "Ingreso";

                return Card(
                  child: ListTile(
                    leading: Icon(
                      isIngreso ? Icons.arrow_upward : Icons.arrow_downward,
                      color: isIngreso ? Colors.green : Colors.red,
                    ),
                    title: Text(
                      "${t.category} - ${t.amount.toStringAsFixed(2)}",
                    ),
                    subtitle: Text(t.description ?? "Sin descripción"),

                    // 👉 Tap para EDITAR
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            RegistroView(editable: true, transaction: t),
                      ),
                    ),

                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => provider.deleteTransaction(t.id!),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
