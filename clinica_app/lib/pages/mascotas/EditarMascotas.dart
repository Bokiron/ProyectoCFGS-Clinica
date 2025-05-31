import 'dart:convert';
import 'dart:io';
import 'package:clinica_app/pages/data/GetMascotaDto.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditarMascota extends StatefulWidget {
  final GetMascotaDto mascota; // O tu modelo GetMascotaDto

  const EditarMascota({Key? key, required this.mascota}) : super(key: key);

  @override
  State<EditarMascota> createState() => _EditarMascotaState();
}

class _EditarMascotaState extends State<EditarMascota> {
  String tipoAnimal = "Perro";
  String genero = "Hembra";
  String tamano = "Grande";
  final nombreController = TextEditingController();
  final razaController = TextEditingController();
  final fechaNacimientoController = TextEditingController();
  final pesoController = TextEditingController();
  File? _imagenMascota;
  final List<String> tipos = ["Perro", "Gato", "Loros", "Conejo"];
  final List<String> tamanos = ["Pequeño", "Mediano", "Grande"];

  @override
void initState() {
  super.initState();
  final m = widget.mascota;
  nombreController.text = m.nombre;
  tipoAnimal = m.especie;
  razaController.text = m.raza;
  genero = m.sexo == 'HEMBRA' ? 'Hembra' : 'Macho';
  fechaNacimientoController.text = m.fechaNacimiento;
  pesoController.text = m.peso.toString();
  tamano = _tamanoToString(m.tamano);
  // ...
}
    // Si tienes la URL de la imagen, podrías mostrarla aquí también

  String _tamanoToString(dynamic t) {
    if (t == null) return "Grande";
    if (t.toString().toUpperCase().contains("PEQUENO")) return "Pequeño";
    if (t.toString().toUpperCase().contains("MEDIANO")) return "Mediano";
    return "Grande";
  }

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
          "Editar Mascota",
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
                  onTap: () async {
                    final picker = ImagePicker();
                    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      setState(() {
                        _imagenMascota = File(pickedFile.path);
                      });
                    }
                  },
                  child: _buildImagenMascota(),
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
          // Campo Nombre (solo lectura)
          TextField(
            controller: nombreController,
            enabled: false,
            decoration: const InputDecoration(
              labelText: "Nombre",
              border: UnderlineInputBorder(),
            ),
          ),

          // Tipo de animal (Dropdown, solo lectura)
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
                onChanged: null, // Deshabilitado
              ),
            ],
          ),

          // Campo Raza (editable)
          TextField(
            controller: razaController,
            enabled: false,
            decoration: const InputDecoration(
              labelText: "Raza",
              border: UnderlineInputBorder(),
            ),
          ),

          // Selector de sexo (solo lectura)
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
                //Boton Macho
                Expanded(
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
              ],
            ),
          ),

          // Fecha Nacimiento (solo lectura)
          TextField(
            controller: fechaNacimientoController,
            enabled: false,
            decoration: const InputDecoration(
              labelText: "Fecha de Nacimiento",
              border: UnderlineInputBorder(),
            ),
          ),

          // Peso (editable)
          TextField(
            controller: pesoController,
            decoration: const InputDecoration(
              labelText: "Peso KG",
              border: UnderlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),

          // Tamaño (Dropdown, editable)
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
                await actualizarMascota();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Actualizar Mascota",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> actualizarMascota() async {
    final id = widget.mascota.id;
    final url = Uri.parse('http://192.168.1.131:8080/mascotas/$id');
    final body = {
      "raza": razaController.text,
      "peso": double.tryParse(pesoController.text) ?? 0,
      "tamano": tamano.toUpperCase().replaceAll('Ñ', 'N'), // Reemplazamos el caracter Ñ por N
    };
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      if (_imagenMascota != null) {
        await _subirImagenMascota(id, _imagenMascota!);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mascota actualizada correctamente')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar mascota: ${response.body}')),
      );
    }
  }

  //mostrar imagen de la mascota si no se ha seleccionado una nueva
  Widget _buildImagenMascota() {
    if (_imagenMascota != null) {
      // Si el usuario seleccionó una nueva imagen, muéstrala
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(_imagenMascota!, width: 120, height: 120, fit: BoxFit.cover),
      );
    } else if (widget.mascota.imagenUrl != null && widget.mascota.imagenUrl!.isNotEmpty) {
      // Si la mascota ya tiene imagen, muéstrala desde la red
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          'http://192.168.1.131:8080/${widget.mascota.imagenUrl}',
          width: 120,
          height: 120,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.pets, size: 60, color: Colors.grey),
        ),
      );
    } else {
      // Si no hay imagen, muestra el icono de añadir
      return Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add_a_photo, size: 48, color: Colors.grey),
      );
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