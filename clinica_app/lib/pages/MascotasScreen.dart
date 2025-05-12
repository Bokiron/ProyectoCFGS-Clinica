import 'package:clinica_app/pages/CrearMascotas.dart';
import 'package:flutter/material.dart';

class Mascotas extends StatefulWidget {
  const Mascotas({Key? key}) : super(key: key);

  @override
  _MascotasState createState() => _MascotasState();
}

class _MascotasState extends State<Mascotas> {
  // Ejemplo de lista de mascotas
  final List<Map<String, dynamic>> mascotas = [
    {
      "nombre": "Nana",
      "raza": "Teckel",
      "fechaNacimiento": "13/04/2015",
      "peso": "10 Kg",
      "tamano": "Mediana",
      "foto": "https://images.ctfassets.net/550nf1gumh01/yh0l63Foctzv7067YDNhO/e391cd9ef39818a77484e5b1fd29f5bc/iStock-145053225.jpg?q=90&w=1240",
      "sexo": "hembra",
      "especie": "Perro"
    },
    // Puedes agregar más mascotas aquí
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar personalizado
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
              // Acción para funciones de usuario
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mascotas.length,
        itemBuilder: (context, index) {
          final mascota = mascotas[index];
          return _mascotaCard(mascota);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Acción para agregar mascota
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegistroMascota()),
          );
        },
        label: const Text("Agregar mascota", style: TextStyle(color: Colors.white),),
        icon: const Icon(Icons.add_circle_outline, color: Colors.white,),
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // Widget para la card de cada mascota
  Widget _mascotaCard(Map<String, dynamic> mascota) {
    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto de la mascota
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(
                mascota["foto"],
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            // Info principal
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        mascota["nombre"],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        mascota["sexo"] == "hembra"
                            ? Icons.female
                            : Icons.male,
                        color: Colors.pink,
                        size: 18,
                      ),
                      const SizedBox(width: 8),

                      // Etiqueta especie (Perro, Gato, etc.)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          mascota["especie"],
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
                    mascota["raza"],
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Fecha Nacimiento: ${mascota["fechaNacimiento"]}\nPeso: ${mascota["peso"]}\nTamaño: ${mascota["tamano"]}",
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  // Botón "Ver Vacunas"
                  OutlinedButton.icon(
                    onPressed: () {
                      // Acción para ver vacunas
                    },
                    icon: const Icon(Icons.vaccines, size: 18, color: Colors.blue),
                    label: const Text(
                      "Ver Vacunas",
                      style: TextStyle(color: Colors.blue),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
