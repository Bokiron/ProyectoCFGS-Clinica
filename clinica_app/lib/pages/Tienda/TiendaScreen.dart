import 'dart:convert';
import 'package:clinica_app/pages/Tienda/AdminCrearProducto.dart';
import 'package:clinica_app/pages/Tienda/CarritoScreen.dart';
import 'package:clinica_app/pages/Tienda/ResultadosBusquedaScreen.dart';
import 'package:clinica_app/pages/Tienda/TarjetaProductosTienda.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Tienda extends StatefulWidget {
  const Tienda({super.key});

  @override
  _TiendaState createState() => _TiendaState();
}

class _TiendaState extends State<Tienda> {
  String? especieSeleccionada; // Valor inicial
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
      "img": "https://1000logos.net/wp-content/uploads/2020/07/Royal-Canin-Logo.png"
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
    {
      "titulo": "Juguetes",
      "img": "https://www.dingonatura.com/wp-content/uploads/2019/10/AdobeStock_197601740._._._-1024x683.jpg"
    },
    
  ];
  //mapeo para enviar las categorias correctamente al backend
  Map<String, String> categoriaToEnum = {
    "Alimentación": "ALIMENTACION",
    "Antiinflamatorio": "ANTIINFLAMATORIO",
    "Arenas": "ARENAS",
    "Antiparasitario": "ANTIPARASITARIO",
    "Complemento nutricional": "COMPLEMENTO_NUTRICIONAL",
    "Dermatología": "DERMATOLOGIA",
    "Higiene": "HIGIENE",
    "Juguetes": "JUGUETES",
  };
  //mapeo para enviar las especies correctamente al backend
  Map<String, String> especieToEnum = {
    "Perros": "PERRO",
    "Gatos": "GATO",
    "Conejos" : "CONEJO",
    "Loros" : "LOROS"
    // Si añades más especies populares, agrégalas aquí.
  };

  // Lista de productos destacados (puedes ponerla en tu _TiendaState)
  List<Map<String, dynamic>> productosApi = [];
  bool loadingProductos = true;
  String? rolUsuario;

  @override
  void initState() {
    super.initState();
    cargarRolUsuario();
    cargarProductosDesdeApi();
  }

  Future<void> cargarRolUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      rolUsuario = prefs.getString('rol_usuario');
    });
    print("Rol usuario en build: $rolUsuario");
  }

  Future<void> cargarProductosDesdeApi() async {
    setState(() { loadingProductos = true; });
    try {
      final response = await http.get(Uri.parse('http://192.168.1.131:8080/productos'));
      print("Respuesta status: ${response.statusCode}");
      print("Respuesta body: ${response.body}");
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print("Productos decodificados: $data");
        setState(() {
          productosApi = data.map<Map<String, dynamic>>((item) => item as Map<String, dynamic>).toList();
          loadingProductos = false;
        });
        print("productosApi.length: ${productosApi.length}");
      } else {
        setState(() { loadingProductos = false; });
        print("Error: status code diferente de 200");
      }
    } catch (e) {
      setState(() { loadingProductos = false; });
      print("Excepción al cargar productos: $e");
    }
  }
  //filtro para obtener los productos por 1 criterio de búsqueda
// Método para obtener productos filtrados por un criterio (especie, categoría o marca)
Future<List<Map<String, dynamic>>> filtrarYObtenerProductos(String filtro, String valor) async {
  setState(() { loadingProductos = true; }); // Activa el indicador de carga
  try {
    // Realiza la petición HTTP al backend con el filtro y el valor correspondiente
    final response = await http.get(
      Uri.parse('http://192.168.1.131:8080/productos?$filtro=$valor'),
    );
    if (response.statusCode == 200) {
      // Si la respuesta es exitosa, decodifica el JSON y convierte cada producto a Map
      final List<dynamic> data = json.decode(response.body);
      return data.map<Map<String, dynamic>>((item) => item as Map<String, dynamic>).toList();
    }
  } catch (e) {
    // Manejo de errores (por ejemplo, si falla la conexión)
  }
  return []; // Retorna lista vacía si hay error o no hay resultados
}

