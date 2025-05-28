import 'dart:convert';
import 'package:clinica_app/pages/citas/CitaCard.dart';
import 'package:clinica_app/pages/usuario/UsuarioScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CitasScreen extends StatefulWidget {
  const CitasScreen({Key? key}) : super(key: key);

  @override
  CitasScreenState createState() => CitasScreenState();
}

class CitasScreenState extends State<CitasScreen> {
  //Recupera el DNI del usuario logueado desde el almacenamiento local para identificarlo en el backend.
  Future<String?> obtenerDniOEmailUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('dni_usuario');
  }
  //Peticion get para obtener las citas del usuario
  Future<List<Map<String, dynamic>>> obtenerCitasUsuario(String dni) async {
    final url = 'http://192.168.1.131:8080/citas/usuario/$dni/proximas';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Error al cargar las citas');
    }
  }
  //peticion patch para cambiar el estado de una cita
  Future<bool> cancelarCita(int idCita) async {
    final url = 'http://192.168.1.131:8080/citas/$idCita';
    final response = await http.patch(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'estado': 'CANCELADA'}),
    );
    return response.statusCode == 200;
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold es el widget base de la pantalla, que incluye appBar y body
    return Scaffold(
      // Color de fondo de la pantalla
      backgroundColor: const Color(0xFFF4F4F4),
      // Barra superior de la pantalla
            // AppBar personalizado con botón de retroceso y título
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Mis Citas",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.blueAccent),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UsuarioScreen()),
              );
            },
          ),
        ],
      ),
      // Body es el contenido principal de la pantalla
      body: FutureBuilder<String?>(
        // Future que obtiene el DNI del usuario desde SharedPreferences
        future: obtenerDniOEmailUsuario(),
        builder: (context, snapshotDni) {
          // Si está cargando, muestra un spinner
          if (snapshotDni.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Obtiene el DNI del snapshot
          final dni = snapshotDni.data;
          // Si no hay DNI, muestra un mensaje de error
          if (dni == null) {
            return const Center(child: Text('No se encontró el usuario.'));
          }
          // Si hay DNI, hace otra petición para obtener las citas del usuario
          return FutureBuilder<List<Map<String, dynamic>>>(
            // Future que obtiene las citas del usuario usando el DNI
            future: obtenerCitasUsuario(dni),
            builder: (context, snapshot) {
              // Si está cargando, muestra un spinner
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              // Si hay error, muestra el mensaje de error
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              // Obtiene la lista de citas del snapshot. Si es null, la lista es vacía
              final citas = snapshot.data ?? [];
              // Si no hay citas, muestra un mensaje amigable con un icono
              if (citas.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_busy, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Aún no has reservado ninguna cita.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }
              // Si hay citas, muestra la lista con posibilidad de refrescar
              return RefreshIndicator(
                // Al refrescar, llama a setState para recargar los datos
                onRefresh: () async {
                  setState(() {});
                },
                // ListView que muestra cada cita en una tarjeta
                child: ListView.builder(
                  // Número de citas
                  itemCount: citas.length,
                  // Por cada cita, crea una CitaCard
                  itemBuilder: (context, index) {
                    final cita = citas[index];
                    return CitaCard(
                      // Pasa los datos de la cita
                      cita: cita,
                      // Si la cita está confirmada, permite cancelarla
                      onCancelar: (cita['estado'] ?? '') == 'CONFIRMADA'
                          ? () async {
                              // Llama al método para cancelar la cita
                              final cancelado = await cancelarCita(cita['id']);
                              // Si se cancela correctamente, refresca la lista y muestra un SnackBar
                              if (cancelado) {
                                setState(() {});
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Cita cancelada correctamente.'),
                                  ),
                                );
                              }
                            }
                          : null, // Si no está confirmada, no permite cancelar
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}