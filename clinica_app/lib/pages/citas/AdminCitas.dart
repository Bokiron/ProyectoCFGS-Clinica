import 'dart:convert';
import 'package:clinica_app/pages/citas/CitaCard.dart';
import 'package:clinica_app/pages/usuario/UsuarioScreen.dart';
import 'package:clinica_app/pages/utils/auth_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';

class AdminCitas extends StatefulWidget {
  const AdminCitas({Key? key}) : super(key: key);

  @override
  State<AdminCitas> createState() => _AdminCitasState();
}

class _AdminCitasState extends State<AdminCitas> {
  DateTime _fechaSeleccionada = DateTime.now();
  int _selectedEspacio = 0; // 0: Consulta, 1: Peluquería
  List<Map<String, dynamic>> citasConfirmadas = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    cargarCitasConfirmadas();
  }

  Future<void> cargarCitasConfirmadas() async {
    setState(() { loading = true; });
    final espacio = _selectedEspacio == 0 ? 'CONSULTA' : 'PELUQUERIA';
    final fechaFormateada = "${_fechaSeleccionada.day.toString().padLeft(2, '0')}/"
        "${_fechaSeleccionada.month.toString().padLeft(2, '0')}/"
        "${_fechaSeleccionada.year}";
    final url = 'http://192.168.1.131:8080/citas/confirmadas?fecha=$fechaFormateada&espacio=$espacio';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': basicAuthHeader('root', '1234')
        },
      );
      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          citasConfirmadas = data.cast<Map<String, dynamic>>();
          loading = false;
        });
      } else {
        setState(() {
          citasConfirmadas = [];
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        citasConfirmadas = [];
        loading = false;
      });
    }
  }

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
        centerTitle: true,
        title: const Text(
          "Agenda",
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
            // Selector de espacio
            Container(
              margin: const EdgeInsets.only(bottom: 8, top: 8),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() { _selectedEspacio = 0; });
                        cargarCitasConfirmadas();
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
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() { _selectedEspacio = 1; });
                        cargarCitasConfirmadas();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedEspacio == 1 ? Colors.lightBlueAccent : Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Peluquería',
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
            // Calendario
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _fechaSeleccionada,
              selectedDayPredicate: (day) => isSameDay(_fechaSeleccionada, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _fechaSeleccionada = selectedDay;
                });
                cargarCitasConfirmadas();
              },
              calendarStyle: const CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.greenAccent,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),
            const SizedBox(height: 12),
            // Lista de citas confirmadas
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : citasConfirmadas.isEmpty
                      ? const Center(
                          child: Text('No hay citas confirmadas para este día y espacio.'),
                        )
                      : ListView.builder(
                          itemCount: citasConfirmadas.length,
                          itemBuilder: (context, index) {
                            final cita = citasConfirmadas[index];
                            return CitaCard(cita: cita);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
