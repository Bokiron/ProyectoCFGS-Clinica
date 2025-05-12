import 'package:flutter/material.dart';

class DetalleProductoScreen extends StatefulWidget {
  final String nombre;
  final String precio;
  final String imagen;
  final String descripcion;
  final String marca;
  final String categoria;
  final List<String> especies;

  const DetalleProductoScreen({
    super.key,
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.imagen,
    required this.descripcion,
    required this.marca,
    required this.especies,
  });

  @override
  State<DetalleProductoScreen> createState() => _DetalleProductoScreenState();
}

class _DetalleProductoScreenState extends State<DetalleProductoScreen> {
  int unidades = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          widget.nombre,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Imagen del producto
          Center(
            child: Image.network(
              widget.imagen,
              height: 180,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 18),
          // Nombre y marca
          Text(
            widget.nombre,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          Text(
            widget.marca,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          // Categoría y especies
          Row(
            children: [
              _buildChip(widget.categoria, Icons.category, Colors.amber[200]!),
              const SizedBox(width: 8),
              ...widget.especies.map((especie) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: _buildChip(especie, Icons.pets, Colors.amber[100]!),
              )),
            ],
          ),
          const SizedBox(height: 18),
          // Descripción
          Text(
            widget.descripcion,
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 24),
          // Selección de unidades y botón
          Row(
            children: [
              const Text("Unidades:", style: TextStyle(fontSize: 16)),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: unidades > 1 ? () => setState(() => unidades--) : null,
              ),
              Text(
                unidades.toString(),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => setState(() => unidades++),
              ),
              const Spacer(),
              ElevatedButton.icon(
                icon: const Icon(Icons.shopping_basket_outlined),
                label: Text("Añadir a la cesta"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  // Acción de añadir a la cesta
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.black54),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.black87)),
        ],
      ),
    );
  }
}
