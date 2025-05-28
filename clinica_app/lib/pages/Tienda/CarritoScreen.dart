import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Pantalla del carrito
class CarritoScreen extends StatefulWidget {
  const CarritoScreen({Key? key}) : super(key: key);

  @override
  _CarritoScreenState createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  // Lista de líneas del carrito (productos añadidos)
  List<dynamic> lineas = [];
  // Indicador de carga mientras se obtienen los datos del backend
  bool loading = true;

  // Obtiene el DNI del usuario logueado desde SharedPreferences
  Future<String?> obtenerDniUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('dni_usuario');
  }

  // Carga los productos del carrito del usuario desde el backend
  Future<void> cargarCarrito() async {
    setState(() => loading = true); // Activa el indicador de carga
    final dni = await obtenerDniUsuario();
    if (dni == null) return; // Si no hay usuario, no se hace nada
    final url = Uri.parse('http://192.168.1.131:8080/carrito/$dni');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      setState(() {
        // Actualiza la lista de líneas con los datos recibidos
        lineas = data['lineas'];
        loading = false; // Desactiva el indicador de carga
      });
    } else {
      setState(() => loading = false);
    }
  }

  // Modifica la cantidad de unidades de un producto en el carrito (+/-)
  Future<void> modificarUnidades(int lineaId, int nuevaCantidad) async {
    final dni = await obtenerDniUsuario();
    // Busca la línea correspondiente al producto
    final linea = lineas.firstWhere((l) => l['id'] == lineaId);
    final url = Uri.parse('http://192.168.1.131:8080/carrito/$dni/linea/$lineaId');
    // Actualiza la cantidad en el backend
    await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'productoId': linea['productoId'],
        'cantidad': nuevaCantidad,
        'seleccionado': linea['seleccionado'],
      }),
    );
    // Recarga el carrito para mostrar los cambios
    await cargarCarrito();
  }

  // Cambia el estado de selección de un producto (checkbox)
  Future<void> cambiarSeleccion(int lineaId, bool seleccionado) async {
    final dni = await obtenerDniUsuario();
    final linea = lineas.firstWhere((l) => l['id'] == lineaId);
    final url = Uri.parse('http://192.168.1.131:8080/carrito/$dni/linea/$lineaId');
    // Actualiza la selección en el backend
    await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'productoId': linea['productoId'],
        'cantidad': linea['cantidad'],
        'seleccionado': seleccionado,
      }),
    );
    // Recarga el carrito para reflejar los cambios
    await cargarCarrito();
  }

  // Elimina todas las líneas seleccionadas usando el endpoint batch del backend
  Future<void> eliminarSeleccionados() async {
    final dni = await obtenerDniUsuario();
    if (dni == null) return;

    // Obtiene los IDs de las líneas seleccionadas
    final idsSeleccionados = lineas
        .where((l) => l['seleccionado'] == true)
        .map((l) => l['id'])
        .toList();

    if (idsSeleccionados.isEmpty) return;

    final url = Uri.parse('http://192.168.1.131:8080/carrito/$dni/lineas/eliminar');
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(idsSeleccionados),
    );

    if (res.statusCode == 204) {
      // Recarga el carrito tras eliminar
      await cargarCarrito();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Productos eliminados de la cesta')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al eliminar productos')),
      );
    }
  }

  // Calcula el total de los productos seleccionados
  double calcularTotal() {
    return lineas
        .where((l) => l['seleccionado'] == true)
        .fold(0.0, (total, l) => total + (l['precioProducto'] * l['cantidad']));
  }

  @override
  void initState() {
    super.initState();
    // Al iniciar la pantalla, carga el carrito
    cargarCarrito();
  }

  @override
  Widget build(BuildContext context) {
    //comprobamos si hay productos seleccionados
    final haySeleccionados = lineas.any((l) => l['seleccionado'] == true);
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
          "Cesta",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Icono de eliminar, visible solo si hay productos seleccionados
        actions: [
          if (haySeleccionados)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.blueAccent),
              tooltip: 'Eliminar seleccionados',
              onPressed: () async {
                // Confirmación antes de eliminar
                final confirmado = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Eliminar productos'),
                    content: const Text('¿Seguro que quieres eliminar los productos seleccionados?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Eliminar'),
                      ),
                    ],
                  ),
                );
                if (confirmado == true) {
                  await eliminarSeleccionados();
                }
              },
            ),
          ],
      ),
      // Contenido principal de la pantalla
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : lineas.isEmpty
              ? const Center(child: Text("Tu cesta está vacía"))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: lineas.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final linea = lineas[index];
                    // Prepara la URL de la imagen, añadiendo la base si es necesario
                    String imagenUrl = linea['imagenProducto'] ?? '';
                    if (imagenUrl.isNotEmpty && !imagenUrl.startsWith('http')) {
                      imagenUrl = 'http://192.168.1.131:8080/$imagenUrl';
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Imagen del producto
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imagenUrl,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(
                              width: 64,
                              height: 64,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image, size: 32),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Información del producto
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(linea['nombreProducto'] ?? '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16)),
                              Text(
                                "${linea['marcaProducto'] ?? ''} | ${linea['precioProducto']} €",
                                style: const TextStyle(color: Colors.black54, fontSize: 13),
                              ),
                              const SizedBox(height: 4),
                              // Botones para modificar la cantidad de unidades
                              Row(
                                children: [
                                  // Botón para reducir unidades
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline),
                                    onPressed: linea['cantidad'] > 1
                                        ? () => modificarUnidades(
                                            linea['id'], linea['cantidad'] - 1)
                                        : null,
                                    iconSize: 22,
                                    color: Colors.lightBlueAccent,
                                    padding: EdgeInsets.zero,
                                  ),
                                  // Número de unidades
                                  Text(
                                    linea['cantidad'].toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                  // Botón para aumentar unidades
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () => modificarUnidades(
                                        linea['id'], linea['cantidad'] + 1),
                                    iconSize: 22,
                                    color: Colors.lightBlueAccent,
                                    padding: EdgeInsets.zero,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Checkbox para seleccionar el producto
                        Checkbox(
                          value: linea['seleccionado'] ?? false,
                          onChanged: (val) =>
                              cambiarSeleccion(linea['id'], val ?? false),
                          activeColor: Colors.lightBlueAccent,
                        ),
                      ],
                    );
                  },
                ),
      // Barra inferior con el total y el botón de comprar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[200]!)),
        ),
        child: Row(
          children: [
            // Precio total de los productos seleccionados
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.lightBlueAccent, width: 1),
                ),
                child: Text(
                  "${calcularTotal().toStringAsFixed(2)} €",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Botón para realizar la compra (solo habilitado si hay productos seleccionados)
            ElevatedButton(
              onPressed: calcularTotal() > 0
                  ? () {
                      // TODO: Implementar lógica de compra
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("COMPRAR", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

