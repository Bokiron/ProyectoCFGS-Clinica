
import 'dart:convert';
import 'package:clinica_app/pages/usuario/UsuarioScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class Pedircita extends StatefulWidget {
  const Pedircita({Key? key}) : super(key: key);

  @override
  PedircitaState createState() => PedircitaState();
}

class PedircitaState extends State<Pedircita> {
  DateTime _fechaSeleccionada = DateTime.now();

  List<String> get horasDisponibles {
    //hora actual
    final now = DateTime.now();
    //dia de hoy
    final isToday = isSameDay(_fechaSeleccionada, now);
    //carga las horas de cada espacio
    final horas = _selectedEspacio == 0
        ? ["09:30", "10:30", "11:30", "12:30", "16:30", "17:30", "18:30"]//horas consulta
        : ["10:00", "11:00", "12:00", "13:00", "17:00", "18:00"];//horas peluqueria

    if (!isToday) return horas;//devuelve todas las horas

    // Si es hoy, filtrar las horas que aún no han pasado
    final horaActual = now.hour * 60 + now.minute;
    return horas.where((hora) {
      final parts = hora.split(':');
      final h = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      final minutos = h * 60 + m;
      return minutos > horaActual;
    }).toList();
  }

  List<String> horasOcupadas = [];
  List<String> horasLibres = [];

