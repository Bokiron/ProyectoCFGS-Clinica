import 'package:flutter/material.dart';

class RegistroMascota extends StatefulWidget {
  const RegistroMascota({Key? key}) : super(key: key);

  @override
  State<RegistroMascota> createState() => _RegistroMascotaState();
}

class _RegistroMascotaState extends State<RegistroMascota> {
  String tipoAnimal = "Perro";
  String genero = "Hembra";
  String tamano = "Grande";

  final List<String> tipos = ["Perro", "Gato"];
  final List<String> tamanos = ["Pequeño", "Mediano", "Grande"];

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
          "Registro de Mascota",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.blueAccent, size: 28),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        children: [
          const SizedBox(height: 16),
          // Selector de foto
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.greenAccent.shade100,
                  child: Icon(Icons.add, size: 48, color: Colors.white),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Seleccionar la foto de tu mascota",
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          // Campo Nombre
          const TextField(
            decoration: InputDecoration(
              labelText: "Nombre",
              border: UnderlineInputBorder(),
            ),
          ),
          const SizedBox(height: 18),
          // Tipo de animal (Dropdown)
          Row(
            children: [
              const Text("Tipo de animal", style: TextStyle(color: Colors.black54)),
              const Spacer(),
              DropdownButton<String>(
                value: tipoAnimal,
                underline: const SizedBox(),
                items: tipos
                    .map((tipo) => DropdownMenuItem(
                          value: tipo,
                          child: Text(
                            tipo,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    tipoAnimal = value!;
                  });
                },
              ),
            ],
          ),
          const Divider(),
          // Campo Raza
          const TextField(
            decoration: InputDecoration(
              labelText: "Raza",
              border: UnderlineInputBorder(),
            ),
          ),
          const SizedBox(height: 18),
          // Género
          const Text("Género", style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => genero = "Hembra"),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: genero == "Hembra"
                            ? Colors.greenAccent
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: const Text("Hembra",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => genero = "Macho"),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: genero == "Macho"
                            ? Colors.greenAccent
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: const Text("Macho",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          // Fecha Nacimiento
          const TextField(
            decoration: InputDecoration(
              labelText: "Fecha de Nacimiento",
              border: UnderlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 18),
          // Peso
          const TextField(
            decoration: InputDecoration(
              labelText: "Peso KG",
              border: UnderlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 18),
          // Tamaño (Dropdown)
          Row(
            children: [
              const Text("Tamaño", style: TextStyle(color: Colors.black54)),
              const Spacer(),
              DropdownButton<String>(
                value: tamano,
                underline: const SizedBox(),
                items: tamanos
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(
                            t,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    tamano = value!;
                  });
                },
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 32),
          // Botón registrar mascota
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Al crear la mascota lanza una confirmación
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text("Mascota creada con éxito"),
                      ],
                    ),
                    backgroundColor: Colors.green[700],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Registrar Mascota",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
