import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditarPerfilScreen extends StatefulWidget {
  const EditarPerfilScreen({Key? key}) : super(key: key);

  @override
  State<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  final dniController = TextEditingController();
  final nombreController = TextEditingController();
  final apellidosController = TextEditingController();
  final emailController = TextEditingController();
  final telefonoController = TextEditingController();
  final contrasenaController = TextEditingController();

  bool _obscureText = true;
  bool isLoading = true;
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    cargarUsuarioActual();
  }

  Future<void> cargarUsuarioActual() async {
    final prefs = await SharedPreferences.getInstance();
    final dni = prefs.getString('dni_usuario');
    if (dni == null) {
      setState(() {
        errorMsg = 'No hay usuario logueado';
        isLoading = false;
      });
      return;
    }
    final url = Uri.parse('http://192.168.1.131:8080/usuarios/$dni');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        dniController.text = data['dni'] ?? '';
        nombreController.text = data['nombre'] ?? '';
        apellidosController.text = data['apellidos'] ?? '';
        emailController.text = data['email'] ?? '';
        telefonoController.text = data['telefono'] ?? '';
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          errorMsg = 'Error al cargar usuario (${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMsg = 'Error de conexión: $e';
        isLoading = false;
      });
    }
  }

  Future<void> actualizarUsuario() async {
    final dni = dniController.text;
    final url = Uri.parse('http://192.168.1.131:8080/usuarios/$dni');
    final body = {
      "dni": dni,
      "nombre": nombreController.text,
      "apellidos": apellidosController.text,
      "email": emailController.text,
      "telefono": telefonoController.text,
      "contrasena": contrasenaController.text.isNotEmpty
          ? contrasenaController.text
          : null, // Solo si quiere cambiarla
    }..removeWhere((k, v) => v == null); // Elimina campos nulos

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos actualizados correctamente')),
      );
      Navigator.pop(context, true); // Vuelve atrás e indica éxito
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar: ${response.body}')),
      );
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
        title: Text(
          "Editar Perfil",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMsg != null
              ? Center(child: Text(errorMsg!))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // DNI (no editable)
                      TextFormField(
                        controller: dniController,
                        enabled: false,
                        decoration: const InputDecoration(
                          labelText: "DNI",
                          prefixIcon: Icon(Icons.badge),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Nombre (no editable)
                      TextFormField(
                        controller: nombreController,
                        enabled: false,
                        decoration: const InputDecoration(
                          labelText: "Nombre",
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Apellidos (no editable)
                      TextFormField(
                        controller: apellidosController,
                        enabled: false,
                        decoration: const InputDecoration(
                          labelText: "Apellidos",
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Email (editable)
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 15),
                      // Teléfono (editable)
                      TextFormField(
                        controller: telefonoController,
                        decoration: const InputDecoration(
                          labelText: "Teléfono",
                          prefixIcon: Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 15),
                      // Contraseña (editable)
                      TextFormField(
                        controller: contrasenaController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: "Nueva contraseña",
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: _obscureText
                                  ? Colors.grey
                                  : Colors.lightBlueAccent,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Texto aclaratorio
                      const Text(
                        "Si no escribes ninguna contraseña nueva, se mantendrá la actual.",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: actualizarUsuario,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "GUARDAR CAMBIOS",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
