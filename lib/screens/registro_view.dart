import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savemoney/models/transaction.dart';
import 'package:savemoney/providers/transaction_provider.dart';

class RegistroView extends StatefulWidget {
  final bool editable;
  final TransactionModel? transaction;

  const RegistroView({super.key, this.editable = false, this.transaction});

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
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0F36),
        foregroundColor: Colors.white,
        title: Text(
          widget.editable ? "Editar Movimiento" : "Registrar Movimiento",
          style: const TextStyle(fontFamily: "Outfit"),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 10),

              _label("Tipo"),
              _styledDropdown(
                value: type,
                items: ["Ingreso", "Gasto"],
                onChanged: (v) => setState(() => type = v!),
              ),

              const SizedBox(height: 20),

              _label("Categoría"),
              _styledDropdown(
                value: category,
                items: categories,
                onChanged: (v) => setState(() => category = v!),
              ),

              const SizedBox(height: 20),

              _label("Monto"),
              _styledField(
                initialValue: amount?.toString(),
                hint: "0.00",
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? "Ingresa un monto" : null,
                onSaved: (v) => amount = double.tryParse(v!),
              ),

              const SizedBox(height: 20),

              _label("Descripción (opcional)"),
              _styledField(
                initialValue: description,
                hint: "Descripción",
                onSaved: (v) => description = v,
              ),

              const SizedBox(height: 20),

              _label("Método de Pago (opcional)"),
              _styledField(
                initialValue: paymentMethod,
                hint: "Método de pago",
                onSaved: (v) => paymentMethod = v,
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      if (widget.editable) {
                        final updated = widget.transaction!.copy(
                          type: type,
                          category: category,
                          amount: amount!,
                          description: description,
                          paymentMethod: paymentMethod,
                        );

                        await provider.updateTransaction(updated);
                      } else {
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF69D2CD),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    widget.editable ? "Actualizar" : "Guardar",
                    style: const TextStyle(
                      fontFamily: "Outfit",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D0F36),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ESTILO REUTILIZABLE
  // ---------------------------------------------------------------------------

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: "Outfit",
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: Color(0xFF0D0F36),
      ),
    );
  }

  Widget _styledField({
    String? initialValue,
    String? hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
      style: const TextStyle(fontFamily: "Outfit"),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(color: Colors.black26),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF69D2CD), width: 2),
        ),
      ),
    );
  }

  Widget _styledDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: DropdownButtonFormField(
        value: value,
        items: items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e,
                  style: const TextStyle(
                    fontFamily: "Outfit",
                    color: Colors.black,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
        decoration: const InputDecoration(border: InputBorder.none),
        style: const TextStyle(
          fontFamily: "Outfit",
          color: Colors.black,
        ),
        dropdownColor: Colors.white,
      ),
    );
  }
}
