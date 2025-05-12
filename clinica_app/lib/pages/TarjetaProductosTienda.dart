import 'package:clinica_app/pages/DetalleProductoScreen.dart';
import 'package:flutter/material.dart';

class ProductoDestacadoCard extends StatelessWidget {
  final String nombre;
  final String subtitulo;
  final String precio;
  final String imagen;
  final String descripcion;
  final List<String> especies;
  final String marca;

  const ProductoDestacadoCard({
    super.key,
    required this.nombre,
    required this.subtitulo,
    required this.precio,
    required this.imagen,
    required this.descripcion,
    required this.especies,
    required this.marca,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetalleProductoScreen(
              nombre: nombre,
              categoria: subtitulo,
              precio: precio,
              imagen: imagen,
              descripcion: descripcion,
              marca: marca,
              especies: especies,
            ),
          ),
        );
      },
    
    child: Container(
      width: double.infinity,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imagen,
                  width: 70,
                  height: 55,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              nombre,
              style: const TextStyle(
                color: Colors.lightBlueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subtitulo,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                precio,
                style: const TextStyle(
                  color: Colors.lightBlueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Text(
                descripcion,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 11,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}