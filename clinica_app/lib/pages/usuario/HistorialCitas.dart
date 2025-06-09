import 'dart:convert';
import 'package:clinica_app/pages/utils/appConfig.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HistorialCitas extends StatefulWidget {
  const HistorialCitas({Key? key}) : super(key: key);

  @override
  HistorialCitasState createState() => HistorialCitasState();
}

class HistorialCitasState extends State<HistorialCitas> {
  //Recupera el DNI del usuario logueado desde el almacenamiento local para identificarlo en el backend.
  Future<String?> obtenerDniOEmailUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('dni_usuario');
  }
  //Peticion get para obtener las citas del usuario
  Future<List<Map<String, dynamic>>> obtenerCitasUsuario(String dni) async {
    final url = '${AppConfig.baseUrl}/citas/usuario/$dni/historial';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Error al cargar las citas');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold es el widget base de la pantalla, que incluye appBar y body
    return Scaffold(
      // Color de fondo de la pantalla
      backgroundColor: const Color(0xFFF4F4F4),
      // Barra superior de la pantalla
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Historial Citas",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
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

// Widget aparte para la card de las citas
class CitaCard extends StatelessWidget {
  // Datos de la cita que se mostrarán en la tarjeta
  final Map<String, dynamic> cita;
  // Función opcional que se llama al cancelar la cita (solo si está confirmada)
  final VoidCallback? onCancelar;

  // Constructor de la tarjeta
  const CitaCard({Key? key, required this.cita, this.onCancelar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      // Margen alrededor de la tarjeta
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      // Elevación para dar efecto de sombra
      elevation: 3,
      // Bordes redondeados
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // Relleno interno de la tarjeta
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          // Alineación del contenido a la izquierda
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fila superior: icono de calendario, fecha y hora, y chip de estado
            Row(
              children: [
                // Icono de calendario
                Icon(Icons.calendar_today, color: Colors.blueAccent),
                SizedBox(width: 8),
                // Fecha y hora de la cita
                Text(
                  '${cita['fecha'] ?? ''} - ${cita['hora'] ?? ''}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                // Espacio flexible para separar el texto del chip
                Spacer(),
                // GestureDetector para hacer el chip interactivo
                GestureDetector(
                  // Solo permite pulsar si onCancelar no es null (solo si la cita está confirmada)
                  onTap: onCancelar == null
                      ? null
                      : () {
                          // Muestra un diálogo de confirmación al pulsar el chip
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Cancelar cita'),
                              content: Text('¿Estás seguro de que quieres cancelar esta cita?'),
                              actions: [
                                // Botón "No" para cerrar el diálogo
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('No'),
                                ),
                                // Botón "Sí" para cancelar la cita
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Cierra el diálogo
                                    onCancelar!(); // Llama a la función de cancelación
                                  },
                                  child: Text('Sí'),
                                ),
                              ],
                            ),
                          );
                        },
                  // Chip que muestra el estado de la cita
                  child: Chip(
                    label: Text(
                      cita['estado'] ?? '',
                      style: TextStyle(color: Colors.white),
                    ),
                    // Color verde si está confirmada, rojo si está cancelada
                    backgroundColor: (cita['estado'] ?? '') == 'CONFIRMADA'
                        ? Colors.green
                        : Colors.redAccent,
                  ),
                ),
              ],
            ),
            // Espacio entre filas
            SizedBox(height: 8),
            // Fila de información de la mascota y el servicio
            Row(
              children: [
                // Icono de mascota
                Icon(Icons.pets, color: Colors.teal, size: 20),
                SizedBox(width: 4),
                // Nombre de la mascota
                Text('Mascota: ${cita['mascota']?['nombre'] ?? ''}'),
                SizedBox(width: 12),
                // Icono de servicio
                Icon(Icons.medical_services, color: Colors.purple, size: 20),
                SizedBox(width: 4),
                // Nombre del servicio
                Text('Servicio: ${cita['servicio']?['nombre'] ?? ''}'),
              ],
            ),
            // Espacio entre filas
            SizedBox(height: 8),
            // Fila de información del espacio y motivo
            Row(
              children: [
                // Icono de ubicación
                Icon(Icons.location_on, color: Colors.orange, size: 20),
                SizedBox(width: 4),
                // Nombre del espacio
                Text('Espacio: ${cita['espacio'] ?? ''}'),
                SizedBox(width: 12),
                // Icono de notas
                Icon(Icons.notes, color: Colors.grey, size: 20),
                SizedBox(width: 4),
                // Motivo de la cita, expandido para que no se corte el texto
                Expanded(child: Text('Motivo: ${cita['motivo'] ?? ''}')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