//metodo para el buscador avanzado, es decir por especie y ctaegoria
Future<void> buscarProductosAvanzado(BuildContext context) async {
  // Construir los parámetros de la URL según lo seleccionado
  List<String> params = [];
  if (especieSeleccionada != null && especieToEnum[especieSeleccionada!] != null) {
    params.add('especies=${especieToEnum[especieSeleccionada!]}');
  }
  if (categoriaSeleccionada != null && categoriaToEnum[categoriaSeleccionada!] != null) {
    params.add('categoria=${categoriaToEnum[categoriaSeleccionada!]}');
  }
  // Si no hay ningún criterio, puedes mostrar un mensaje y salir
  if (params.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selecciona al menos un criterio de búsqueda.')),
    );
    return;
  }
  final url = 'http://192.168.1.131:8080/productos?${params.join('&')}';

  // Llamada HTTP
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    final productos = data.map<Map<String, dynamic>>((item) => item as Map<String, dynamic>).toList();

    // Construir chips de criterios seleccionados
    List<Widget> chips = [];
    if (especieSeleccionada != null) {
      chips.add(Chip(label: Text(especieSeleccionada!)));
    }
    if (categoriaSeleccionada != null) {
      chips.add(Chip(label: Text(categoriaSeleccionada!)));
    }

    // Navega a la pantalla de resultados
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultadosBusquedaScreen(
          productos: productos,
          chipsCriterios: chips,
        ),
      ),
    );
  }
}



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
                        onTap: () async {
                        // Acción de filtro cuando se pulsa un filtro de la primera fila(gatos, perros y marcas)

                        // 1. Verifica si el filtro es una especie (usando el mapa especieToEnum)
                        final String? especieEnum = especieToEnum[filtro["titulo"]!];
                        // 2. Lista de marcas disponibles para filtros rápidos
                        final List<String> marcas = ["Royal Canin", "Bayer"]; // Actualiza con las marcas de tu app
                        final bool esMarca = marcas.contains(filtro["titulo"]!);

                        // Lógica de filtrado y navegación
                        if (especieEnum != null) {
                          // Si es una especie, filtra los productos y navega a la pantalla de resultados
                          final productos = await filtrarYObtenerProductos('especies', especieEnum);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ResultadosBusquedaScreen(
                                productos: productos,
                                chipsCriterios: [
                                  Chip(label: Text(filtro["titulo"]!)), // Muestra el criterio seleccionado como chip
                                ],
                              ),
                            ),
                          );
                          // Al volver, recarga productos destacados
                          cargarProductosDesdeApi();
                        } else if (esMarca) {
                          // Si es una marca, filtra los productos y navega a la pantalla de resultados
                          final productos = await filtrarYObtenerProductos('marca', filtro["titulo"]!);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ResultadosBusquedaScreen(
                                productos: productos,
                                chipsCriterios: [
                                  Chip(label: Text(filtro["titulo"]!)), // Muestra el criterio seleccionado como chip
                                ],
                              ),
                            ),
                          );
                          // Al volver, recarga productos destacados
                          cargarProductosDesdeApi();
                        }
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
                      onTap: () async {
                        // Acción de filtro cuando se pulsa una categoría

                        // 1. Verifica si la categoría existe en el mapa categoriaToEnum
                        final String? categoriaEnum = categoriaToEnum[cat["titulo"]!];
                        if (categoriaEnum != null) {
                          // Si existe, filtra los productos y navega a la pantalla de resultados
                          final productos = await filtrarYObtenerProductos('categoria', categoriaEnum);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ResultadosBusquedaScreen(
                                productos: productos,
                                chipsCriterios: [
                                  Chip(label: Text(cat["titulo"]!)), // Muestra el criterio seleccionado como chip
                                ],
                              ),
                            ),
                          );
                          // Al volver, recarga productos destacados
                          cargarProductosDesdeApi();
                        }
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
                // Título del buscador avanzado
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

                // Dropdown para seleccionar especie
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Seleccionar especie", // Texto que aparece como hint cuando no hay selección
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    isDense: true, // Hace el campo más compacto
                  ),
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                  value: especieSeleccionada, // Valor actualmente seleccionado (o null)
                  items: [
                    // Opciones de especie
                    ...["Perros", "Gatos", "Conejos", "Loros"]
                        .map((especie) => DropdownMenuItem(
                              value: especie,
                              child: Text(especie),
                            ))
                        .toList(),
                    // Opción de cancelar selección (aparece al final)
                    const DropdownMenuItem<String>(
                      value: 'CANCELAR',
                      child: Text(
                        "Cancelar selección",
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ],
                  // Cuando cambia la selección:
                  // - Si elige "Cancelar selección", se limpia la variable (null)
                  // - Si elige una especie, se guarda el valor
                  onChanged: (value) {
                    setState(() {
                      if (value == 'CANCELAR') {
                        especieSeleccionada = null;
                      } else {
                        especieSeleccionada = value;
                      }
                    });
                  },
                  hint: const Text("Seleccionar especie"), // Hint cuando no hay selección
                ),

                const SizedBox(height: 8),

                // Dropdown para seleccionar categoría
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
                  value: categoriaSeleccionada, // Valor actualmente seleccionado (o null)
                  items: [
                    // Opciones de categoría (salen del listado 'categorias')
                    ...categorias
                        .map((cat) => DropdownMenuItem(
                              value: cat["titulo"],
                              child: Text(cat["titulo"]!),
                            ))
                        .toList(),
                    // Opción de cancelar selección (aparece al final)
                    const DropdownMenuItem<String>(
                      value: 'CANCELAR',
                      child: Text(
                        "Cancelar selección",
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ],
                  // Cuando cambia la selección:
                  // - Si elige "Cancelar selección", se limpia la variable (null)
                  // - Si elige una categoría, se guarda el valor
                  onChanged: (value) {
                    setState(() {
                      if (value == 'CANCELAR') {
                        categoriaSeleccionada = null;
                      } else {
                        categoriaSeleccionada = value;
                      }
                    });
                  },
                  hint: const Text("Seleccionar categoría"), // Hint cuando no hay selección
                ),

                const SizedBox(height: 14),

                // Botón de buscar productos
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Al pulsar, ejecuta la búsqueda avanzada con los criterios seleccionados
                      buscarProductosAvanzado(context);
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
                    child: const Text("Buscar", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),

          // Tarjetas productos
          const SizedBox(height: 16),
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
          loadingProductos
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Dos columnas
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: productosApi.length,
                    itemBuilder: (context, index) {
                      final producto = productosApi[index];
                      print("Renderizando producto: $producto");
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
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (rolUsuario == 'ADMIN')
            Padding(
              padding: const EdgeInsets.only(bottom: 70.0), // distancia sobre la cesta
              child: FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 0, 70, 192),
                heroTag: 'addProductBtn',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminCrearProductoScreen()),
                  );
                  cargarProductosDesdeApi();//al volver cargar productos
                },
                child: const Icon(Icons.add, color: Colors.white, size: 30),
              ),
            ),
          FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 152, 239, 153),
            elevation: 6,
            heroTag: 'cartBtn',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CarritoScreen()),
              );
            },
            child: Image.asset(
              "lib/assets/icon_cesta.png",
              width: 32,
              height: 32,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
