import 'dart:math';
import 'package:clinica_app/pages/CitasScreen.dart';
import 'package:clinica_app/pages/MascotasScreen.dart';
import 'package:clinica_app/pages/PedirCita.dart';
import 'package:clinica_app/pages/TiendaScreen.dart';
import 'package:clinica_app/pages/UsuarioInfoScreen.dart';
import 'package:flutter/material.dart';

class Inicio extends StatefulWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Quitamos el color de fondo sólido
    // backgroundColor: Colors.blueAccent,
    body: Container(
      // Añadimos la imagen de fondo desde la red
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage("https://i.pinimg.com/originals/7c/7b/74/7c7b748eaba6be9895724fd87eb6c414.jpg"), // Cambia esta URL por la que quieras usar
          fit: BoxFit.cover, // Para que cubra toda la pantalla
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Barra superior
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.person, color: Colors.white, size: 32),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const UsuarioInfoPage()),
                      );
                    },
                  ),
                  Image.asset(
                    "lib/assets/letrasClinica.png",
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                  IconButton(
                    icon: const Icon(Icons.share, color: Colors.white, size: 28),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            // Botones flotantes de WhatsApp y llamada
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Botón de WhatsApp
                  Container(
                    width: 60, // Tamaño ajustable según necesites
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          spreadRadius: 1,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {},
                          child: ClipOval(
                            child: Image.asset(
                              "lib/assets/whatsapp.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                      ),
                    ),
                  ),
                  
                  // Botón de llamada
                  Container(
                    width: 60, // Tamaño ajustable según necesites
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          spreadRadius: 1,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {},
                        child: const Icon(
                          Icons.phone,
                          color: Colors.white,
                          size: 38, // Icono más grande
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Menú circular central ajustado
            Expanded(
              child: Center(
                child: SizedBox(
                  width: 300,
                  height: 380,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Botón central: Pedir Cita con imagen
                      Positioned(
                        left: 80,
                        top: 90,
                        child: _circleMenuButton(
                          imagePath: "lib/assets/icon_pedirCita.png", // Ruta a tu imagen
                          label: "Pedir Cita",
                          onTap: () {
                            // Acción de navegación
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Pedircita()),
                            );
                          },
                          size: 130,
                          fontSize: 20,
                          color: Colors.white,
                          elevation: 8,
                          isMain: true,
                        ),
                      ),
                      // Cesta con imagen
                      _positionedCircleCustom(
                        angle: 180,
                        distance: 65,
                        centerOffset: const Offset(110, 110),
                        child: _circleMenuButton(
                          imagePath: "lib/assets/icon_cesta.png", // Ruta a tu imagen
                          label: "Cesta",
                          onTap: () {},
                        ),
                      ),
                      // Pets con imagen
                      _positionedCircleCustom(
                        angle: 260,
                        distance: 55,
                        centerOffset: const Offset(110, 110),
                        child: _circleMenuButton(
                          imagePath: "lib/assets/icon_mascotas.png", // Ruta a tu imagen
                          label: "Pets",
                          onTap: () {
                            // Acción de navegación
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Mascotas()),
                            );
                          },
                        ),
                      ),
                      // Citas con imagen
                      _positionedCircleCustom(
                        angle: 320,
                        distance: 90,
                        centerOffset: const Offset(110, 110),
                        child: _circleMenuButton(
                          imagePath: "lib/assets/icon_citas.png", // Ruta a tu imagen
                          label: "Citas",
                          onTap: () {
                            // Acción de navegación
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CitasScreen()),
                            );
                          },
                        ),
                      ),
                      // Tienda con imagen
                      _positionedCircleCustom(
                        angle: 355,
                        distance: 135,
                        centerOffset: const Offset(110, 110),
                        child: _circleMenuButton(
                          imagePath: "lib/assets/icon_tienda.png", // Ruta a tu imagen
                          label: "Tienda",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Tienda()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

             // Semicírculo inferior con huella
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Semicírculo blanco con curva más suave
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.elliptical(300, 80), // Valores más altos para curva más suave
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                ),
                
                // Imagen Huella
                Positioned(
                  bottom: 5, // Ajusta esta posición para centrar la huella en el borde
                  child: Image.asset(
                    "lib/assets/huella.png",
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    ),
    );
  }

  // Widget que Posiciona los botones en semicírculo superior alrededor del botón central
  Widget _positionedCircleCustom({
    required double angle,//Ángulo en grados donde quieres posicionar el botón respecto al centro.
    required double distance,//Distancia radial desde el centro (en píxeles).
    required Offset centerOffset,//Coordenadas (x,y) del centro del círculo (botón "Pedir Cita").
    required Widget child,//El widget del botón que quieres posicionar.
  }) {
    //posicionar boton en plano cartesiano(que movida)
    final double rad = angle * pi / 180;
    return Positioned(
      left: centerOffset.dx + distance * cos(rad) - 32,
      top: centerOffset.dy + distance * sin(rad) - 32,
      child: child,
    );
  }

// Widget para cada botón circular del menú (soporta tanto imágenes como iconos)
Widget _circleMenuButton({
  //los parámetros de icono e imagen son opcionales
  IconData? icon, 
  String? imagePath, // parámetro para la ruta de la imagen
  required String label,
  required VoidCallback onTap,
  double size = 64,
  double fontSize = 14,
  Color color = Colors.white,
  Color iconColor = Colors.teal,
  double elevation = 4,
  bool isMain = false,
}) {
  return Material(
    elevation: elevation,
    shape: const CircleBorder(),
    color: color,
    child: InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: SizedBox(
        width: size,
        height: size,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Muestra la imagen si hay un imagePath, de lo contrario muestra el icono
            if (imagePath != null)
              Image.asset(
                imagePath,
                width: isMain ? 50 : 32,
                height: isMain ? 50 : 32,
                fit: BoxFit.contain,
              )
            else if (icon != null)
              Icon(icon, color: iconColor, size: isMain ? 40 : 28),
            
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Color(0xFF1466A3),
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
  }
}

