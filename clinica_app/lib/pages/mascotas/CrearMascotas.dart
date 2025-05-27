import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegistroMascota extends StatefulWidget {
  const RegistroMascota({Key? key}) : super(key: key);

  @override
  State<RegistroMascota> createState() => _RegistroMascotaState();
}

class _RegistroMascotaState extends State<RegistroMascota> {
  String tipoAnimal = "Perro";
  String genero = "Hembra";
  String tamano = "Grande";
  final nombreController = TextEditingController();
  final razaController = TextEditingController();
  final fechaNacimientoController = TextEditingController();
  final pesoController = TextEditingController();
  File? _imagenMascota;
  final List<String> tipos = ["Perro", "Gato"];
  final List<String> tamanos = ["Pequeño", "Mediano", "Grande"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,//color appbar
        elevation: 0,
        //icono al comienzo
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Registro de Mascota",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        //icono al final
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.blueAccent, size: 28),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        children: [
          const SizedBox(height: 16),
          // Selector de foto
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _seleccionarImagen,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.greenAccent.shade100,
                    backgroundImage: _imagenMascota != null ? FileImage(_imagenMascota!) : null,
                    //si no hay imagen muestra un icono de +
                    child: _imagenMascota == null
                        ? Icon(Icons.add, size: 48, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Seleccionar la foto de tu mascota",
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          // Campo Nombre
          TextField(
            controller: nombreController,
            decoration: const InputDecoration(
              labelText: "Nombre",
              border: UnderlineInputBorder(),
            ),
          ),
          const SizedBox(height: 18),
          // Tipo de animal (Dropdown)
          Row(
            children: [
              const Text("Tipo de animal", style: TextStyle(color: Colors.black54)),
              const Spacer(),
              DropdownButton<String>(
                value: tipoAnimal,
                underline: const SizedBox(),
                items: tipos
                    .map((tipo) => DropdownMenuItem(
                          value: tipo,
                          child: Text(
                            tipo,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    tipoAnimal = value!;//actualiza el valor seleccionado
                  });
                },
              ),
            ],
          ),
          const Divider(),
          // Campo Raza
          TextField(
            controller: razaController,
            decoration: const InputDecoration(
              labelText: "Raza",
              border: UnderlineInputBorder(),
            ),
          ),
          const SizedBox(height: 18),
          // Selector de sexo Hembra/Macho
          const Text("Sexo", style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                //boton Hembra
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => genero = "Hembra"),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: genero == "Hembra"
                            ? Colors.greenAccent
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: const Text("Hembra",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                //Boton Macho
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => genero = "Macho"),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: genero == "Macho"
                            ? Colors.greenAccent
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: const Text("Macho",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          // Fecha Nacimiento
          TextField(
            controller: fechaNacimientoController,
            decoration: const InputDecoration(
              labelText: "Fecha de Nacimiento",
              border: UnderlineInputBorder(),
            ),
            //keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 18),
          // Peso
          TextField(
            controller: pesoController,
            decoration: const InputDecoration(
              labelText: "Peso KG",
              border: UnderlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 18),
          // Tamaño (Dropdown)
          Row(
            children: [
              const Text("Tamaño", style: TextStyle(color: Colors.black54)),
              const Spacer(),
              DropdownButton<String>(
                value: tamano,
                underline: const SizedBox(),
                items: tamanos
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(
                            t,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    tamano = value!;
                  });
                },
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 32),
          // Botón registrar mascota
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await registrarMascota();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Registrar Mascota",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> registrarMascota() async {
     // Obtiene el dni del usuario logueado desde SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final usuarioDni = prefs.getString('dni_usuario');
     // Si no hay usuario logueado, muestra un error y termina
    if (usuarioDni == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se encontró el usuario logueado')),
      );
      return;
    }
    // URL del endpoint para crear mascotas
    final url = Uri.parse('http://192.168.1.131:8080/mascotas');
    final body = {
      "nombre": nombreController.text.trim(),
      "especie": tipoAnimal,
      "raza": razaController.text.trim(),
      "fechaNacimiento": fechaNacimientoController.text.trim(), // formato dd/MM/yyyy
      "sexo": genero.toUpperCase(), // "MACHO" o "HEMBRA"
      "tamano": tamano.toUpperCase(), // "PEQUENO", "MEDIANO", "GRANDE"
      "peso": double.tryParse(pesoController.text.trim()) ?? 0.0, // Parsea el peso 
      "usuarioDni": usuarioDni
    };
    // Envía la petición POST al backend
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    // Si la respuesta es exitosa (código 201)
    if (response.statusCode == 201) {
      // Obtén el ID de la mascota creada
      final mascota = jsonDecode(response.body);
      final mascotaId = mascota['id'] as int;

      // Si se seleccionó una imagen, súbela
      if (_imagenMascota != null) {
        await _subirImagenMascota(mascotaId, _imagenMascota!);
      }

      //// Cierra la pantalla actual y vuelve a la anterior
      ///Devuelve true para que se recargue la lista de mascotas al navegar
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text("Mascota creada con éxito"),
            ],
          ),
          backgroundColor: Colors.green[700],
        ),
      );
    } else {
      // Si hay error, muestra el mensaje de error del backend
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al crear mascota: ${response.body}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  //permite seleccionar la imagen desde la gaelria
  Future<void> _seleccionarImagen() async {
    //Crea una instancia de ImagePicker para seleccionar imágenes
    final picker = ImagePicker();
    // Abre la galería y permite al usuario elegir una imagen
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    // Si el usuario seleccionó una imagen
    if (pickedFile != null) {
      // Actualiza el estado con el archivo de la imagen seleccionada
      setState(() {
        _imagenMascota = File(pickedFile.path);
      });
    }
  }
  Future<void> _subirImagenMascota(int mascotaId, File imagen) async {
    try {
      // URL del endpoint para subir la imagen de la mascota
      final url = Uri.parse('http://192.168.1.131:8080/mascotas/$mascotaId/imagen');
      // Crea una petición multipart para enviar el archivo
      final request = http.MultipartRequest('POST', url);
      // Añade la imagen al cuerpo de la petición
      request.files.add(await http.MultipartFile.fromPath('imagen', imagen.path));
      // Envía la petición y espera la respuesta
      final response = await request.send();
      // Lee el cuerpo de la respuesta para debug
      final responseBody = await response.stream.bytesToString();
      // Si la respuesta no es 200, muestra el error en consola
      if (response.statusCode != 200) {
        // Muestra el error por consola
        print('Error al subir imagen: Código ${response.statusCode}, body: $responseBody');
      }
    } catch (e) {
      // Captura errores de red o excepciones y los muestra en consola
      print('Error al subir imagen: $e');
    }
  }


}
