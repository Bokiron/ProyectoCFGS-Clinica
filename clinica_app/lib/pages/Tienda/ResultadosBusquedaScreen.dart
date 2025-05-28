import 'package:clinica_app/pages/usuario/UsuarioScreen.dart';
import 'package:flutter/material.dart';
import 'TarjetaProductosTienda.dart';

class ResultadosBusquedaScreen extends StatelessWidget {
  final List<Map<String, dynamic>> productos;
  final List<Widget> chipsCriterios;

  const ResultadosBusquedaScreen({
    super.key,
    required this.productos,
    required this.chipsCriterios,
  });

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
        title: const Text(
          "Resultados de búsqueda",
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
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wrap con los chips, con espaciado y estilo similar a DetalleProducto
            Wrap(
              spacing: 6,      // Igual que en DetalleProducto
              runSpacing: 2,   // Igual que en DetalleProducto
              children: chipsCriterios.map((chip) {
                // Modificamos el estilo de cada chip existente
                if (chip is Chip) {
                  return Chip(
                    label: chip.label,
                    backgroundColor: Colors.amber[200], // Color similar a DetalleProducto
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                  );
                }
                return chip; // Si no es un Chip, lo dejamos como está
              }).toList(),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: productos.isEmpty
                  ? const Center(child: Text("No hay productos para este filtro."))
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: productos.length,
                      itemBuilder: (context, index) {
                        final producto = productos[index];
                        String imagenUrl = producto['imagen'] ?? '';
                        if (imagenUrl.isNotEmpty && !imagenUrl.startsWith('http')) {
                          imagenUrl = 'http://192.168.1.131:8080/$imagenUrl';
                        }
                        return ProductoDestacadoCard(
                          productoId: producto['id'] ?? '',
                          nombre: producto['nombre'] ?? '',
                          categoria: producto['categoria'] ?? '',
                          precio: "${producto['precio'] ?? ''}",
                          imagen: imagenUrl,
                          descripcion: producto['descripcion'] ?? '',
                          especies: (producto['especies'] as List<dynamic>?)
                              ?.map((e) => e.toString())
                              .toList() ?? [],
                          marca: producto['marca'] ?? '',
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

