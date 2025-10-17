import 'dart:convert';
import 'package:clinica_app/pages/data/GetUsuarioDto.dart';
import 'package:clinica_app/pages/utils/appConfig.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UsuarioInfoPage extends StatefulWidget {
  const UsuarioInfoPage({Key? key}) : super(key: key);

  @override
  State<UsuarioInfoPage> createState() => _UsuarioInfoPageState();
}

class _UsuarioInfoPageState extends State<UsuarioInfoPage> {
  GetUsuarioDto? usuario;
  bool isLoading = true;
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    cargarDniYUsuario();
  }

  Future<void> cargarDniYUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final dni = prefs.getString('dni_usuario');
    if (dni != null) {
      await obtenerInfoUsuario(dni);
    } else {
      setState(() {
        errorMsg = 'No hay usuario logueado';
        isLoading = false;
      });
    }
  }

  Future<void> obtenerInfoUsuario(String dni) async {
    final url = Uri.parse('${AppConfig.baseUrl}/usuarios/$dni');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          usuario = GetUsuarioDto.fromJson(jsonDecode(response.body));
          isLoading = false;
        });
      } else {
        setState(() {
          errorMsg = 'Error al obtener usuario (${response.statusCode})';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Información de Usuario')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMsg != null
              ? Center(child: Text(errorMsg!))
              : usuario == null
                  ? const Center(child: Text('No se encontró el usuario'))
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView(
                        children: [
                          ListTile(
                            title: const Text('DNI'),
                            subtitle: Text(usuario!.dni),
                          ),
                          ListTile(
                            title: const Text('Nombre'),
                            subtitle: Text(usuario!.nombre),
                          ),
                          ListTile(
                            title: const Text('Email'),
                            subtitle: Text(usuario!.email),
                          ),
                          ListTile(
                            title: const Text('Teléfono'),
                            subtitle: Text(usuario!.telefono),
                          ),
                          ListTile(
                            title: const Text('Rol'),
                            subtitle: Text(usuario!.rol),
                          ),
                        ],
                      ),
                    ),
    );
  }
}

