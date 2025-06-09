import 'dart:convert';
import 'package:clinica_app/pages/utils/appConfig.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

// Define la clase _SignUpState, que representa el estado mutable del widget SignUp.
class _SignUpState extends State<SignUp> {
  //
  final _formKey = GlobalKey<FormState>(); 
  // Define una variable para mantener el valor seleccionado del DropdownButtonFormField para el género.
  bool _obscureText = true; // Added to manage password visibility
  final dniController = TextEditingController();
  final contrasenaController = TextEditingController();
  final nombreController = TextEditingController();
  final apellidosController = TextEditingController();
  final emailController = TextEditingController();
  final telefonoController = TextEditingController();
  //Definición expresiones regulares (Regex)
  // Expresiones regulares
  final RegExp dniRegex = RegExp(r'^[0-9]{8}[A-Za-z]$');
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final RegExp telefonoRegex = RegExp(r'^(\+|00)[0-9]{1,5}(?:[ -]?[0-9]{3,}){2,}$');

  String? validarDNI(String? value) {
    if (value == null || value.isEmpty) return 'DNI obligatorio';
    if (!dniRegex.hasMatch(value)) return 'Formato inválido (Ej: 12345678A)';
    return null;
  }

  String? validarEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email obligatorio';
    if (!emailRegex.hasMatch(value)) return 'Formato inválido (Ej: carmen@gmail.com)';
    return null;
  }

  String? validarTelefono(String? value) {
    if (value == null || value.isEmpty) return 'Teléfono obligatorio';
    if (!telefonoRegex.hasMatch(value)) return 'Formato inválido (Ej: +34 666303491)';
    return null;
  }
  @override
  Widget build(BuildContext context) {
    // Devuelve un Scaffold, que proporciona la estructura visual básica para la pantalla.
    return Scaffold(
      // Define el AppBar, la barra superior de la app.
      appBar: AppBar(
        // Define el color de fondo del AppBar como verde.
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
        // Define el título del AppBar como "Nueva Alta" con un estilo de texto específico.
        title: const Text(
          "Nueva Alta",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1, // Espaciado entre letras
            shadows: [
              Shadow(
                color: Colors.black45,
                offset: Offset(1, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ),
      // Define el cuerpo de la pantalla como un Stack.
      // Stack permite que los widgets se superpongan entre sí.
      body: Form( // Envuelve todo en un Form
      key: _formKey,
      child: Stack(
        // Define una lista de widgets hijos para el Stack.
        children: [
          // Widget Positioned.fill para ocupar todo el espacio disponible.
          Positioned.fill(
            // Widget Image.network para mostrar una imagen desde una URL.
            child: Image.network(
              'https://consultaveterinarialatorre.com/imagenes/89/empresas/Img-481221-2_amp.jpg',
              // Define cómo se debe ajustar la imagen dentro del espacio disponible.
              fit: BoxFit.cover,
            ),
          ),

          // Widget Positioned.fill para ocupar todo el espacio disponible.
          Positioned.fill(
            // Widget Container para aplicar un color de fondo semitransparente.
            child: Center(
              // Widget SingleChildScrollView para permitir el desplazamiento si el contenido no cabe en la pantalla.
              child: SingleChildScrollView(
                // Define un relleno simétrico vertical de 20 píxeles.
                padding: const EdgeInsets.symmetric(vertical: 20),
                // Widget Container para contener el formulario de registro.
                child: Container(
                  // Define un relleno de 20 píxeles en todos los lados.
                  padding: const EdgeInsets.all(20),
                  // Define el ancho del contenedor como el 85% del ancho de la pantalla.
                  width: MediaQuery.of(context).size.width * 0.85,
                  // Define la decoración del contenedor, incluyendo el color de fondo, los bordes y el radio de la esquina.
                  decoration: BoxDecoration(
                    // Define el color de fondo como blanco con una opacidad del 30%.
                    color: Colors.black.withOpacity(0.3),
                    // Define el radio de la esquina como 10 píxeles.
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // Widget Column para organizar los widgets hijos verticalmente.
                  child: Column(
                    // Define el tamaño principal del eje como mínimo.
                    mainAxisSize: MainAxisSize.min,
                    // Define una lista de widgets hijos para la Columna.
                    children: [
                      // Widget TextFormField para el campo DNI.
                      TextFormField(
                        controller: dniController,//controaldor API
                        //validar formato con regex
                        validator: validarDNI,
                        // Define la decoración del campo, incluyendo la etiqueta, el estilo de la etiqueta, el borde y el icono.
                        decoration: const InputDecoration(
                          labelText: "DNI",
                          labelStyle: TextStyle(color: Colors.white),
                          floatingLabelStyle: TextStyle(color: Colors.blue),//cambiar el color del labeltext, cuando esta flotando
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightBlueAccent),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          errorBorder: UnderlineInputBorder( // Borde rojo cuando hay error
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: UnderlineInputBorder( // Borde rojo cuando hay error y está enfocado
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          prefixIcon: Icon(Icons.badge, color: Colors.white),
                        ),
                        // Define el estilo del texto como blanco.
                        style: const TextStyle(color: Colors.white),
                      ),
                      // Widget SizedBox para añadir un espacio vertical de 15 píxeles.
                      const SizedBox(height: 15),
            
                      // Widget TextFormField para el campo Contraseña.
                      TextFormField(
                        controller: contrasenaController,//controaldor API
                        // Habilita el texto oculto.
                        obscureText: _obscureText,
                        // Define la decoración del campo, incluyendo la etiqueta, el estilo de la etiqueta, el borde y el icono.
                        decoration:  InputDecoration(
                          labelText: "Contraseña",
                          labelStyle: TextStyle(color: Colors.white),
                          floatingLabelStyle: TextStyle(color: Colors.blue),//cambiar el color del labeltext, cuando esta flotando
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightBlueAccent),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          prefixIcon: Icon(Icons.lock, color: Colors.white),
                          suffixIcon: IconButton(
                              icon: Icon(
                                // Cambiar icono ojo abierto y cerrado
                                _obscureText ? Icons.visibility : Icons.visibility_off,
                                color: _obscureText ? Colors.white: Colors.lightBlueAccent, // Establece color azul si _obscureText es falso
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText; // cambiar visibilidad
                                });
                              },
                            ),
                          ),
                        // Define el estilo del texto como blanco.
                        style: const TextStyle(color: Colors.white),
                      ),
                      // Widget SizedBox para añadir un espacio vertical de 15 píxeles.
                      const SizedBox(height: 15),
            
                      // Widget TextFormField para el campo Nombre.
                      TextFormField(
                        controller: nombreController,//controaldor API
                        // Define la decoración del campo, incluyendo la etiqueta, el estilo de la etiqueta, el borde y el icono.
                        decoration: const InputDecoration(
                          labelText: "Nombre",
                          labelStyle: TextStyle(color: Colors.white),
                          floatingLabelStyle: TextStyle(color: Colors.blue),//cambiar el color del labeltext, cuando esta flotando
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightBlueAccent),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          prefixIcon: Icon(Icons.person, color: Colors.white),
                        ),
                        // Define el estilo del texto como blanco.
                        style: const TextStyle(color: Colors.white),
                      ),
                      // Widget SizedBox para añadir un espacio vertical de 15 píxeles.
                      const SizedBox(height: 15),
            
                      // Widget TextFormField para el campo Apellidos.
                      TextFormField(
                        controller: apellidosController,//controaldor API
                        // Define la decoración del campo, incluyendo la etiqueta, el estilo de la etiqueta, el borde y el icono.
                        decoration: const InputDecoration(
                          labelText: "Apellidos",
                          labelStyle: TextStyle(color: Colors.white),
                          floatingLabelStyle: TextStyle(color: Colors.blue),//cambiar el color del labeltext, cuando esta flotando
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightBlueAccent),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          prefixIcon: Icon(Icons.person_outline, color: Colors.white),
                        ),
                        // Define el estilo del texto como blanco.
                        style: const TextStyle(color: Colors.white),
                      ),
                      // Widget SizedBox para añadir un espacio vertical de 15 píxeles.
                      const SizedBox(height: 15),
            
                      // Widget TextFormField para el campo Email.
                      TextFormField(
                        controller: emailController,//controaldor API
                        //validar formato
                        validator: validarEmail,
                        // Define la decoración del campo, incluyendo la etiqueta, el estilo de la etiqueta, el borde y el icono.
                        decoration: const InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(color: Colors.white),
                          floatingLabelStyle: TextStyle(color: Colors.blue),//cambiar el color del labeltext, cuando esta flotando
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightBlueAccent),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          errorBorder: UnderlineInputBorder( // Borde rojo cuando hay error
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: UnderlineInputBorder( // Borde rojo cuando hay error y está enfocado
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          prefixIcon: Icon(Icons.email, color: Colors.white),
                        ),
                        // Define el estilo del texto como blanco.
                        style: const TextStyle(color: Colors.white),
                      ),
                      // Widget SizedBox para añadir un espacio vertical de 15 píxeles.
                      const SizedBox(height: 15),
            
                      // Widget TextFormField para el campo Telefono.
                      TextFormField(
                        controller: telefonoController,//controaldor API
                        validator: validarTelefono,
                        // Define la decoración del campo, incluyendo la etiqueta, el estilo de la etiqueta, el borde y el icono.
                        decoration: const InputDecoration(
                          labelText: "Nº Teléfono",
                          labelStyle: TextStyle(color: Colors.white),
                          floatingLabelStyle: TextStyle(color: Colors.blue),//cambiar el color del labeltext, cuando esta flotando
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightBlueAccent),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          errorBorder: UnderlineInputBorder( // Borde rojo cuando hay error
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: UnderlineInputBorder( // Borde rojo cuando hay error y está enfocado
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          prefixIcon: Icon(Icons.phone, color: Colors.white),
                        ),
                        // Define el estilo del texto como blanco.
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 20),
            
                      // Botón Registrarse
                      ElevatedButton(
                        onPressed: () {
                          // Acción al presionar "Registrarme"
                          //valida que todos los campos tienen un formato válido
                          if (_formKey.currentState!.validate()) {
                            registrarUsuario();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "REGISTRARME",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
  Future<void> registrarUsuario() async {
  final url = Uri.parse('${AppConfig.baseUrl}/usuarios'); // Cambia la URL si usas dispositivo físico

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "dni": dniController.text,
      "nombre": nombreController.text,
      "apellidos": apellidosController.text,
      "email": emailController.text,
      "telefono": telefonoController.text,
      "contrasena": contrasenaController.text,
    }),
  );

  if (response.statusCode == 201) {
    // Usuario creado correctamente
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('¡Usuario registrado con éxito!'))
    );
    // Posible acción de navegación de vuelta al Login(por ahora ha fallado)
  } else {
    // Error al registrar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${response.statusCode} - ${response.body}'))    
    );
  }
}
}