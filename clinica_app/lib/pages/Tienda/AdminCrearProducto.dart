import 'dart:convert';
import 'dart:io';
import 'package:clinica_app/pages/utils/appConfig.dart';
import 'package:clinica_app/pages/utils/auth_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminCrearProductoScreen extends StatefulWidget {
  const AdminCrearProductoScreen({Key? key}) : super(key: key);

  @override
  State<AdminCrearProductoScreen> createState() => _AdminCrearProductoScreenState();
}

class _AdminCrearProductoScreenState extends State<AdminCrearProductoScreen> {
  final nombreController = TextEditingController();
  final marcaController = TextEditingController();
  final descripcionController = TextEditingController();
  final precioController = TextEditingController();

  File? _imagenProducto;

  // Opciones de enums (ajusta según tus enums de backend)
  final List<String> categorias = [
    "ALIMENTACION", "ANTIINFLAMATORIO", "ARENAS", "ANTIPARASITARIO",
    "COMPLEMENTO_NUTRICIONAL", "DERMATOLOGIA", "HIGIENE", "JUGUETES"
  ];
  final List<String> especies = ["PERRO", "GATO", "LOROS", "CONEJO"];
  String categoriaSeleccionada = "ALIMENTACION";
  List<String> especiesSeleccionadas = [];

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
          "Crear Producto",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                    backgroundColor: Colors.blueAccent.shade100,
                    backgroundImage: _imagenProducto != null ? FileImage(_imagenProducto!) : null,
                    child: _imagenProducto == null
                        ? Icon(Icons.add, size: 48, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Seleccionar foto del producto",
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
          // Campo Marca
          TextField(
            controller: marcaController,
            decoration: const InputDecoration(
              labelText: "Marca",
              border: UnderlineInputBorder(),
            ),
          ),
          const SizedBox(height: 18),
          // Categoría (Dropdown)
          Row(
            children: [
              const Text("Categoría", style: TextStyle(color: Colors.black54)),
              const Spacer(),
              DropdownButton<String>(
                value: categoriaSeleccionada,
                underline: const SizedBox(),
                items: categorias
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    categoriaSeleccionada = value!;
                  });
                },
              ),
            ],
          ),
          const Divider(),
          // Especies (Chips seleccionables)
          const Text("Especies", style: TextStyle(color: Colors.black54)),
          Wrap(
            spacing: 8,
            children: especies.map((especie) {
              final selected = especiesSeleccionadas.contains(especie);
              return FilterChip(
                label: Text(especie),
                selected: selected,
                onSelected: (bool value) {
                  setState(() {
                    if (value) {
                      especiesSeleccionadas.add(especie);
                    } else {
                      especiesSeleccionadas.remove(especie);
                    }
                  });
                },
                selectedColor: Colors.blueAccent,
                checkmarkColor: Colors.white,
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          // Descripción
          TextField(
            controller: descripcionController,
            decoration: const InputDecoration(
              labelText: "Descripción",
              border: UnderlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 18),
          // Precio
          TextField(
            controller: precioController,
            decoration: const InputDecoration(
              labelText: "Precio (€)",
              border: UnderlineInputBorder(),
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 32),
          // Botón crear producto
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await _crearProducto();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Crear Producto",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _crearProducto() async {
    // Validación básica
    if (nombreController.text.trim().isEmpty ||
        marcaController.text.trim().isEmpty ||
        descripcionController.text.trim().isEmpty ||
        precioController.text.trim().isEmpty ||
        especiesSeleccionadas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todos los campos son obligatorios')),
      );
      return;
    }

    // Prepara el body para el POST
    final url = Uri.parse('${AppConfig.baseUrl}/productos');
    final body = {
      "nombre": nombreController.text.trim(),
      "marca": marcaController.text.trim(),
      "categoria": categoriaSeleccionada,
      "especies": especiesSeleccionadas,
      "descripcion": descripcionController.text.trim(),
      "precio": double.tryParse(precioController.text.replaceAll(',', '.').trim()) ?? 0.0,
      // "imagen": null, // El campo imagen se actualiza tras subir la imagen
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json",
      'Authorization': basicAuthHeader('root', '1234'),
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final producto = jsonDecode(response.body);
      final productoId = producto['id'] as int;

      // Si se seleccionó una imagen, súbela
      if (_imagenProducto != null) {
        await _subirImagenProducto(productoId, _imagenProducto!);
      }

      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text("Producto creado con éxito"),
            ],
          ),
          backgroundColor: Colors.green[700],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al crear producto: ${response.body}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagenProducto = File(pickedFile.path);
      });
    }
  }

  Future<void> _subirImagenProducto(int productoId, File imagen) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/productos/$productoId/imagen');
      final request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('imagen', imagen.path));
      // cabecera de autenticación
      request.headers['Authorization'] = basicAuthHeader('root', '1234');
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      if (response.statusCode != 200) {
        print('Error al subir imagen: Código ${response.statusCode}, body: $responseBody');
      }
    } catch (e) {
      print('Error al subir imagen: $e');
    }
  }
}
