import 'package:clinica_app/pages/citas/CitasScreen.dart';
import 'package:clinica_app/pages/Login/Login.dart';
import 'package:clinica_app/pages/mascotas/MascotasScreen.dart';
import 'package:clinica_app/pages/ProximamenteScreen.dart';
import 'package:clinica_app/pages/usuario/EditarPerfil.dart';
import 'package:clinica_app/pages/usuario/HistorialCitas.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsuarioScreen extends StatelessWidget {
  const UsuarioScreen({Key? key}) : super(key: key);

  // Lista de apartados con su imagen de asset y widget destino.
  static final List<_AjusteItem> items = [
    _AjusteItem('Mi cuenta', "lib/assets/icon_editarUsuario.png", EditarPerfilScreen()),
    _AjusteItem('Mis mascotas', "lib/assets/icon_mascotasUsuario.png", Mascotas()),
    _AjusteItem('Mis Citas', "lib/assets/icon_citasUsuario.png", CitasScreen()),
    _AjusteItem('Historial de citas', "lib/assets/icon_historialCitasUsuario.png", HistorialCitas()),
    _AjusteItem('Pagos', "lib/assets/icon_pagosUsuario.png", ProximamenteScreen()),
    _AjusteItem('Favoritos', "lib/assets/icon_favoritosUsuario.png", ProximamenteScreen()),
    _AjusteItem('Notificaciones', "lib/assets/icon_notificacionUsuario.png", ProximamenteScreen()),
    _AjusteItem('Ajustes', "lib/assets/icon_ajustesUsuario.png", ProximamenteScreen()),
    _AjusteItem('Ayuda', "lib/assets/icon_ayudaUsuario.png", ProximamenteScreen()),
    _AjusteItem('Cerrar sesión', "lib/assets/icon_cerrarSesion.png", null), // null para cerrar sesión
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Perfil de Usuario',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          // Fondo de pantalla con imagen
          image: DecorationImage(
          image: NetworkImage("https://i.pinimg.com/originals/7c/7b/74/7c7b748eaba6be9895724fd87eb6c414.jpg"), // URL FONDO
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 0.95,
                    mainAxisSpacing: 18,
                    crossAxisSpacing: 18,
                    children: items.map((item) {
                      return _AjusteTile(item: item);
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AjusteItem {
  final String titulo;
  final String assetIcono;
  final Widget? destino; // Widget destino, null si es cerrar sesión
  const _AjusteItem(this.titulo, this.assetIcono, this.destino);
}

class _AjusteTile extends StatelessWidget {
  final _AjusteItem item;
  const _AjusteTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () async {
        if (item.destino == null) {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Cerrar sesión'),
              content: const Text('¿Seguro que quieres cerrar sesión?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Cerrar sesión')),
              ],
            ),
          );
          if (confirmed == true) {
            try {
              // Borrar datos de sesión (SharedPreferences)
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('dni_usuario');
              await prefs.remove('rol_usuario');
              // Navegar al login
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false,
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al cerrar sesión: $e')),
              );
            }
          }
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => item.destino!),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            item.assetIcono,
            width: 72, // Más grande, ajústalo a tu gusto
            height: 72,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 10),
          Text(
            item.titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.white,
              shadows: [
                Shadow(blurRadius: 3, color: Colors.black54, offset: Offset(0, 1)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
