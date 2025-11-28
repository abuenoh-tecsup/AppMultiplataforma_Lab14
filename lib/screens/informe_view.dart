import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savemoney/providers/transaction_provider.dart';

class InformeView extends StatelessWidget {
  const InformeView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    final items = provider.transactions;

    final ingresosList = items.where((t) => t.type == "Ingreso").toList();
    final gastosList = items.where((t) => t.type == "Gasto").toList();

    final ingresos = ingresosList.fold<double>(0, (s, t) => s + t.amount);
    final gastos = gastosList.fold<double>(0, (s, t) => s + t.amount);
    final balance = ingresos - gastos;

    // Nuevas estadísticas
    final totalTransacciones = items.length;
    final promIngreso = ingresosList.isNotEmpty ? ingresos / ingresosList.length : 0;
    final promGasto = gastosList.isNotEmpty ? gastos / gastosList.length : 0;
    final mayorIngreso = ingresosList.isNotEmpty
        ? ingresosList.map((e) => e.amount).reduce((a, b) => a > b ? a : b)
        : 0;
    final mayorGasto = gastosList.isNotEmpty
        ? gastosList.map((e) => e.amount).reduce((a, b) => a > b ? a : b)
        : 0;

    // Categoría más usada
    final categoryCounts = <String, int>{};
    for (var t in items) {
      categoryCounts[t.category] = (categoryCounts[t.category] ?? 0) + 1;
    }
    final categoriaPopular = categoryCounts.isEmpty
        ? "N/A"
        : categoryCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    // Agrupar por categoría para los gráficos de barras
    final ingresosCategoria = <String, double>{};
    for (var t in ingresosList) {
      ingresosCategoria[t.category] = (ingresosCategoria[t.category] ?? 0) + t.amount;
    }

    final gastosCategoria = <String, double>{};
    for (var t in gastosList) {
      gastosCategoria[t.category] = (gastosCategoria[t.category] ?? 0) + t.amount;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F36),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0F36),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Informe",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Outfit",
              fontWeight: FontWeight.w600,
            )),
        centerTitle: true,
      ),
      body: ScrollConfiguration(
        behavior: const _NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              _sectionTitle("Resumen General"),

              _box("Ingresos", ingresos, Colors.greenAccent),
              const SizedBox(height: 15),
              _box("Gastos", gastos, Colors.redAccent),
              const SizedBox(height: 15),
              _box(
                "Balance",
                balance,
                balance >= 0 ? Colors.greenAccent : Colors.redAccent,
              ),

              const SizedBox(height: 30),
              _sectionTitle("Ingresos por Categoría"),
              const SizedBox(height: 15),
              _barChart(ingresosCategoria, Colors.greenAccent),

              const SizedBox(height: 30),
              _sectionTitle("Gastos por Categoría"),
              const SizedBox(height: 15),
              _barChart(gastosCategoria, Colors.redAccent),

              const SizedBox(height: 30),
              _sectionTitle("Estadísticas extra"),

              _miniStat("Total de transacciones", totalTransacciones.toString()),
              _miniStat("Promedio de ingreso", promIngreso.toStringAsFixed(2)),
              _miniStat("Promedio de gasto", promGasto.toStringAsFixed(2)),
              _miniStat("Mayor ingreso", mayorIngreso.toStringAsFixed(2)),
              _miniStat("Mayor gasto", mayorGasto.toStringAsFixed(2)),
              _miniStat("Categoría más usada", categoriaPopular),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Widgets pequeños para orden -----------

  Widget _sectionTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontFamily: "Outfit",
          fontSize: 20,
          fontWeight: FontWeight.w600,
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

  Widget _miniStat(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D4A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF69D2CD), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Colors.white, fontFamily: "Outfit", fontSize: 16)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "Outfit",
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // --- Gráfico de barras por categoría ---
  Widget _barChart(Map<String, double> data, Color barColor) {
    if (data.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1D4A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF69D2CD), width: 1),
        ),
        child: const Center(
          child: Text(
            "Sin datos para mostrar",
            style: TextStyle(
              color: Colors.white70,
              fontFamily: "Outfit",
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    final maxValue = data.values.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D4A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF69D2CD), width: 1),
      ),
      child: Column(
        children: data.entries.map((entry) {
          final percentage = maxValue == 0 ? 0.0 : entry.value / maxValue;
          
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "Outfit",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      entry.value.toStringAsFixed(2),
                      style: TextStyle(
                        color: barColor,
                        fontFamily: "Outfit",
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: percentage),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  builder: (_, value, __) => Stack(
                    children: [
                      // Fondo de la barra
                      Container(
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      // Barra animada
                      FractionallySizedBox(
                        widthFactor: value,
                        child: Container(
                          height: 24,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                barColor,
                                barColor.withOpacity(0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: barColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ---------- Elimina el efecto de brillo/estiramiento ----------
class _NoGlowScrollBehavior extends ScrollBehavior {
  const _NoGlowScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}