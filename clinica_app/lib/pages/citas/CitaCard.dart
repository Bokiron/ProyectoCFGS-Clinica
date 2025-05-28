import 'package:flutter/material.dart';

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

