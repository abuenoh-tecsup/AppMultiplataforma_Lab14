import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savemoney/models/transaction.dart';
import 'package:savemoney/providers/transaction_provider.dart';

class RegistroView extends StatefulWidget {
  final bool editable;
  final TransactionModel? transaction;

  const RegistroView({
    super.key,
    this.editable = false,
    this.transaction,
  });

  @override
  State<RegistroView> createState() => _RegistroViewState();
}

class _RegistroViewState extends State<RegistroView> {
  final _formKey = GlobalKey<FormState>();

  // Campos
  String type = "Ingreso";
  String category = "General";
  String? description;
  String? paymentMethod;
  double? amount;

  final categories = [
    "General",
    "Alimentación",
    "Transporte",
    "Trabajo",
    "Casa",
    "Ocio",
  ];

  @override
  void initState() {
    super.initState();

    // Si estamos editando, cargamos los datos
    if (widget.editable && widget.transaction != null) {
      final t = widget.transaction!;
      type = t.type;
      category = t.category;
      description = t.description;
      paymentMethod = t.paymentMethod;
      amount = t.amount;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editable ? "Editar Movimiento" : "Registrar Movimiento"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Tipo
              DropdownButtonFormField(
                value: type,
                decoration: const InputDecoration(labelText: "Tipo"),
                items: ["Ingreso", "Gasto"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => type = v!),
              ),

              const SizedBox(height: 12),

              // Categoría
              DropdownButtonFormField(
                value: category,
                decoration: const InputDecoration(labelText: "Categoría"),
                items: categories
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => category = v!),
              ),

              const SizedBox(height: 12),

              // Monto
              TextFormField(
                initialValue: amount?.toString(),
                decoration: const InputDecoration(
                  labelText: "Monto",
                  hintText: "0.00",
                ),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? "Ingresa un monto" : null,
                onSaved: (v) => amount = double.tryParse(v!),
              ),

              const SizedBox(height: 12),

              // Descripción
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(labelText: "Descripción (opcional)"),
                onSaved: (v) => description = v,
              ),

              const SizedBox(height: 12),

              // Método de pago
              TextFormField(
                initialValue: paymentMethod,
                decoration:
                    const InputDecoration(labelText: "Método de Pago (opcional)"),
                onSaved: (v) => paymentMethod = v,
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                child: Text(widget.editable ? "Actualizar" : "Guardar"),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    if (widget.editable) {
                      // 🔵 EDITAR
                      final updated = widget.transaction!.copy(
                        type: type,
                        category: category,
                        amount: amount!,
                        description: description,
                        paymentMethod: paymentMethod,
                      );

                      await provider.updateTransaction(updated);
                    } else {
                      // 🟢 CREAR
                      final t = TransactionModel(
                        type: type,
                        category: category,
                        amount: amount!,
                        description: description,
                        paymentMethod: paymentMethod,
                        createdAt: DateTime.now(),
                      );

                      await provider.addTransaction(t);
                    }

                    if (!mounted) return;
                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