  int _selectedEspacio = 0; // 0: Peluquería, 1: Consulta
  //variables para la reserva de la cita
  String motivo = ''; // Variable de estado para el motivo
  String? nombreUsuario;
  String? emailUsuario;
  String? telefonoUsuario;
  List<Map<String, dynamic>> mascotasUsuario = [];
  String? mascotaSeleccionada;
  String? servicioSeleccionado;
  //definir servicios disponibles, segun el espacio
  List<Map<String, dynamic>> serviciosDisponibles = [];

  
  @override
  void initState() {
    super.initState();
    cargarHorasOcupadas();
    cargarDatosUsuarioYmascotas();
    loadServicios();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
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
          "Reservar Cita",
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
        child: Column(
          children: [
            // --- Selector de espacio: Consulta o Peluquería ---
            Container(
              margin: const EdgeInsets.only(bottom: 16, top: 8),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  // Botón para seleccionar "Consulta"
                  Expanded(
                    child: GestureDetector(
                      //Cuando se cambie de espacio debe cargar los servicios
                      onTap: () {
                        setState(() {
                          _selectedEspacio = 0;
                        });
                        cargarHorasOcupadas();
                        loadServicios();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedEspacio == 0 ? Colors.lightBlueAccent : Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Consulta',
                          style: TextStyle(
                            color: _selectedEspacio == 0 ? Colors.white : Colors.lightBlueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Botón para seleccionar "Peluquería"
                  Expanded(
                    child: GestureDetector(
                      //Al cambiar de espacio debe refrescar los servicios
                      onTap: () {
                        setState(() {
                          _selectedEspacio = 1;
                        });
                        cargarHorasOcupadas();
                        loadServicios();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedEspacio == 1 ? Colors.lightBlueAccent : Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Peluqueria',
                          style: TextStyle(
                            color: _selectedEspacio == 1 ? Colors.white : Colors.lightBlueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- Calendario para seleccionar la fecha ---
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: TableCalendar(
                focusedDay: _fechaSeleccionada,
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(const Duration(days: 30)),
                calendarFormat: CalendarFormat.month,
                onDaySelected: (selectedDay, _) {
                  setState(() {
                    _fechaSeleccionada = selectedDay;
                  });
                  // Recarga las horas según dia y espacio seleccionado
                  cargarHorasOcupadas();
                },
                selectedDayPredicate: (day) {
                  return isSameDay(_fechaSeleccionada, day);
                },
                calendarStyle: const CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // --- Título de la sección de horas disponibles ---
            const Text(
              'Horas disponibles:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),

            // --- Lista de horas disponibles ---
            Expanded(
              child: horasLibres.isEmpty
              ? Center(
                  child: Text(
                    "No hay horas disponibles para este día.",
                    style: TextStyle(fontSize: 18, color: Colors.redAccent),
                  ),
                )
              : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemCount: horasLibres.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.access_time,
                        color: Colors.lightBlueAccent,
                      ),
                      title: Text(
                        horasLibres[index],
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      // --- Botón para reservar la hora seleccionada ---
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Al pulsar "Reservar" se muestra el diálogo de confirmación
                          showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    title: const Text(
                                      "Reservar cita",
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // --- Dropdown para seleccionar el servicio ---
                                        Text("Servicio:", style: TextStyle(fontWeight: FontWeight.bold)),
                                        DropdownButton<String>(
                                          value: servicioSeleccionado,
                                          isExpanded: true,
                                          //forzamos a Dart a entender que cada ítem es un DropdownMenuItem<String>. Sino lo toma como Object
                                          items: serviciosDisponibles.map<DropdownMenuItem<String>>((servicio) {
                                            return DropdownMenuItem<String>(
                                              value: servicio['nombre'].toString(), // Asegura que sea String
                                              child: Text(servicio['nombre'].toString()),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              servicioSeleccionado = value!;
                                            });
                                          },
                                        ),

                                        const SizedBox(height: 10),
                                        // --- Dropdown para seleccionar la mascota ---
                                        Text("Mascota:", style: TextStyle(fontWeight: FontWeight.bold)),
                                        DropdownButton<String>(
                                          value: mascotaSeleccionada,
                                          isExpanded: true,
                                          items: mascotasUsuario.map((mascota) {
                                            final nombre = mascota['nombre']?.toString() ?? '';
                                            return DropdownMenuItem<String>(
                                              value: nombre,
                                              child: Text(nombre),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              mascotaSeleccionada = value!;
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        // Añade este widget antes de los Dropdowns
                                        TextFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Motivo',
                                            hintText: 'Ej: Vacunación anual',
                                          ),
                                          onChanged: (value) => motivo = value,
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      // Botón para cancelar la reserva
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("CANCELAR", style: TextStyle(color: Colors.grey)),
                                      ),
                                      // Botón para confirmar la reserva
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.lightBlueAccent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        onPressed: () async {
                                          try{

                                          
                                          final horaSeleccionada = horasLibres[index]; //Variable para la hora Ej: "10:00"
                                          final fecha = "${_fechaSeleccionada.day.toString().padLeft(2, '0')}/"
                                          "${_fechaSeleccionada.month.toString().padLeft(2, '0')}/"
                                          "${_fechaSeleccionada.year}"; // Formato dd/MM/yyyy

                                          // Obtener servicio seleccionado
                                          final servicio = serviciosDisponibles.firstWhere(
                                            (s) => s['nombre'] == servicioSeleccionado,
                                            orElse: () => {},
                                          );

                                          // Obtener mascota seleccionada
                                          final mascota = mascotasUsuario.firstWhere(
                                            (m) => m['nombre'] == mascotaSeleccionada,
                                            orElse: () => {},
                                          );
                                            
                                          final prefs = await SharedPreferences.getInstance();
                                          final usuarioDni = prefs.getString('dni_usuario');
                                          
                                          if (servicio.isEmpty || mascota.isEmpty || usuarioDni == null) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Complete todos los campos')),
                                            );
                                            return;
                                          }

                                          final body = jsonEncode({
                                            'fecha': fecha,
                                            'hora': horaSeleccionada,
                                            'espacio': _selectedEspacio == 0 ? 'CONSULTA' : 'PELUQUERIA',
                                            'motivo': motivo,
                                            'estado': 'CONFIRMADA',
                                            'mascotaId': mascota['id'],
                                            'usuarioDni': usuarioDni,
                                            'servicioId': servicio['id'],
                                          });

                                          final response = await http.post(
                                            Uri.parse('http://192.168.1.131:8080/citas'),
                                            headers: {'Content-Type': 'application/json'},
                                            body: body,
                                          );

                                          cargarHorasOcupadas();//cargar horas ocupadas al reservar una cita para que desaparezca

                                          Navigator.pop(context);
                                          if (response.statusCode == 201) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Cita creada para ${mascota['nombre']}'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Error: ${response.body}'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Error: ${e.toString()}'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      },

                                        child: const Text("CONFIRMAR RESERVA", style: TextStyle(color: Colors.white)),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        child: const Text(
                          'Reservar',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> cargarDatosUsuarioYmascotas() async {
    // Obtiene una instancia de SharedPreferences para acceder a los datos guardados.
    final prefs = await SharedPreferences.getInstance();
    // Recupera el dni o email del usuario logueado desde SharedPreferences.
    final dniOrEmail = prefs.getString('dni_usuario');
    //Si no hay usuario logueado, termina la función.
    if (dniOrEmail == null) return;

    //Hace una petición HTTP GET al endpoint de usuario para obtener sus datos.
    final usuarioResp = await http.get(
      Uri.parse('http://192.168.1.131:8080/usuarios/buscar?dniOrEmail=$dniOrEmail')
    );

    //Si la respuesta es exitosa (código 200):
    if (usuarioResp.statusCode == 200) {
      //Decodifica el JSON recibido.
      final usuario = jsonDecode(usuarioResp.body);

      //Actualiza el estado con los datos del usuario (nombre completo, email, teléfono).
      setState(() {
        nombreUsuario = "${usuario['nombre']} ${usuario['apellidos'] ?? ''}";
        emailUsuario = usuario['email'];
        telefonoUsuario = usuario['telefono'];
      });
    }

    //Hace una petición HTTP GET al endpoint de mascotas para obtener las mascotas del usuario.
    final mascotasResp = await http.get(
      Uri.parse('http://192.168.1.131:8080/mascotas/buscar?dniOrEmail=$dniOrEmail')
    );

    //Si la respuesta es exitosa (código 200):
    if (mascotasResp.statusCode == 200) {
      //Decodifica el JSON recibido (lista de mascotas).
      final List<dynamic> mascotasJson = jsonDecode(mascotasResp.body);

      //Actualiza el estado con la lista de mascotas.
      setState(() {
        mascotasUsuario = mascotasJson.cast<Map<String, dynamic>>();

        //Si hay al menos una mascota, selecciona la primera por defecto.
        if (mascotasUsuario.isNotEmpty) {
          mascotaSeleccionada = mascotasUsuario[0]['nombre'];
        }
      });
    }
  }
  //obtiene los servicios para el espacio correspondiente
  Future<List<Map<String, dynamic>>> fetchServicios(String espacio) async {
    final response = await http.get(
      Uri.parse('http://192.168.1.131:8080/servicios?espacioServicio=$espacio'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Error al cargar servicios');
    }
  }
  // Llamar a _loadServicios() en initState() y cada vez que cambie _selectedEspacio
  Future<void> loadServicios() async {
    final espacio = _selectedEspacio == 0 ? "CONSULTA" : "PELUQUERIA";
    final url = 'http://192.168.1.131:8080/servicios?espacioServicio=$espacio';
    //log de depuración
    print('Cargando servicios desde: $url');
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      setState(() {
        serviciosDisponibles = jsonList.cast<Map<String, dynamic>>();
        servicioSeleccionado = serviciosDisponibles.isNotEmpty
            ? serviciosDisponibles[0]['nombre'].toString()
            : null;
      });
    } else {
      print('Error al cargar servicios: ${response.statusCode} ${response.body}');
      throw Exception('Error al cargar servicios');
    }
  }

  //metodo para saber horas ocupadas
  Future<void> cargarHorasOcupadas() async {
    final espacio = _selectedEspacio == 0 ? 'CONSULTA' : 'PELUQUERIA';
    final fechaFormateada = "${_fechaSeleccionada.day.toString().padLeft(2, '0')}/"
        "${_fechaSeleccionada.month.toString().padLeft(2, '0')}/"
        "${_fechaSeleccionada.year}";

    print("[DEBUG] Consultando horas ocupadas para $fechaFormateada y $espacio");
    print("[DEBUG] Horas posibles: $horasDisponibles");

    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.131:8080/citas/ocupadas?fecha=$fechaFormateada&espacio=$espacio'),
      );
      print("[DEBUG] Status code: ${response.statusCode}");
      print("[DEBUG] Response body: ${response.body}");

      if (response.statusCode == 200) {
        final ocupadas = List<String>.from(jsonDecode(response.body));
        print("[DEBUG] Horas ocupadas recibidas: $ocupadas");
        setState(() {
          horasOcupadas = ocupadas;
          horasLibres = horasDisponibles.where((h) => !horasOcupadas.contains(h)).toList();
          print("[DEBUG] Horas libres calculadas: $horasLibres");
        });
      } else {
        setState(() {
          horasOcupadas = [];
          horasLibres = horasDisponibles;
        });
        print("[DEBUG] Error al consultar horas ocupadas. Se muestran todas como libres.");
      }
    } catch (e) {
      setState(() {
        horasOcupadas = [];
        horasLibres = horasDisponibles;
      });
      print('[DEBUG] Excepción al consultar horas ocupadas: $e');
    }
  }
}
