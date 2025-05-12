import 'package:clinica_app/pages/TarjetaProductosTienda.dart';
import 'package:flutter/material.dart';

class Tienda extends StatefulWidget {
  const Tienda({super.key});

  @override
  _TiendaState createState() => _TiendaState();
}

class _TiendaState extends State<Tienda> {
  String? especieSeleccionada = "Perro"; // Valor inicial
  String? categoriaSeleccionada;
  // Datos de ejemplo para los filtros principales
  final List<Map<String, String>> filtros = [
    {
      "titulo": "Perros",
      "img": "https://cdn.sanity.io/images/5vm5yn1d/pro/5cb1f9400891d9da5a4926d7814bd1b89127ecba-1300x867.jpg?fm=webp&q=80"
    },
    {
      "titulo": "Gatos",
      "img": "https://images.ctfassets.net/denf86kkcx7r/4IPlg4Qazd4sFRuCUHIJ1T/f6c71da7eec727babcd554d843a528b8/gatocomuneuropeo-97"
    },
    {
      "titulo": "Royal Canin",
      "img": "https://www.piensosraposo.es/2551-large_default/royal-canin-kitten-10-kg.jpg"
    },
    {
      "titulo": "Bayer",
      "img": "https://www.sehop.org/wp-content/uploads/2020/11/Bayer-Logo.png"
    },
  ];

  // Datos de ejemplo para las categorías
  final List<Map<String, String>> categorias = [
    {
      "titulo": "Alimentación",
      "img": "https://www.dingonatura.com/wp-content/uploads/2019/10/AdobeStock_197601740._._._-1024x683.jpg"
    },
    {
      "titulo": "Antiinflamatorio",
      "img": "https://www.dingonatura.com/wp-content/uploads/2019/10/AdobeStock_197601740._._._-1024x683.jpg"
    },
    {
      "titulo": "Arenas",
      "img": "https://www.dingonatura.com/wp-content/uploads/2019/10/AdobeStock_197601740._._._-1024x683.jpg"
    },
    {
      "titulo": "Antiparasitario",
      "img": "https://www.dingonatura.com/wp-content/uploads/2019/10/AdobeStock_197601740._._._-1024x683.jpg"
    },
    {
      "titulo": "Complemento nutricional",
      "img": "https://www.dingonatura.com/wp-content/uploads/2019/10/AdobeStock_197601740._._._-1024x683.jpg"
    },
    {
      "titulo": "Dermatología",
      "img": "https://www.dingonatura.com/wp-content/uploads/2019/10/AdobeStock_197601740._._._-1024x683.jpg"
    },
    {
      "titulo": "Higiene",
      "img": "https://www.dingonatura.com/wp-content/uploads/2019/10/AdobeStock_197601740._._._-1024x683.jpg"
    },
  ];

