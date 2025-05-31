import 'dart:convert';
import 'package:clinica_app/pages/mascotas/CrearMascotas.dart';
import 'package:clinica_app/pages/mascotas/EditarMascotas.dart';
import 'package:clinica_app/pages/data/GetMascotaDto.dart';
import 'package:clinica_app/pages/usuario/UsuarioScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Mascotas extends StatefulWidget {
  const Mascotas({Key? key}) : super(key: key);

  @override
  _MascotasState createState() => _MascotasState();
}

class _MascotasState extends State<Mascotas> {
  // Lista que almacenará las mascotas obtenidas del backend
  List<GetMascotaDto> mascotas = [];

  // Indica si la pantalla está cargando datos (para mostrar un loader)
  bool isLoading = true;

  // Mensaje de error, si ocurre alguno al cargar los datos
  String? errorMsg;

  // Método especial del ciclo de vida de Flutter:
  // Se llama automáticamente una vez cuando el widget se inserta en el árbol de widgets.
  // Ideal para inicializar datos asíncronos.
  @override
  void initState() {
    super.initState();
    cargarMascotasDelUsuario(); // Llama a la función que obtiene las mascotas del usuario logueado
  }

  // Método que construye la interfaz de usuario.
  // Se llama cada vez que se actualiza el estado del widget (por ejemplo, tras llamar a setState).
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Mis Mascotas",
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
      // El cuerpo de la pantalla varía según el estado de carga y si hay error
      body: isLoading
        // Si está cargando, muestra un indicador de progreso
        ? Center(child: CircularProgressIndicator())
        // Si hay error, muestra el mensaje de error
        : errorMsg != null
            ? Center(child: Text(errorMsg!))
            // Si no hay error y ya cargó, muestra la lista de mascotas
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: mascotas.length,
                itemBuilder: (context, index) {
                  final mascota = mascotas[index];
                  return _mascotaCard(mascota); // Construye la tarjeta de cada mascota
                },
              ),
      // Botón flotante para agregar una nueva mascota
      floatingActionButton: FloatingActionButton.extended(
        // Navegación a la pantalla de crear mascota
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegistroMascota()),
          );
          // Si se ha creado una mascota, refresca la lista de mascotas del usuario(para que salga ya la nueva mascota, si ha creado alguna)
          if (result == true) {
            await cargarMascotasDelUsuario();
          }
        },
        label: const Text("Agregar mascota", style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add_circle_outline, color: Colors.white),
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // Widget que construye la tarjeta visual de cada mascota
  // Recibe un objeto GetMascotaDto con los datos de la mascota
  Widget _mascotaCard(GetMascotaDto mascota) {
    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar circular con icono o imagen de mascota
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.greenAccent.shade100,
              backgroundImage: (mascota.imagenUrl != null && mascota.imagenUrl!.isNotEmpty)
                  ? NetworkImage('http://192.168.1.131:8080/${mascota.imagenUrl}')
                  : null,
              child: (mascota.imagenUrl == null || mascota.imagenUrl!.isEmpty)
                  ? Icon(Icons.pets, color: Colors.white, size: 28)
                  : null,
            ),
            const SizedBox(width: 16),
            // Información principal de la mascota
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        mascota.nombre,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        mascota.sexo.toLowerCase() == "hembra"
                            ? Icons.female
                            : Icons.male,
                        color: Colors.pink,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          mascota.especie,
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    mascota.raza,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Fecha Nacimiento: ${mascota.fechaNacimiento}\nPeso: ${mascota.peso} Kg\nTamaño: ${mascota.tamano}",
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  // Fila de botones: Editar y Eliminar
                  Row(
                    children: [
                      // Botón Editar
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditarMascota(mascota: mascota)),
                            );
                            if (result == true) {
                              await cargarMascotasDelUsuario();
                            }                   
                          },
                          icon: const Icon(Icons.edit, size: 18, color: Colors.orangeAccent),
                          label: const Text(
                            "Editar Mascota",
                            style: TextStyle(color: Colors.orangeAccent),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.orangeAccent),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Botón Eliminar
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            // Lógica de eliminación (ver siguiente punto)
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Eliminar mascota'),
                                content: const Text('¿Seguro que quieres eliminar esta mascota? Esta acción no se puede deshacer.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              await eliminarMascota(mascota.id);
                            }
                          },
                          icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                          label: const Text(
                            "Eliminar",
                            style: TextStyle(color: Colors.redAccent),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.redAccent),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Función que hace la petición HTTP al backend para obtener las mascotas del usuario
  // Recibe el dni o email y devuelve una lista de objetos GetMascotaDto
  Future<List<GetMascotaDto>> fetchMascotasUsuario(String dniOrEmail) async {
    final url = Uri.parse('http://192.168.1.131:8080/mascotas/buscar?dniOrEmail=$dniOrEmail');
    final response = await http.get(url);

    // Imprime en consola el código de estado y el cuerpo de la respuesta para depuración
    print('Mascotas API status: ${response.statusCode}');
    print('Mascotas API body: ${response.body}');

    if (response.statusCode == 200) {
      // Decodifica el JSON y convierte cada elemento en un objeto GetMascotaDto
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => GetMascotaDto.fromJson(json)).toList();
    } else {
      // Si ocurre un error, lanza una excepción con información detallada
      throw Exception('Error al cargar mascotas: ${response.statusCode} - ${response.body}');
    }
  }

  // Método asíncrono que obtiene el dni/email del usuario guardado en SharedPreferences
  // y luego hace una petición HTTP para obtener sus mascotas.
  Future<void> cargarMascotasDelUsuario() async {
    try {
      // Recupera el dni o email del usuario logueado
      final dniOrEmail = await obtenerDniUsuario();

      // Si no hay usuario logueado, muestra un mensaje de error
      if (dniOrEmail == null) {
        setState(() {
          errorMsg = 'No hay usuario logueado';
          isLoading = false;
        });
        return;
      }

      // Llama al método que obtiene la lista de mascotas del backend
      final resultado = await fetchMascotasUsuario(dniOrEmail);

      // Actualiza el estado con la lista de mascotas y oculta el loader
      setState(() {
        mascotas = resultado;
        isLoading = false;
      });
    } catch (e) {
      /*// Si ocurre un error (de red, backend, parsing, etc.), muestra mensaje de error
      setState(() {
        errorMsg = 'Error al cargar mascotas: $e';
        isLoading = false;
      });*/
    }
  }

  // Función que obtiene el dni o email del usuario logueado desde SharedPreferences
  Future<String?> obtenerDniUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('dni_usuario'); // Cambia la clave si usas otro nombre
  }

  Future<void> eliminarMascota(int mascotaId) async {
    final url = Uri.parse('http://192.168.1.131:8080/mascotas/$mascotaId');
    final response = await http.delete(url);

    if (response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mascota eliminada correctamente')),
      );
      // Recarga la lista de mascotas
      await cargarMascotasDelUsuario();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar mascota: ${response.body}')),
      );
    }
  }
}
