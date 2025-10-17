import 'dart:convert';
import 'package:clinica_app/pages/usuario/UsuarioScreen.dart';
import 'package:clinica_app/pages/utils/appConfig.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:clinica_app/pages/utils/auth_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Muestra la información completa del producto, incluyendo imagen, nombre, marca, categoría,
// especies a las que va dirigido, descripción y un selector de unidades para añadir a la cesta.
class AdminDetalleProductoScreen extends StatefulWidget {
  final String nombre;
  final String precio;
  final String imagen;
  final String descripcion;
  final String marca;      
  final String categoria;
  final List<String> especies;
  final int productoId;

  const AdminDetalleProductoScreen({
    super.key,
    required this.productoId,
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.imagen,
    required this.descripcion,
    required this.marca,
    required this.especies,
  });

  @override
  State<AdminDetalleProductoScreen> createState() => _AdminDetalleProductoScreenState();
}

class _AdminDetalleProductoScreenState extends State<AdminDetalleProductoScreen> {
  int unidades = 1; // Contador de unidades para añadir a la cesta

  // Función que obtiene el dni o email del usuario logueado desde SharedPreferences
  Future<String?> obtenerDniUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('dni_usuario'); // Cambia la clave si usas otro nombre
  }

    Future<void> addToCart() async {
    final String? dniUsuario = await obtenerDniUsuario();
    if (dniUsuario == null) {
      // Muestra un mensaje de error si no hay usuario logueado
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, inicia sesión para añadir productos a la cesta')),
      );
      return;
    }

    // TODO: Cambia la URL por la de tu backend
    final url = Uri.parse('${AppConfig.baseUrl}/carrito/$dniUsuario/linea');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'productoId': widget.productoId,
        'cantidad': unidades,
        'seleccionado': true,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto añadido a la cesta')),
      );
      Navigator.pop(context); // Opcional: volver atrás tras añadir
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al añadir el producto a la cesta')),
      );
    }
  }

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
        title: Text(
          widget.nombre,
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
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Sección de la imagen del producto
          Center(
            child: Image.network(
              widget.imagen,
              height: 180,
              fit: BoxFit.contain,
              // Si la imagen no se puede cargar, muestra un icono de error
              errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.image_not_supported, size: 90, color: Colors.grey),
            ),
          ),

          const SizedBox(height: 18),
          // Fila con nombre a la izquierda y precio del prodcuto a la derecha
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.nombre,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                //Se mostrará el precio total que se añade al carrito, ya que se ira sumando el numero de unidades seleccionado, se actualiza dinamicamente
                '${(unidades * double.parse(widget.precio)).toStringAsFixed(2)}€',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.lightBlueAccent,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
          // Marca del producto
          Text(
            widget.marca,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          // Sección de chips: categoría y especies del producto
          // Wrap permite que los chips se distribuyan en varias líneas si no caben en una
          Wrap(
            spacing: 6,      // Espacio horizontal entre chips
            runSpacing: 2,   // Espacio vertical entre líneas de chips
            children: [
              // Chip de categoría
              _buildChip(widget.categoria, Icons.category, Colors.amber[200]!),
              // Chips de especies (una por cada especie)
              ...widget.especies.map((especie) => _buildChip(especie, Icons.pets, Colors.amber[100]!)),
            ],
          ),

          const SizedBox(height: 18),
          // Descripción del producto
          Text(
            widget.descripcion,
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 24),
          // Fila de selección de unidades y botón de añadir a la cesta
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Texto "Unidades:"
              const Text("Unidades:", style: TextStyle(fontSize: 16)),
              const SizedBox(width: 12),
              // Botón para reducir unidades
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                // Solo permite reducir si hay más de una unidad
                onPressed: unidades > 1 ? () => setState(() => unidades--) : null,
              ),
              // Número de unidades seleccionadas
              Text(
                unidades.toString(),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              // Botón para aumentar unidades
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => setState(() => unidades++),
              ),
              const SizedBox(width: 8),
              // Botón de añadir a la cesta, ocupa el espacio restante
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.shopping_basket_outlined),
                  label: Text("Añadir a la cesta", overflow: TextOverflow.ellipsis),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    //lógica para añadir a la cesta
                    addToCart();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Botones de administración (exclusivos admin)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('Editar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(120, 44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  //SHow  dialog para editar producto
                  _mostrarDialogoEditarProducto();
                },
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.delete),
                label: const Text('Eliminar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(120, 44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Eliminar producto'),
                      content: const Text('¿Seguro que quieres eliminar este producto? Esta acción no se puede deshacer.'),
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
                    await eliminarProducto(widget.productoId);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Método auxiliar para crear un chip con icono y texto
  Widget _buildChip(String label, IconData icon, Color color) {
    return Chip(
      avatar: Icon(icon, size: 16, color: Colors.black54), // Icono del chip
      label: Text(
        label,
        style: const TextStyle(fontSize: 13, color: Colors.black87),
      ),
      backgroundColor: color,         // Color de fondo del chip
      shape: RoundedRectangleBorder(  // Forma redondeada del chip
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0), // Padding interno
    );
  }

  void _mostrarDialogoEditarProducto() {
    final TextEditingController precioController = TextEditingController(text: widget.precio);
    final TextEditingController descripcionController = TextEditingController(text: widget.descripcion);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar producto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: precioController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Precio'),
              ),
              TextField(
                controller: descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final nuevoPrecio = precioController.text.trim();
                final nuevaDescripcion = descripcionController.text.trim();
                final exito = await _editarProducto(nuevoPrecio, nuevaDescripcion);
                if (exito) {
                  Navigator.pop(context); // Cierra el diálogo
                  setState(() {
                    // Actualiza la pantalla con los nuevos valores
                    // Si usas variables locales en vez de widget.precio/widget.descripcion, cámbialas aquí
                  });
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _editarProducto(String nuevoPrecio, String nuevaDescripcion) async {
    final url = Uri.parse('${AppConfig.baseUrl}/productos/${widget.productoId}');
    //regex que elimina cualquier texto como "€" y convierte string en numero para que te lo acepte el backend como bigDecimal
    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json',
        'Authorization': basicAuthHeader('root', '1234'),
        },
        body: jsonEncode({
          'precio': double.parse(nuevoPrecio),
          'descripcion': nuevaDescripcion,
        }),
      );

      print('PATCH status: ${response.statusCode}');
      print('PATCH body: ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto actualizado correctamente')),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el producto: ${response.body}')),
        );
        return false;
      }
    } catch (e) {
      print('PATCH exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Excepción al actualizar el producto: $e')),
      );
      return false;
    }
  }

  Future<void> eliminarProducto(int productoId) async {
    final url = Uri.parse('${AppConfig.baseUrl}/productos/$productoId');
    try {
      final response = await http.delete(
        url,
        headers: {'Authorization': basicAuthHeader('root', '1234')});

      print('DELETE status: ${response.statusCode}');
      print('DELETE body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto eliminado correctamente')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar el producto: ${response.body}')),
        );
      }
    } catch (e) {
      print('DELETE exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Excepción al eliminar el producto: $e')),
      );
    }
  }
}