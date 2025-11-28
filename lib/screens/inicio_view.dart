import 'package:flutter/material.dart';

class InicioView extends StatelessWidget {
  const InicioView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F36),
      body: Stack(
        children: [
          // ======== Patrones decorativos ========
          Positioned(
            top: -50,
            left: -30,
            child: _circleDecoration(140),
          ),
          Positioned(
            bottom: -60,
            right: -40,
            child: _circleDecoration(180),
          ),

          // ======== Contenido Principal ========
          SafeArea(
            child: Column(
              children: [
                // ---------- Sección 1 ----------
                Expanded(
                  child: Center(
                    child: Text(
                      "Desarrollado por Alvaro Bueno",
                      style: const TextStyle(
                        color: Color(0xFF69D2CD),
                        fontSize: 14,
                        fontFamily: "Outfit",
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),

                // ---------- Sección 2 ----------
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "SaveMoney",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontFamily: "Outfit",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Controla tus ingresos y gastos de forma sencilla",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF69D2CD),
                          fontSize: 18,
                          fontFamily: "Outfit",
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),

                // ---------- Sección 3 ----------
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/historial');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF69D2CD),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Entrar",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Outfit",
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ======= Widget para los patrones decorativos =======
  Widget _circleDecoration(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF69D2CD).withOpacity(0.15),
        shape: BoxShape.circle,
      ),
    );
  }
}