  // Lista de productos destacados (puedes ponerla en tu _TiendaState)
final List<Map<String, dynamic>> productosDestacados = [
  {
    "nombre": "PRONEFRA",
    "subtitulo": "Complemento nutricional",
    "precio": "Desde 27 €",
    "imagen": "https://www.piensosraposo.es/2551-large_default/royal-canin-kitten-10-kg.jpg",
    "descripcion": "Recomendado para perros y gatos ayuda de la función renal en caso de insuficiencia renal crónica.",
    "especies" : ["Gato"],
    "marca" : "Royal Canin",
  },
  {
    "nombre": "Stomaferin ultra",
    "subtitulo": "Higiene",
    "precio": "27.99 €",
    "imagen": "https://www.piensosraposo.es/2551-large_default/royal-canin-kitten-10-kg.jpg",
    "descripcion": "Solución para la higiene bucal de perros y gatos.",
    "especies" : ["Gato"],
    "marca" : "Royal Canin",

  },
  {
    "nombre": "PRONEFRA",
    "subtitulo": "Complemento nutricional",
    "precio": "Desde 27 €",
    "imagen": "https://www.piensosraposo.es/2551-large_default/royal-canin-kitten-10-kg.jpg",
    "descripcion": "Recomendado para perros y gatos ayuda de la función renal en caso de insuficiencia renal crónica. ",
    "especies" : ["Perro"],
    "marca" : "Eukanuba",

  },
  {
    "nombre": "Stomaferin ultra",
    "subtitulo": "Higiene",
    "precio": "27.99 €",
    "imagen": "https://www.piensosraposo.es/2551-large_default/royal-canin-kitten-10-kg.jpg",
    "descripcion": "Solución para la higiene bucal de perros y gatos.",
    "especies" : ["Gato"],
    "marca" : "Eukanuba",

  },
  {
    "nombre": "Stomaferin ultra",
    "subtitulo": "Higiene",
    "precio": "27.99 €",
    "imagen": "https://www.piensosraposo.es/2551-large_default/royal-canin-kitten-10-kg.jpg",
    "descripcion": "Solución para la higiene bucal de perros y gatos.",
    "especies" : ["Perro"],
    "marca" : "Eukanuba",

  },
  // ...añade más productos si quieres
];

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
        title: const Text(
          "Tienda",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 18),
        children: [
          // Carrusel de filtros principales
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: filtros.map((filtro) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          // Acción de filtro
                        },
                        child: Container(
                          width: 140,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                                child: Image.network(
                                  filtro["img"]!,
                                  height: 70,
                                  width: 140,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  "Productos para\n${filtro["titulo"]}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.lightBlueAccent,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ),
          // Más separación entre carruseles
          const SizedBox(height: 24),
          // Carrusel de categorías
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categorias.map((cat) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                    child: GestureDetector(
                      onTap: () {
                      // Acción de filtro por categoría
                      },
                      child: Container(
                        width: 240,
                        height: 110,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Imagen de fondo
                            ClipRRect(
                              borderRadius: BorderRadius.circular(22),
                              child: Image.network(
                                cat["img"]!,
                                width: 240,
                                height: 110,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Título arriba a la izquierda, sobre la imagen
                            Positioned(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  cat["titulo"]!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Título más pequeño y minimalista
                const Text(
                  "Buscador de productos",
                  style: TextStyle(
                    color: Colors.lightBlueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // Dropdown de especie
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Seleccionar especie",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    isDense: true, // Hace el campo más compacto
                  ),
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                  value: especieSeleccionada,
                  items: ["Perro", "Gato"]
                      .map((especie) => DropdownMenuItem(
                            value: especie,
                            child: Text(especie),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      especieSeleccionada = value!;
                    });
                  },
                ),
                const SizedBox(height: 8),
                // Dropdown de categoría
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Seleccionar categoría",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    isDense: true,
                  ),
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                  value: categoriaSeleccionada,
                  items: categorias
                      .map((cat) => DropdownMenuItem(
                            value: cat["titulo"],
                            child: Text(cat["titulo"]!),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      categoriaSeleccionada = value!;
                    });
                  },
                ),
                const SizedBox(height: 14),
                // Botón buscar pequeño y minimalista
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Acción de buscar
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      elevation: 0,
                    ),
                    child: const Text("Buscar", style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),

          // Tarjetas productos
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Productos destacados",
              style: TextStyle(
                color: Colors.lightBlueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: productosDestacados.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 18,
                childAspectRatio: 0.78, // Ajusta este valor según el alto de tus tarjetas
              ),
              itemBuilder: (context, index) {
                final producto = productosDestacados[index];
                return ProductoDestacadoCard(
                  nombre: producto["nombre"],
                  subtitulo: producto["subtitulo"],
                  precio: producto["precio"],
                  imagen: producto["imagen"],
                  descripcion: producto["descripcion"],
                  especies: producto["especies"],
                  marca: producto["marca"],
                );
              },
            ),
          ),


          // Puedes seguir con el resto del contenido aquí...
        ],
      ),
    );
  }
}
